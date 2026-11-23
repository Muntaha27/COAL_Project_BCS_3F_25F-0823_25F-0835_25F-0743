SUPER BUNNY MEADOW - 16-BIT x86 ASSEMBLY PLATFORMER

Course: EL2003 - Computer Organization and Assembly Language (COAL)
Platform: 16-bit x86 Real Mode (.COM, ORG 100h) on DOSBox (v0.74-3 or later)
Assembler: NASM

TEAM MEMBERS AND MODULE DISTRIBUTION

Member 1: Muntaha Shafiq (25F-0823)
Role: Core engine, input, and collision systems (Modules 1, 4, 7, 10, 13)

Phase 1 - Module 1: Program Skeleton and Build Setup

Phase 2 - Module 4: Sprites (16x16 & 16x32 bitmaps, mirror flip, clipping)

Phase 3 - Module 7: Keyboard Interrupt Handler (custom INT 09h ISR)

Phase 4 - Module 10: Collision Detection (tiles, pipes, coins, pit, flag)

Phase 4 - Module 13: Score, Health, Lives and HUD (32-bit score & hearts)

Member 2: Ariba Najam (25F-0835)
Role: Graphics pipeline, physics, and enemy AI (Modules 2, 5, 8, 9, 11)

Phase 1 - Module 2: Video Mode and Colours (VGA Mode 13h, fill_rect)

Phase 2 - Module 5: Frame Buffer and Block Operations (CS + 1000h buffer)

Phase 3 - Module 8: Timer and Game Clock (custom INT 08h ISR)

Phase 3 - Module 9: Player Movement and Physics (8.8 fixed-point movement)

Phase 4 - Module 11: Enemies and Shells (Hedgehog & Beetle AI, shells)

Member 3: Jannat Ijaz (25F-0743)
Role: World map, scrolling camera, power-ups, and integration (Modules 3, 6, 12, 14, 15)

Phase 1 - Module 3: Level Map and Tile Drawing (64x12 map & ResetMap)

Phase 2 - Module 6: Camera and Scrolling (monotonic scrolling camera)

Phase 4 - Module 12: Blocks, Coins and Power-ups (Golden Carrot & 1-UP)

Phase 5 - Module 14: Game States, Screens and Menus (state jump table)

Phase 5 - Module 15: Win, Lose, Restart and Clean Exit

HOW TO BUILD AND RUN (DOSBOX)

Step 1: Open DOSBox and mount your project folder:
mount c C:\path\to\project
c:

Step 2: Assemble the source file into MARIO.COM using NASM:
nasm -f bin src\MARIO.ASM -o MARIO.COM

Step 3: Run the game:
MARIO.COM

CONTROLS AND DEBUG KEYS

Player Controls:

Left / Right Arrow: Walk left or right

Left Shift: Hold to run faster

Spacebar: Jump (tap for low jump, hold for high jump)

P: Pause or resume the game

Enter: Select menu option or restart after Game Over / Level Complete

Esc: Go back to Title screen or exit to DOS

Debug Keys (For Testing and Live Demo):

F1: Sets countdown timer to 5 seconds (to test time-out death)

F2: Sets coin counter to 99 (to test 1-UP extra life at 100 coins)

MEMORY CHOICES AND FRAME BUFFER

Single-Segment .COM Layout: The program starts at CS:0100h and keeps all code, maps, sprites, and variables inside the first 64 KB segment (CS).

Off-Screen Frame Buffer: Since a full 320x200 screen takes 64,000 bytes, it cannot fit inside CS alongside our code. We placed the off-screen frame buffer in the next 64 KB segment (CS + 1000h).

Flicker-Free Rendering: Every frame is cleared (REP STOSW) and drawn completely inside CS + 1000h first, then copied to VGA video memory (0xA000:0000) in one fast block move (REP MOVSW) once per timer tick.

Dual Map Copies: original_map (768 bytes) stores the untouched level layout, while working_map (768 bytes) stores live gameplay changes (collected coins, broken crates, empty ? blocks) and is restored via REP MOVSB on level reset.

GAME STATES

The game runs on a jump-table state machine (state_jump_table) with 8 states:

STATE_TITLE (0): Shows the title banner, character preview, and START GAME / EXIT options.

STATE_PLAYING (1): Main gameplay loop handling movement, physics, enemies, collisions, camera, and HUD.

STATE_PAUSED (2): Freezes gameplay and displays PAUSED - PRESS P TO RESUME.

STATE_DYING (3): Plays the death animation when hit at 1 HP or falling into a pit.

STATE_LIFELOST (4): Black transition screen showing WORLD 1-1 and remaining lives before restarting.

STATE_WINSEQ (5): Slides the player down the flagpole and calculates the time bonus (time_left * 50).

STATE_COMPLETE (6): Shows LEVEL COMPLETE!, time bonus, and final score.

STATE_GAMEOVER (7): Shows GAME OVER and final score when lives reach 0.

DEVIATIONS, BONUS FEATURES AND LIMITATIONS

Deviations from Manual:

Custom Theme & Artwork: Instead of standard Mario sprites, we created an original Super Bunny character (16x16 Small Bunny and 16x32 Big Bunny), Golden Carrot power-up, Spiky Hedgehogs, Armored Beetles, and an emerald-log meadow level. All core rules, physics constants, and scoring values match Section 5 of the project manual.

Bonus Features:

Dedicated 16x32 pixel-art sprite for Super Bunny instead of vertical stretching.

Enemy pit-edge detection so walking enemies turn back at ditches instead of falling in.

Sliding Beetle shells knock out other enemies in their path for +200/+500 bonus points.

Known Limitations:

Only one complete level (World 1-1, 64x12 tiles) is included.

PC speaker sound effects are not implemented.