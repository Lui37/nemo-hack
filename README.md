# nemo-hack
Pajama Hero: Nemo romhack for speedrun practice

To be assembled using [Futaba](https://spannerisms.github.io/Futaba/), see the Makefile.

**Features**
- Press `A` repeatedly on the title screen to select which level ("DREAM") to start playing from. Note that Nightmare Land sections 2 and 3 are also selectable, unlike the original "DREAM SELECT" code

- Overall level time is shown on the HUD whenever any of these conditions happen:
	- An item, such as keys, HP refills or 1UPs, is collected
	- Nemo transforms into/from an animal
	- A screen transition begins
	- An area is loaded
	- The game is paused
	- A level-end door is touched
	- A boss is defeated

- When facing a boss, its current HP is shown on the HUD

- NPC dialogs and all cutscenes between levels are all skipped


**Known bugs**
- Watching the demo before starting DREAM 1 makes Flip disappear
