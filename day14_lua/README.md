# Day 14: Lua

For all intents and purposes, Lua is a new language to me. I used it in a very limited capacity in high school to
program my TI-Nspire, and I studied the source code of
[Trouble in Terrorist Town](https://github.com/TroubleInTerroristTown/Public) while writing a
[version of the game](https://github.com/caseif/TTT) for Minecraft, but apart from this I've never written a "complex"
program in the language. This all being said, I found it shockingly easy to pick up and write in. I have some minor
gripes (namely no braces and 1-indexing), but it's plain to see why it's such a popular language choice for game
scripting.

There's nothing too special about today's solution - it just runs the sand simulation step-by-step via two nested loops.
The only real thing of note is that the min and max bounds of each axis are computed based on the input data so that the
initial grid table can be populated with "air" without having to waste time on rows and columns that will never be
touched. As it happened, having the maximum Y-value was handy for part B since in this part of the problem it
corresponded to where the "floor" was in the simulation.
