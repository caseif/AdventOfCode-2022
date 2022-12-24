# Day 22: Perl

This problem was awful. I'm generally not that great at spatial reasoning for whatever reason, and as such I had a
really difficult time debugging my code for part B. There were some mistakes scattered around initially, just dumb
oversights like not copying a value or (as always) off-by-one errors. However, even when printing out virtually every
piece of information that might be relevant, I had some serious trouble identifying which "teleports" were correct or
incorrect. By the time I hit a ten-minute cooldown on answer submissions, I ultimately ended up cheating just a tiny
bit by grabbing a script off of the AoC Reddit and modifying it to print the computed route and comparing the values to
what my program gave. It turns out I had a single case where the edge of a face was connected to the incorrect edge of
the correct face, and fixing this finally gave me the right answer. This all combined with the fact that I'm currently
visiting family for the holiday meant that I've been working on the part B solution over a span of about 48 hours.

This was my first foray into Perl, so to talk about the language a little bit: I think it's generally pretty nifty and
a lot more modern than I had expected going into it. The main thing that tripped me up were the scalar versus array
prefixes for variables. For whatever reason it wasn't immediately intuitive to me what value the prefix was actually
applicable to, leading to some confusion when accessing array elements. I'm not entirely clear on why it's necessary at
all, but I assume there's some historical reason for it.

I generally didn't feel too hindered by my lack of experience though, and I can see why it's fairly popular for
scripting. I can't really see myself using it in place of Python or Ruby, but I think it still holds its own.
