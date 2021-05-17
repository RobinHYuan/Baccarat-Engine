onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_datapath/err
add wave -noupdate -divider {Clock and !Reset}
add wave -noupdate /tb_datapath/DUT/fast_clock
add wave -noupdate /tb_datapath/DUT/slow_clock
add wave -noupdate /tb_datapath/DUT/resetb
add wave -noupdate -divider {Player's Card}
add wave -noupdate /tb_datapath/DUT/pcard1_out
add wave -noupdate /tb_datapath/DUT/pcard2_out
add wave -noupdate /tb_datapath/DUT/pcard3_out
add wave -noupdate -divider {Dealer's Card}
add wave -noupdate /tb_datapath/DUT/dcard1_out
add wave -noupdate /tb_datapath/DUT/dcard2_out
add wave -noupdate /tb_datapath/DUT/dcard3_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 310
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {140 ps}
