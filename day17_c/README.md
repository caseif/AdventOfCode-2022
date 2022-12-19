# Day 17: C

C seemed like a good choice for today's problem, given it's essentially a step-by-step simulation without any real bells
or whistles. I was hoping to not be thrown a curveball for part B, and while part B was really tough, the choice of
language didn't serve as any sort of constraint.

C will always be one of my favorite languages precisely _because_ it lacks bells and whistles, and by extension, there's
no funny business happening behind the scenes. C++ has some nice frills, but there's a lot of voodoo that tends to
happen behind the scenes with more sophisticated features like templates or copy/move constructors that can often
obscure the actual behavior of a program when run. On the other hand, C is really only a step or so above assembly
language. You get some basic features like loops and automatic stack management, but it really does just boil down to a
set of instructions and not much more.

Back to today's problem: for part A, I wrote a pretty straightforward algorithm for stepping through each discrete time
interval and mutating the current piece, then placing it if any of its tiles tried to intersect an occupied position or
the floor. Placed pieces are stored in a statically allocated bitfield represented as an array of unsigned chars, with
each row occupying a single row of the char array.

Part B was really challenging. With my mind fully fixated on the Tetris resemblence, my initial approach involved
checking whether a row had been completed while checking each piece, then removing that row and everything below and
shifting the whole array if so. Unfortunately, when reading part B my brain saw 10 trillion as "some big number" and I
failed to realize that this aproach had absolutely no shot at returning an answer in any reasonable timeframe.

My next approach was more on the right track. I wrote a routine which ran the simulation in chunks of _LCD_, where _LCD_
is the size of the input times the number of piece types. After each run, it would check the "surface" (i.e. the highest
occupied position in each column) and store it to an array, then check against all previously stored surfaces for
matches. This initially showed promise as I found some repeating sequences, but I had a lot of trouble making sense of
the output as there seemed to be patterns that appeared and disappeared throughout. Apparently it's been a while since
I've played Tetris, since this approach failed to account for the possibility of a piece being moved under another one
from the side, meaning that the surface wasn't actually the full picture of the current state of the play area. I'm not
sure if this was what was happening with my output in reality, but once I identified this as a potential problem I
figured there was a good chance I'd get a wrong answer anyway.

My final approach which made it into the completed program was to step through the simulation in increments of _LCD_
pieces and print out the increase in height after each step. I then pasted this into my editor and looked for recurring
patterns via `Ctrl+F`, and hardcoded the pattern interval as a magic number (348). The tricky part is that the height
of the initial chunk of pieces is unique, and the number of pieces doesn't cleanly divide into `LCD` so there are some
pieces left over that need to be simulated. I spent a couple of hours tweaking the equations which determined these
values and how they should be combined into a final answer until I eventually got it correct. It was basically just a
_ton_ of tricky-to-spot off-by-one errors.

Let's hope the next problem is a little tamer and maybe a little less OB1-prone.
