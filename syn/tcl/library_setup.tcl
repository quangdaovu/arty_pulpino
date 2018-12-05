
set search_path { \
}

set mem_libs { }
#    sp_8192x32_SS.db \

set std_cell "" 

set target_library $std_cell
set synthetic_library dw_foundation.sldb
set link_library [concat * $std_cell $mem_libs $synthetic_library]

set_dont_use [get_lib_cells */DEL*]

