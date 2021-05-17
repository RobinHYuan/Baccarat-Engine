onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider State
add wave -noupdate /tb_statemachine/DUT/current_state
add wave -noupdate -divider {Clock and Reset}
add wave -noupdate /tb_statemachine/slow_clock
add wave -noupdate /tb_statemachine/resetb
add wave -noupdate -divider Error
add wave -noupdate /tb_statemachine/err
add wave -noupdate -divider {Player Load}
add wave -noupdate /tb_statemachine/load_pcard1
add wave -noupdate /tb_statemachine/load_pcard2
add wave -noupdate /tb_statemachine/load_pcard3
add wave -noupdate -divider {Dealer Load}
add wave -noupdate /tb_statemachine/load_dcard1
add wave -noupdate /tb_statemachine/load_dcard2
add wave -noupdate /tb_statemachine/load_dcard3
add wave -noupdate -divider Scores
add wave -noupdate /tb_statemachine/pscore_out
add wave -noupdate /tb_statemachine/dscore_out
add wave -noupdate -divider {Player's 3rd Card}
add wave -noupdate /tb_statemachine/pcard3_out
add wave -noupdate -divider {Game Results}
add wave -noupdate /tb_statemachine/player_win_light
add wave -noupdate /tb_statemachine/dealer_win_light
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {122 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 216
configure wave -valuecolwidth 149
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
WaveRestoreZoom {114 ps} {184 ps}
