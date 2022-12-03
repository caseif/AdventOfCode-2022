# Day 3: MATLAB (GNU Octave)

This one was pretty easy. I chose MATLAB for this day's puzzle because set operations can be a bit of a pain in some
languages, but with MATLAB being heavily geared towards mathematics applications these sorts of things are trivial. In
the context of this particular problem, the built-in `intersect` function is invaluable. The ease with which one can
slurp an entire file and split it into lines is also a nice plus, especially coming off Day 2's solution written in
Prolog.

I haven't used MATLAB since my first semester at college around 6 years ago. I remember having a somewhat love-hate
relationship with it, but to be completely honest I found it quite easy to use this time around (at least for this very
simple application). And unlike with Prolog, the syntax came back to me almost immediately even after so many years away
from it. I think this is probably down to the overall simplicity of it (the syntax) along with the fact that in most
cases it's used as a purely imperative language - no tricky lambda syntax in sight!

As a note, the official MATLAB documentation directs one to use 0-indexing for the `substr` function, while Octave seems
to use 1-indexing. As such, I have absolutely no idea if this will run and produce correct results on MATLAB itself.

While working on this problem I found myself reminiscing over a MATLAB class I took in my senior year of high school.
It was my first class of the day and the teacher of the class was a hobbyist beekeeper, and some days he would get
distracted off and spend the entire remainder class period telling us about his bees and about beekeeping in general. He
was a super friendly guy, and to be completely honest it was some really interesting stuff. Good times indeed.
