# Day 5: C++

Little late on this one, busy busy day today. To save some time I decided to write the solution for today's problem in
a language I'm a little more familiar with, as well as one that makes input parsing and regex a breeze.

Regex was especially useful for today's puzzle as a simple method for sifting out the "garbage" from the input file (the
extraneous verbs and prepositions in each line) and extracting only the relevant numbers. The STL also makes part A
quite simple with `std::reverse`, which is capable of simply reversing an arbitrary iterator (in this case a string
representing the crates being moved).

I actually got kind of lucky and solved the answer to part B first because I once again skimmed the problem in my haste
to get cracking on a solution. This made re-adapting the part A code to part B a lot easier because all that was needed
was to remove the `std::reverse` call. I think in my mind, a problem in which crates must all be moved at once was more
interesting than the actual part A spec (which is basically just a series of FIFO stacks) and so I assumed that was what
I was meant to work out. Turns out, I was right - it _is_ more interesting! (at least according to the folks at AoC)

Going forward I'll try to be a little more careful reading prompts. It hasn't cost me too much effort so far, but I
think that's mostly down to luck - it probably won't be long before I'm having to completely re-engineer a solution if
I keep it up.
