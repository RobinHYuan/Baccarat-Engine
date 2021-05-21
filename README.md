# CPEN311 LAB1 (Stil Under Construction)

## Introduction:
In this lab, I will be using System Verilog to design a simple Baccarat Engine on a DE1-Soc Board via implementing a simple datapath and a finite state machine.

## Lab Handout:
https://github.com/RobinHYuan/CPEN311-LAB1/files/6491478/CPEN311_LAB_Handout.pdf

------------

## Important Files:
* **dealcard.sv** &nbsp; &nbsp;  &nbsp;  &nbsp;&nbsp; and **tb_dealcard.sv**
* **scorehand.sv** &nbsp;  &nbsp; &nbsp; and **tb_scorehand.sv**
* **datapath.sv** &nbsp;  &nbsp; &nbsp;  &nbsp; and **tb_datapath.sv**
* **statemachine.sv**&nbsp; and **tb_statemachine.sv**
* **task5.sv** &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; and **tb_task5**
* **task5.qsf**
* **DE1_SoC.qsf**

------------
## Design Approach:
#### Overview:


My design is consist of the following modules: `dealcard`, `card7seg`, `scorehand`, `statemachine`, `datapath` and `task5` where the module `task5` is the top module of the design. The engine contains a slow_clock (KEY0) and an active-low asynchronous rest (KEY3).

Modules, `dealcard`, `card7seg`, and`scorehand` are purely combinational and instantiated in the module, `datapath`. In addition, module, `datapath` also contains 6 instantiations of a hypothetical module, `reg4`. The module code of `reg 4` is included in datapath.sv; however, its instantiations are replaced by an always block and a case statement in order to cope with the rubric of using behavioural system verilog.

The module `statemachine` acts as the brain of the game in which it controls when to turn on /off each load instructions for `reg4` in `datapath`. It also annouces the final result.

#### Design Hierarchy:

```
├── task5
│   └──datapath
│       ├── dealcard
│       ├── scorehand
│       ├── card7seg
│       └── reg4 (Hypothetical)
└── Statemachine

```


------------

## How to Play Baccarat:
####  Tabele 1: Score Conversion
| Score | Cards | 
| ------------- | ------------- |
| 0 | 10 - K  |
| 1 - 9 | A &nbsp;- 9|

#### Table 2: Drawing Rules
| Score of First Two Cards | Player | Dealer |
| ------------- | ------------- |-------------|
| 0 | Draws a third card  |Draws a third card |
| 1 | Draws a third card  |Draws a third card |
| 2 | Draws a third card  |Draws a third card |P
| 3 | Draws a third card  |Draws a third card: <br />- If the face value of `Player's Third Card` is NOT `8` or <br /> - If the `Player's Score of First Two Cards` is `6 or 7`|
| 4 | Draws a third card  |Draws a third card: <br />- If the face value of `Player's Third Card` is NOT `0,1,8 or 9` or<br /> - If the `Player's Score of First Two Cards` is `6 or 7`|
| 5 | Draws a third card  |Draws a third card: <br />- If the face value of `Player's Third Card` is NOT `0,1,2,3,8,9` or<br /> - If the `Player's Score of First Two Cards` is `6 or 7`|
| 6 | Does NOT draw a third card|Draws a third card: <br />- If the face value of `Player's Third Card` is  `6 or 7`|
| 7 | Does NOT draw a third card|Does NOT draw a third card|
| 8 | Does NOT draw a third card|Does NOT draw a third card|
| 9 | Does NOT draw a third card|Does NOT draw a third card|

Total Score = \[Score of Card 1  + Score of Card 2 + Score of Card 3 (if it exits) \]  % 10

If either the player or banker or both achieve a total of 8 or 9 after they both receive their second cards, the result is announced: a player win, a banker win, or tie. If neither hand has eight or nine, the drawing rules are applied to determine whether the player should receive a third card. Then, based on the value of any card drawn to the player, the drawing rules are applied to determine whether the banker should receive a third card. The coup is then finished, the outcome is announced.

------------
## Best Girl Ever - Matou Sakura (Completed Unrelated):
<img src="https://user-images.githubusercontent.com/68177491/118439998-de423880-b69b-11eb-9c48-a081b97f6286.jpg" width="478" height="700"/>
