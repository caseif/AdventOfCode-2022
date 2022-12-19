# Day 18: Bash

This one kind of sucked. Part A was incredibly easy, so in my foolish naïvity I thought it might be a good day to get
Bash out of the way. All that's needed is to run through each lava voxel and check each adjacent voxel, incrementing a
sum variable if it doesn't contain another lava voxel. Not the most efficient algorithm, but it gets the job done.

But then we get to part B, and we need to somehow omit surfaces which face an internal air pocket which isn't exposed to
the external air. My first thought was to just make the assumption that the droplet was roughly a sphere without any
weird concave structures. This would allow one to search to the bounds of the area in each directions, and if a ray
in a given direction doesn't encounter any lava we can be sure it's an external pocket, and if not we can assume that
it's internal. This gets us somewhat close to the answer, but for whatever reason it fails to count a few hundred
surfaces and thus it doesn't suffice.

I fiddled around some more with various brute force methods because I really, really didn't want to try to implement
a flood-fill algorithm in Bash. This worry turned out to be completely founded, as a quickly hit a segfault due to
excessive recursion while doing so. The solution to this was to divide the area into octants and flood-fill each one
separately. Once the list of all external air voxels is constructed, it's just a matter of modifying the check for each
face of lava voxels to match against the air voxel array (instead of the lava voxel one).

I really tend to dislike shell scripting a good deal. Its syntax is clunky and annoying to write and things get kind of
weird when you start to use fancier features like arrays. I almost always turn to Python instead when I need a script
that does anything more complex than literally running a series of commands because (IMO) it's superior in basically
every way.
