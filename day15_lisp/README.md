# Day 15: Lisp

This was another really hard one to get the hang of. Lisp, like Prolog, is one of those languages that really forces you
to completely change the way you reason about problems. That, coupled with its entirely unique syntax, resulted in this
one taking several hours to get through.

I do actually have some previous experience with Lisp through an AI class I took in university, but unfortunately that
was years ago and I don't seem to have kept any of the coursework, so I ended up mostly learning from scratch. I only
really remembered the basic syntax of `(function param1 param2)` and basic operators like `car` and `cons`, so I was
doing an awful lot of Googling through the entirety of the process.

Part B's solution is pretty lackluster. I ended up just brute-forcing it so that I could reuse my per-row algorithm, but
it ended up taking a solid minute or two for my laptop to chug all the way through to row 2.9 million something and find
the answer. If I really wanted to be clever it probably would have been best to examine the edge of every sensor's
radius, but that would have meant basically doing part B from scratch which I really, really didn't want to do with it
being past 2 AM and all.

Finally, my overall takeaways from revisiting Lisp: it's a really neat language, but it's definitely not equally suited
for every problem. This is probably one of the use cases where an imerative language makes a little more sense, but
nonetheless it's still a lot of fun to write once you have a handle on just what the hell you're doing.
