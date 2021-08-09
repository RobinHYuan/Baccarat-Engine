# Baccarat-Engine

## 1 Introduction:
In this lab, I will be using System Verilog to design a simple Baccarat Engine on a DE1-Soc Board via implementing a simple datapath and a finite state machine.

### 1.1 Lab Handout:
https://github.com/RobinHYuan/CPEN311-LAB1/files/6491478/CPEN311_LAB_Handout.pdf

------------

## 2 Important Files:
* **dealcard.sv** &nbsp; &nbsp;  &nbsp;  &nbsp;&nbsp; and **tb_dealcard.sv**
* **scorehand.sv** &nbsp;  &nbsp; &nbsp; and **tb_scorehand.sv**
* **datapath.sv** &nbsp;  &nbsp; &nbsp;  &nbsp; and **tb_datapath.sv**
* **statemachine.sv**&nbsp; and **tb_statemachine.sv**
* **task5.sv** &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; and **tb_task5**
* **task5.qsf**
* **DE1_SoC.qsf**

------------
## 3 Design Approach:
### 3.1 Overview:


My design is consist of the following modules: `dealcard`, `card7seg`, `scorehand`, `statemachine`, `datapath` and `task5` where `task5` is the top module of the design. The engine contains a slow_clock (KEY0) and an active-low synchronous rest (KEY3).

Modules, `card7seg`, and`scorehand` are purely combinational and instantiated in the module, `datapath`. In addition, module, `datapath` also contains 6 instantiations of a hypothetical module, `reg4`. The module code of `reg 4` is included in datapath.sv; however, its instantiations are replaced by an always block and a case statement in order to cope with the rubric of using behavioural system verilog.

The module `statemachine` acts as the brain of the game in which it controls when to turn on /off each load instructions for `reg4` in `datapath`. It also annouces the final result.


### 3.2 Design Hierarchy:

```
├── task5
│   └──datapath
│       ├── dealcard
│       ├── scorehand
│       ├── card7seg
│       └── reg4 (Hypothetical)
└── Statemachine

```

<p align="center"><img src="https://user-images.githubusercontent.com/68177491/119202244-3df66600-ba45-11eb-9ab8-353f749094fe.jpg" width="70%" height="70%" title="block diagram"></p>

<p align="center">
   <b>Figure 1: Block Diagram</b>
</p>
  
### 3.3 Functions of Each Module:

#### 3.3.1 task5
The top of module of the design is `task5`. Two modules are instantiated inside task5 which are `statemachine` and `datapath`. It ensures these two modules are wired correctly, and they can properly communicate with each other. In addtion, `task5` is also responsible for handling the DE1-SoC I/Os including LEDR[0-9], HEX0-HEX5, KEY[0] and KEY[3].

#### 3.3.2 datapath
The majority of computing is done by `datapath`. Three modules: `dealcard`, `scorehand`, `card7seg` are instantiated inside `datapath`. See the block digram for more details.
 
#### 3.3.3 dealcard
`dealcard` is responsible for dealing out the cards. The cards drew by the player/dealer need to be random to ensure the integrity on the game. However, it is difficult to generate random numbers in hardware. Therefore, we will design the module as a **counter**  and it should have the following behaviours:
- Low-active synchronous reset (After reset, it will count from A to K )
- Increment at every posedge of fast_clock if count/deal_card < 13; if it is equal to 13, it should go back to 1 and continue incrementing at the next posedge.
- The card will be loaded to whichever reg4 that has a logic high on load (it is usually when the users press KEY0/slow_clock)
- The card drew by the player/dealer is thus random as the time period between when the users press the KEY0 and press the rest is random.
- However, it is still predictable if you count the fast_clock cycle when simulating it. It only appears to be random to the users.

#### 3.3.4 scorehand
`scorehand` is used to compute the score of dealer and player. It uses the output of `reg4` as inputs and evaluates the score according to **Table 4.1**.

#### 3.3.5 card7seg
`card7seg` is a driver for the seven-segment display. It is purely combinational and follows the rule shown in the figure below.

<p align="center"><img src="https://user-images.githubusercontent.com/68177491/119205237-93824100-ba4c-11eb-8f6d-018e74b939c7.png" width="20%" height="20%" title="block diagram"></p>

<p align="center">
   <b>Figure 2:  7-seg Display</b>
</p>

#### 3.3.6 reg4
`reg4` is NOT instantiated in my modulel. Their instantiations are replace by a block of SV Behavioral Description using always + case statements. The module is saved inside `datapath.sv` for reference. It might help you to understand the behavioral Description. `reg4` is a load-and-reset-enabled d-flip-flop. The load signal of each `reg4` is controlled by the statemachine. It will load the newcard issued by `dealcard` whenever  the load is high.

#### 3.3.6 statemachine
`statemachine` controls how the data flows in `datapath`; in other words, it decides who and when gets a card. The state trasintions need to follow 4.2 Sequence and 4.3 Drawing Rules. My state machine has 8 states in total, which are:
```  
    `define reset   3'b000
    `define card_P1 3'b001
    `define card_D1 3'b010
    `define card_P2 3'b011
    `define card_D2 3'b100
    `define card_P3 3'b101 
    `define card_D3 3'b110
    `define halt    3'b111
```
Reset state is used to set all outputs of all 6 of `reg4` to zeros when we re-start the game whereas the halt state is used to declare the game result.

------------

## 4 How to Play Baccarat:

There are various versions of Baccarat, but we will focus on the simplest, called Punto Banco. The following text will describe the algorithm in sufficient detail for completing this lab


###  Tabele 4.1 (Score Conversion) :
| Score | Cards | 
| ------------- | ------------- |
| 0 | 10 - K  |
| 1 - 9 | A &nbsp;- 9|
 

In other words, each Ace, 2, 3, 4, 5, 6, 7, 8, and 9 has a value equal the face value (eg. Ace has value of 1, 2 is a value of 2, 3 has a value of 3, etc.). Tens, Jacks, Queens, and Kings have a value of 0.

### 4.2 Sequence: 
```
Player 1st Card -> Dealer 1st Card -> Player 2nd Card  -> Dealer 2nd Card ├──> Player 3rd Card ├──> Dealer 3rd Card -> END     |
                                                                          |                    └──> END                        |
                                                                          ├──> Dealer 3rd Card -> END                          |
                                                                          └──> END                                             |
```
### Table 4.3 (Drawing Rules) :
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

If either the player or banker or both achieve a total of 8 or 9 after they both receive their second cards, the result is announced: a player-win, a banker-win, or a tie. If neither side has eight or nine, the drawing rules are applied to determine whether the player should receive a third card. Then, based on the value of the card drawn by the player, the drawing rules are applied to determine whether the banker should receive a third card. The coup is then finished, the outcome is announced.

------------
## Best Girl Ever - Matou Sakura (Completely Unrelated):
<p align="center"><img src="https://user-images.githubusercontent.com/68177491/118439998-de423880-b69b-11eb-9c48-a081b97f6286.jpg" width="50%" height="50%" title="block diagram"></p>
