# Day 11: Java

Well, I guess it serves me right for criticizing Zig's integer overflow safeguards.

Today's problem seemed like a pretty good fit for an OO language, and I thought I'd take a break from new languages and
get back to my old stomping ground of the JVM. I'm primarily self-taught via Java and I spent 3 years doing freelance
work with it (and even longer as a hobbyist), so suffice it to say I'm pretty decent with it. Regardless, this problem
still took me a good while mainly because the solution was so involved. Overall though, I'm pretty happy with my
solution.

While I did notice pretty quickly that the numbers at play in the latter part of today's problem were getting a little
too big, it did take me an embarrassingly long time to work out the trick to keeping them manageable, and my first
attempt involved attempting to brute-force it by scattering `BigInteger`s across the code.
