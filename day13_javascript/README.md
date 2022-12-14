# Day 13: JavaScript

I was saving JS for a rainy (busy) day, but I saw the problem for day 13 and absolutely _had_ to use it. I mean, the
input lines are JSON-encoded for crying out loud!

Joking aside, today's (well, yesterday's since I'm still playing catch-up) problem was pretty straightforward. My
implementation provides a recursive solve function which applies distinct rules for each combination of input types and
provides a result in [-1, 1]. The only real challenge I ran into here (apart from off-by-one errors like usual because
of 0- versus 1-indexing) was figuring out how to ingest the input. Requests to `file://` URIs are always treated as CORS
requests by modern browsers, which seriously limits the possibilities for retriving `input.txt` from the "remote." I
actually got as far as installing `apache` on my laptop to just run the solution on a local server before I realized I
could just shove it in an additional JS file as a string constant and call it a day.

The choice of JS as the language for today's program definitely sped things along a good bit even considering the
relative simplicity of the problem. I spend something like a quarter of my work day writing and debugging JS, so suffice
it to say I've gotten pretty efficient at it. The standard library in modern versions of the language is also quite
nice, which helps too. Finally, the fact that I could just run every input line through `JSON.parse` meant I got to
basically completely skip writing the input parser, which usually takes up a good chunk of time for these problems.

All-in-all, I really don't mind JS too much despite the amount of hate it tends to get from developers. Yes, pre-ES6
kind of sucks, and I _really_ wish it had native type annotations (TypeScript is a solution here, but adds an additional
step to the development workflow), but it's definitely not the worst thing we could have been stuck with as web devs.
