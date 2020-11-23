# excitation_automaton

A discrete automaton inspired by <a href="https://royalsocietypublishing.org/doi/10.1098/rsfs.2018.0029">this article</a> about signal propagation in fungi(!). The researchers modeled the behavior as a network of locally-connected nodes which become active above a certain threshold of active neighbors and then enter a cooldown phase:

<img src="https://royalsocietypublishing.org/cms/asset/2bc5e560-e96e-4b5f-99d5-ce2d33a7cbd1/rsfs20180029ueq1.gif">

This model allows the propagation of easily-recognizable "waves" of excitation:

<img width=500px src="https://github.com/nlc/excitation_automaton/blob/master/full_360.gif?raw=true">

Modeled in Ruby, visualized using R.

### Future considerations:
* The graph generation process is implemented *very* naively and takes a long time to complete.
  * Could use some kind of space-hashing algo to speed up the process.
* Image generation directly from Ruby would be convenient.
  * Especially helpful would be the ability to see non-active nodes.
* Currently almost all of the attention has been directed towards the "annulus" graph configuration; looking at other shapes/topologies could be instructive.
