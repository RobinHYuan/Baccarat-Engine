onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Error
add wave -noupdate /tb_task5/err
add wave -noupdate -divider {Fast Clock}
add wave -noupdate /tb_task5/CLOCK_50
add wave -noupdate -divider {Slow Clock}
add wave -noupdate {/tb_task5/DUT/KEY[0]}
add wave -noupdate -divider Reset
add wave -noupdate {/tb_task5/KEY[3]}
add wave -noupdate -divider {7 Seg Display}
add wave -noupdate /tb_task5/HEX5
add wave -noupdate /tb_task5/HEX4
add wave -noupdate /tb_task5/HEX3
add wave -noupdate /tb_task5/HEX2
add wave -noupdate /tb_task5/HEX1
add wave -noupdate /tb_task5/HEX0
add wave -noupdate -divider State
add wave -noupdate /tb_task5/DUT/sm/current_state
add wave -noupdate -divider {Player Load}
add wave -noupdate /tb_task5/DUT/load_pcard1
add wave -noupdate /tb_task5/DUT/load_pcard2
add wave -noupdate /tb_task5/DUT/load_pcard3
add wave -noupdate -divider {Dealer Load}
add wave -noupdate /tb_task5/DUT/load_dcard1
add wave -noupdate /tb_task5/DUT/load_dcard2
add wave -noupdate /tb_task5/DUT/load_dcard3
add wave -noupdate -divider {Player Card}
add wave -noupdate /tb_task5/DUT/dp/pcard1_out
add wave -noupdate /tb_task5/DUT/dp/pcard2_out
add wave -noupdate /tb_task5/DUT/dp/pcard3_out
add wave -noupdate -divider {Dealer Card}
add wave -noupdate /tb_task5/DUT/dp/dcard1_out
add wave -noupdate /tb_task5/DUT/dp/dcard2_out
add wave -noupdate /tb_task5/DUT/dp/dcard3_out
add wave -noupdate -divider Scores
add wave -noupdate /tb_task5/DUT/dp/pscore_out
add wave -noupdate /tb_task5/DUT/dp/dscore_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 213
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {872 ps}
