# GamJam
=====

A Love2D Skeleton project for the 48 Hour Game Jam

There is a sublime project which should be up to date with all the project files. 


## Install on target system
Install Love2D on the target system: http://love2d.org/

To Build from Sublime Text: 
Follow instructions here: http://love2d.org/wiki/Sublime_Text_2
You may also have some luck with ZeroBrane if you don't like ST2 


## TODO

 * Remember that you're a beautiful person and that the world is a beautiful place
 * Update batchscripts to make sure they build and clean correctly on a win system, provide mac implementations
 * Have meeting and include group snippets
 * Animation pipeline specs defined

## Script definitions (CURRENTLY BROKEN, FIX AND MOVE TO /scripts/)

### Makefile (make)
Builds the project and puts a .exe and required DLLs in root, ready to be launched. This is good to have because we don't have to worry about packaging a game last minuite.

### Clean (clean)
Cleans a build from root 

### make + clean (build)
Builds the project and compresses them to /release/, cleans root after. make + clean
