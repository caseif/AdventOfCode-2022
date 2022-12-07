# Day 6: x86_64 Assembly Language

The answers to today's problems were _extremely_ hard-earned. This ended up taking me in the neighborhood of 5 or 6
hours, much longer than I had initially hoped for. It's 1:30 in the morning as I write this and I have work tomorrow, so
while I'd like to go into a ton of detail about the program and the iterations I went through, I'm going to try to keep
it brief so I can sleep.

This was far from my first foray into assembly language (I even
[wrote a basic assembler](https://github.com/caseif/Mossy) for the version of the 6502 found in the NES console), but I
almost never have cause to write it so I don't have too much practice under my belt. Apart from my experience developing
the aforementioned assembler and an accompanying emulator, my only real experience comes from my time in university. I
had to brush up on even some more basic concepts like stack frame management.

I found part B to be quite mean today. I figured for part A that I could get away with explicitly writing each
comparison thus avoiding needing to write fancy loops, but that wasn't feasible for 13! combinations. Thus, today is the
first day where I have part B's solver completely separated from part A's.

As a final note, I decided to write the solution in x86_64 assembly instead of x86 because I actually didn't have any
prior experience with x86_64 (compared to at least a little bit for x86) and it seemed like a good opportunity to gain
some familiarity with the "dialect."
