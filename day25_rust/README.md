# Day 25: Rust

This problem was a lot of fun. It's not super complicated to solve; it mainly just requires a basic understanding of
base swaps. Decoding the SNAFU numbers was a breeze - just go through the chars in reverse and multiply them by the
"place", incrementing the exponent with each iteration. _Encoding_ on the other hand required a little thought. The
solution wasn't immediately obvious to me given the presence of negative digits, but I mulled on it for a little bit
while I took our dog for a walk and figured out that you can pretty much just use a variation of the standard base
change algorithm, with the only tweak being that 3 becomes -2 and 4 becomes -1 (and correspondingly, the remaining value
_increases_ in these cases).

Rust is a _really_ cool language. First, everything is immutable by default. If you want to modify a variable you need
to explicitly mark it with a `mut` qualifier, which forces you to put some thought into what values need to change as
you move through a function and thus can give you deeper insight into the state of the program as it runs.

Second, the syntax is just absolutely delightful. No mandatory parentheses around control statements, variable types
are specified as annotations rather than as a core part of the declaration, and functions get an `fn` prefix which makes
it immediately obvious that they're such. Integers have optional suffixes to denote their width and signedness, and
match expressions are just lovely. It's clear that it's a modern language built upon decades of collective experience as
to what makes a language concise and ergonomic.

Cargo is also a really great build tool for the most part, although I've certainly fought with it at times. But even
more important is that it's _the_ standard way to build Rust, which automatically gives it a leg up on its counterparts
in C/C++-land. The learning curve of it is part of learning the language as a whole, and when building other projects
you simply don't need to worry about whether it's using autotools, Makefiles, CMake, or whatever else. It's all just
Cargo.

Finally, of course, the borrow checker. The memory safety imparted by it is just completely unparalleled in a
non-managed language. Granted, there's no such thing as a free lunch - it can take a lot longer to write a program in
Rust than in C because you need to really put some thought into the architecture and design your program in a way that
plays nice with the BC, both on the scale of the entire program and of individual functions. But generally, writing code
will be a much more efficient process than debugging code, so it tends to be a worthwhile tradeoff (even though the BC
has definitely made me want to pull my hair out at times).

There are some drawbacks as well. Rewriting a program in Rust can be tempting, but it can literally require a complete
redesign of certain systems in some cases. I work on a small (and very WIP) game engine in my spare time, and at one
point I tried to go down the RIIR route only to bail on it a couple weeks later because I would have had to completely
rewrite the way that the different components of it interacted with each other. I may still try to pursue it again (and
I've already written some tooling to at least allow me to write _parts_ of it in Rust), but there's a point where it
becomes a bit demoralizing.

All that aside, I really do adore Rust (if my gushing hasn't made it obvious) and I'd really like to find some excuses
to work with it more in the future.

---

## Final Reflections on AoC 2022

I certainly learned a lot through this challenge. It afforded me the opportunity to gain a bit of experience with
langauges I either hadn't touched in a long time or had never written at all, and it also involved a _lot_ of critical
thinking and algorithm design that I don't really encounter in my day-to-day life. Most of the work I do currently isn't
terribly heavy on the theory side of things, so it was a lot of fun to dive deep into things like pathfinding or
designing step-by-step simulations or whatnot.

On the other hand, it really was a _lot_. It ended up eating most of the personal time through the month, which was
exacerbated by the proximity to the holidays. Several days' challenges kept me up to the wee hours of the morning, and
more than once (I think) I built up a backlog of 3 days' worth of puzzles that I just couldn't find the time for but
nonetheless caused me some dread at the thought of all the work I was going to need to do to catch up.

Overall, I'm really glad I did this. I definitely feel a sense of accomplishment having completed everything
successfully, but I don't think I'll be doing it again just on account of the workload involved. Maybe for 2023 I'll
just stick to Python or Rust.
