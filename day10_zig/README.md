# Day 10: Zig

I was really busy this past weekend and unfortunately couldn't find any bit of time to work on the AoC problems until
tonight (Monday), so I'll be attempting to do all three back-to-back.

Zig was definitely not the right choice for today. Today's problem involved some amount of integer arithmetic, and
apparently Zig makes it its mission to make such a task as difficult as possible. The idea is that integer overflow is
impossible in the language, which means that when working with multiple integers of different types, virtually every
operation between them requires explicit casting. This is a noble venture, but it's also a huge pain when you're only
working with small numbers that you don't expect to overflow nor do you really care if they technically can.

Besides integer woes, Zig also has all of the pitfalls of C with respect to string management (i.e. they practically
don't exist in concept), which is baffling to me because the first release of Zig took place almost a half-century after
the first appearance of C. At least C has the excuse of being ancient!

Another snag I hit with regard to integer operations was the requirement of using special macro-like function calls to
do operations like... integer division. Instead of `a / b`, Zig requires you to write `@divTrunc(a, b)`. I guess in
theory this gives you more control over the rounding mode, but there's no reason you can't still have a standard
operator that defaults to truncating. I think the intention may also have been to prevent incorrect programs as a result
of inadvertently using integer division instead of floating-point, but in practice I don't think this is typically a
huge issue for a seasoned programmer - in my experience you quickly learn to be extra mindful of types when doing
division, and in most cases it's fairly obvious when something goes wrong.

There are also a ton of annoying little issues I ran into, such as the language completely lacking a for-range syntax.
As a language released in the last decade, I initially expected some sort of Pythonic `for i in 0:10` syntactic sugar,
but failing that I at least expected the old C-style `for (int i = 0; i < 10; i++)` idiom. Nope! You inexplicably must
use a while-loop (which is absolutely not what a while loop is typically for in any other language that I'm familiar
with) which can accept a second expression corresponding to the third of a C-style for-loop. But if you want to actually
initialize your loop variable, you need to apparently do it on an additional line. Again, I find this inexplicable.

On the subject of loops, Zig also features the odd choice of representing foreach loops with the syntax
`for (iterator) |item| { ... }`. I'm not sure if they were trying to evoke Ruby's syntax here, but it feels completely
out of place against the rest of the language and is _so_ much less intuitive than something like
`for (item in iterator)`.

It's possible that there are idioms in the language that remedy some of the issues I ran into, but I had a hard time
finding documentation outside of the official reference and GitHub issues, and the official documentation is slightly
abstract as well as literally incomplete, with TODO comments scattered across it. In contrast, when learning D for day
7's solution, I was immediately able to find JavaDoc-style pages for every type in the standard library with a full
listing of methods and fields.

In summary, Zig kind of feels like it was made for the sake of making it. It brings very little to the table as compared
to C, and many of the additional features it _does_ offer are already present in (IMO) superior languages like D or
Rust (or frankly, even C++). It's littered with a hodgepodge of syntaxes that are questionable at best, and entirely
pointless at worst. I really, really disliked working with it and I don't think I'll be using it again.
