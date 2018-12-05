// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


#include <spi.h>
#include <gpio.h>
#include <uart.h>
#include <utils.h>
#include <pulpino.h>

const char g_numbers[] = {
                           '0', '1', '2', '3', '4', '5', '6', '7',
                           '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
                         };

void auto_boot();
void display_menu();
void write_flash();
int check_spi_flash(int quad);
void send_flash_command(char quad, char cmd, int addr, int addr_len, int datalen, char read);

//void print_value(int in);
//#ifndef OLD_JUMP_AND_START 
//void jump_and_start(volatile int *ptr);
//#else 
void (*jump_and_start)(void);
//#endif 

int main()
{
  char c;

  /* sets direction for SPI master pins with only one CS */
  spi_setup_master(1);
  uart_set_cfg(0, 26);

  /* divide sys clock by 4 */
  *(volatile int*) (SPI_REG_CLKDIV) = 0x4;

  for (int i = 3; i >= 0; i--)
  {
    c = uart_getchar_timeout(5000000);

    if (c == '\0')
    {
      if (i == 0)
      {
        uart_send("\n", 1);
        auto_boot();
      }
      else
      {
        uart_send("\rAuto boot from SPI Flash will start after ", 43);
        uart_send(&g_numbers[i], 1);
        uart_send(" seconds", 8);
        uart_wait_tx_done();
      }
    }
    else
    {
      uart_send("\n", 1);
      display_menu();
    }
  }  
}

void auto_boot()
{  
  // Write enable
  send_flash_command(0, 0x06, 0, 0, 0, 0);
  while ((spi_get_status() & 0xFFFF) != 1);

  // enables QPI
  spi_setup_cmd_addr(0x61, 8, 0x5F, 8);
  spi_set_datalen(0);
  spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
  while ((spi_get_status() & 0xFFFF) != 1);

  //-----------------------------------------------------------
  // Read Instruction RAM
  //-----------------------------------------------------------
  uart_send("Copying Instructions\n", 21);
  uart_wait_tx_done();

  // Instruction Memory start from 0xFF0000 to 0xFF7FFF (32KB)
  int addr = 0xFF0000;
  int *instr = (int *)0x0;

  //reads 8 4KB blocks
  spi_setup_dummy(8, 0);
  for (int i = 0; i < 8; i++)
  {
    // cmd 0xEB fast read, needs 8 dummy cycles
    send_flash_command(1, 0xEB, addr, 32, 32768, 1);
    spi_read_fifo(instr, 32768);

    instr += 0x400;  // new address = old address + 1024 words
    addr  += 0x1000; // new address = old address + 4KB
  }
  while ((spi_get_status() & 0xFFFF) != 1);

  //-----------------------------------------------------------
  // Read Data RAM
  //-----------------------------------------------------------
  uart_send("Copying Data\n", 13);
  uart_wait_tx_done();

  // Data Memory start from 0xFF8000 to 0xFFFFFF (32KB)
  addr = 0xFF8000;  
  int *data = (int *)0x100000;

  //reads 8 4KB blocks
  spi_setup_dummy(8, 0);
  for (int i = 0; i < 8; i++) 
  { 
    // cmd 0xEB fast read, needs 8 dummy cycles
    send_flash_command(1, 0xEB, addr, 32, 32768, 1);
    spi_read_fifo(data, 32768);

    data += 0x400;  // new address = old address + 1024 words
    addr += 0x1000; // new address = old address + 4KB
  }

  uart_send("Done, jumping to Instruction RAM.\n", 34);
  uart_wait_tx_done();

  //-----------------------------------------------------------
  // Set new boot address -> exceptions/interrupts/events rely
  // on that information
  //-----------------------------------------------------------
  BOOTREG = 0x00;

  //-----------------------------------------------------------
  // Done jump to main program
  //-----------------------------------------------------------

  //jump to program start address (instruction base address)
//#ifndef OLD_JUMP_AND_START 
  // cause simulation hang-up, why ??
//  jump_and_start((volatile int *)(INSTR_RAM_START_ADDR));
//#else
  jump_and_start = (void(*)(void))INSTR_RAM_START_ADDR;
  jump_and_start();
//#endif
}

void write_flash()
{
  int *instr = (int *)0x0;
  int *data = (int *)0x100000;

  // SPI doesn't work after copy instruction - idk why
  // Therefore Flash should be reset here
  // Reset in SPI mode first
  // sends reset enable
  send_flash_command(0, 0x66, 0, 0, 0, 0);
  while ((spi_get_status() & 0xFFFF) != 1);
  
  // sends reset
  send_flash_command(0, 0x99, 0, 0, 0, 0);
  while ((spi_get_status() & 0xFFFF) != 1);

  // Reset again in QSPI mode - just to make sure
  // sends reset enable
  send_flash_command(1, 0x66, 0, 0, 0, 0);
  while ((spi_get_status() & 0xFFFF) != 1);
  
  // sends reset
  send_flash_command(1, 0x99, 0, 0, 0, 0);
  while ((spi_get_status() & 0xFFFF) != 1);

  // Clear last sector
  int addr = 0xFF0000;
  uart_send("Clear memory\n", 13);

  // sends write enable command
  send_flash_command(0, 0x06, 0, 0, 0, 0);  // Write enable
  while ((spi_get_status() & 0xFFFF) != 1);

  send_flash_command(0, 0xD8, addr, 24, 0, 0); // Erase
  while ((spi_get_status() & 0xFFFF) != 1);

  while (check_spi_flash(0))
  {
    //uart_send(".", 1);
    sleep_busy(1000000);
  }
  uart_send("\n", 1);
  
/*
  // Enable QSPI
  send_flash_command(0, 0x06, 0, 0, 0, 0);  // Write enable
  while ((spi_get_status() & 0xFFFF) != 1);

  spi_setup_cmd_addr(0x61, 8, 0x5F, 8); // enables QPI
  spi_set_datalen(0);
  spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
  while ((spi_get_status() & 0xFFFF) != 1);
*/

  uart_send("Write Instruction Memory content to SPI flash\n", 46);
  uart_wait_tx_done();

  for (int i = 0; i < 128; i++) 
  {  
    // sends write enable command
    send_flash_command(0, 0x06, 0, 0, 0, 0);  // Write enable
    while ((spi_get_status() & 0xFFFF) != 1);

    // cmd 0x02 page write
    send_flash_command(0, 0x02, addr, 24, 1024, 0);
    spi_write_fifo(instr, 1024);
    while ((spi_get_status() & 0xFFFF) != 1);

    instr += 0x20;
    addr  += 0x80;

    while (check_spi_flash(0))
    {
      uart_send(".", 1);
      uart_wait_tx_done();
      sleep_busy(100000);
    }
  }

  uart_send("\n\n", 2);
  uart_send("Write Data Memory content to SPI flash\n", 41);
  uart_wait_tx_done();
  addr = 0xFF8000;

  for (int i = 0; i < 128; i++) 
  {  
    // sends write enable command
    send_flash_command(0, 0x06, 0, 0, 0, 0);
    while ((spi_get_status() & 0xFFFF) != 1);

    // cmd 0x02 page write
    send_flash_command(0, 0x02, addr, 24, 1024, 0);
    spi_write_fifo(data, 1024);
    while ((spi_get_status() & 0xFFFF) != 1);

    data += 0x20;
    addr += 0x80;

    while (check_spi_flash(0))
    {
      uart_send(".", 1);
      uart_wait_tx_done();
      sleep_busy(100000);
    }
  }

  uart_send("Done!\n", 6);
  uart_wait_tx_done();
  display_menu();
}


void display_menu() 
{
  char c;

  uart_send(" Press 1 to start execution from start of Instruction memory\n", 61);
  uart_wait_tx_done();
  uart_send(" Press 2 to copy program from SPI flash\n", 40);
  uart_wait_tx_done();
  uart_send(" Press 3 to write program to SPI flash\n", 39);
  uart_wait_tx_done();
  uart_send(" Or press anykey to display this menu again\n", 44);
  uart_wait_tx_done();
  

  c = uart_getchar();

  if (c == '1')
  {
      BOOTREG = 0x00;

      jump_and_start = (void(*)(void))INSTR_RAM_START_ADDR;
      jump_and_start();
  }
  else if (c == '2')
    auto_boot();
  else if (c == '3')
    write_flash();
  else 
    display_menu();
}

int check_spi_flash(int quad) {
  int rd_status;
  int rd_flag;
  int ret = 0;

  // reads flash status
  send_flash_command(quad, 0x05, 0, 0, 32, 1);
  spi_read_fifo(&rd_status, 32);
  while ((spi_get_status() & 0xFFFF) != 1);

  // reads flash flag    
  send_flash_command(quad, 0x70, 0, 0, 32, 1);
  spi_read_fifo(&rd_flag, 32);
  while ((spi_get_status() & 0xFFFF) != 1);

/*
  unsigned int d1, d2, d3, d4;
  uart_send("0x05 = ", 7);
  d1 =  rd_status & 0xF;
  d2 = (rd_status >> 4) & 0xF; // /16
  
  uart_send(&g_numbers[d2], 1);
  uart_send(&g_numbers[d1], 1);
  uart_send("\n", 1);
  
  uart_send("0xE8 = ", 7);
  d3 =  rd_flag & 0xF;
  d4 = (rd_flag >> 4) & 0xF; // /16
  uart_send(&g_numbers[d4], 1);
  uart_send(&g_numbers[d3], 1);
  uart_send("\n", 1);
*/

  if ((rd_flag & 0x7F) || (rd_status & 0xFF))
    ret++;

  return ret;
}

//#ifndef OLD_JUMP_AND_START
/*
void jump_and_start(volatile int *ptr)
{
#ifdef __riscv__
  asm("jalr x0, %0\n"
      "nop\n"
      "nop\n"
      "nop\n"
      : : "r" (ptr) );
#else
  asm("l.jr\t%0\n"
      "l.nop\n"
      "l.nop\n"
      "l.nop\n"
      : : "r" (ptr) );
#endif
}
*/
//#endif

void send_flash_command(char quad, char cmd, int addr, int addr_len, int datalen, char read)
{
  spi_setup_cmd_addr(cmd, 8, ((addr << 8) & 0xFFFFFF00), addr_len);
  spi_set_datalen(datalen);
  if (quad > 0)
    if (read > 0)
      spi_start_transaction(SPI_CMD_QRD, SPI_CSN0);
    else
      spi_start_transaction(SPI_CMD_QWR, SPI_CSN0);
  else
    if (read > 0)
      spi_start_transaction(SPI_CMD_RD, SPI_CSN0);
    else
      spi_start_transaction(SPI_CMD_WR, SPI_CSN0);
}

/*
void print_value(int in)
{
  unsigned int d1, d2, d3, d4;

  d1 = (in >> 16)& 0xF;
  d2 = (in >> 20) & 0xF; // /16
  d3 = (in >> 24) & 0xF; // /16
  d4 = (in >> 28) & 0xF; // /16

  uart_send(&g_numbers[d4], 1);
  uart_send(&g_numbers[d3], 1);
  uart_send(&g_numbers[d2], 1);
  uart_send(&g_numbers[d1], 1);

  d1 =  in & 0xF;
  d2 = (in >> 4) & 0xF; // /16
  d3 = (in >> 8) & 0xF; // /16
  d4 = (in >> 12) & 0xF; // /16
  
  uart_send(&g_numbers[d4], 1);
  uart_send(&g_numbers[d3], 1);
  uart_send(&g_numbers[d2], 1);
  uart_send(&g_numbers[d1], 1);
  uart_send("\n", 1);
}
*/