# Day 21: PHP

I should have seen this coming, but if I had known about part B ahead of time I probably would have just opted for
Mathematica.

Today was one of those problems where part A is exceptionally easy, and then part B ends up being something crazy
involved. For part A, you can get away with just recursively applying the operations of each monkey until you get a
final answer at the top level - basically Baby's First Recursive Algorithm (after the Fibonacci sequence maybe).

On the other hand, part B requires you to write a full-on algebraic expression solver. This isn't something that's
super difficult to conceptualize, but it did take a bit of effort to work out a decent way of representing the
components of the equation and a solid set of rules for simplifying each operation type (and for the non-reflective
subtraction and division operators, one for each possible arrangement).

The basic way that the part B solution operates is by recursively simplifying expressions into "atoms" of the form
`ax + b`. The simplification function first simplifies the left- and right-hand sides into atomic form, then plugs them
into operator-specific functions which in turn return an atom. Under the hood, subtraction and division operations
actually get rewritten as addition and multiplication operations before simplifying those in turn. This mostly works out
nicely, with the exception of division when the right side has a non-zero coefficient because this creates a nasty
x^(-1) term. The solution to this is to store whether the algebraic term is currently inverted in a separate flag, and
then just iron it out at the end. I don't think this actually ended up being necessary for the given input data, but I
figured I might as well.

I should also mention that this isn't a _proper_ algebraic engine in that it can only handle equations in which X
appears once. This assumption _significantly_ simplifies the reduction logic and reduces the number of cases which need
to be handled.

Some notes on PHP: It has a pretty crappy reputation historically, but modern PHP isn't all that bad. There's still some
legacy cruft and inconsistencies that might be encountered once in a while, but generally it's a good experience.
Debugging is generally pretty easy, thanks both to the reasonably informative error messages and the presence of the
`var_dump` function. Frankly, a lot more languages should have a feature like this for inspecting more complex
structures. PHP also has the somewhat unique feature of requiring all variable names to be prefixed with `$`, which has
the neat side effect of allowing keywords to be used as variables. I can literally use `if` as a variable name if I
really want to. This sounds like a minor benefit, but it made me realize how often I tend to use more verbose names than
I otherwise would just to play it safe, because sometimes while hopping around I forget what's a keyword in which
language. (I also realize that C# has a similar feature, but the prefix is optional in that case and thus rarely used,
which somehow makes it feel like a hack.)

A bit on my personal experience with the language: It was actually the first "proper" langauge I ever learned! I used it
to write a basic forum for my Minecraft server when I was 13, a good 6 months or so before I picked up Java. I also used
it to write the first version of [my blog](https://caseif.blog) (which I've since rewritten as
[Topaz](https://github.com/caseif/Topaz), because no one wants code they wrote at age 15 running in production).
