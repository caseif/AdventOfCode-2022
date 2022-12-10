# Day 9: R

Like the last couple of languages, R is also brand new to me. From my use of it in this problem, I can certainly tell
that it's designed with non-programmers in mind - it's free of idiosyncracies like terminating semicolons that might be
confusing to someone who isn't necessarily a computer scientist. It's also full of helpful utility functions that are
simple to call and provide a huge area of boilerplate to make it easy to just focus on the business logic of the script.

The syntax is also a lot more ergonomic (IMHO) than with MATLAB. Whereas in MATLAB you have to deal with comparatively
clunky Fortran-like syntax for blocks, R offers simple C-style braces which makes a _world_ of difference (at least to
me) in ease of writing.

I chose R for today's problem because I figured it would be best to use a language that could easily represent and
operate on pairs of numbers. R has a vector type which can contain an arbitrary number of elements of a single type, and
you can use standard arithmetic operators to perform elementwise computations with them. This feature definitely helped
to keep my solution code quite tidy. Overall, I'm really impressed with the language.
