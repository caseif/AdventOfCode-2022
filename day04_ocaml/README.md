# Day 4: OCaml

This one was pretty rough. Like Prolog, I haven't touched OCaml since sophomore year of college and so I was _extremely_
rusty on how to write it idiomatically despite at this point having significantly more experience with functional
programming in general.

Today's problem boiled down to applying specific mapping operations to the list of inputs (converting a string to a
pair of integer ranges), then applying a filter operation (removing non-overlapping pairs). In something like Java, this
would be represented in a very straightforward manner:

```java
// this might not be quite syntactically correct, I don't write too much Java nowadays
var overlaps = lines.stream()
    .map(processLine)
    .filter(doPairsOverlap)
    .collect(Collectors.toList());
```

However, OCaml (being a purely functional language) effectively represents lists as single-linked structures with a head
(the first element) and a tail (all following elements as another list), and all* mapping operations are applied to lists
by first applying it to the head and then recursively calling the current function with the contents of the tail as a
parameter (a form of tail recursion). This isn't too bad conceptually, but the comparatively noisy code that results
from this pattern can be somewhat difficult to reason about if you're not adapted to seeing OCaml code regularly. Most
of the time I put towards this solution was spent fighting syntax errors.

As a footnote, I initially wanted to take today to explore Zig, but I found that today's problem was a pretty bad fit
for it overall since it involves a lot of string operations, and Zig doesn't have particularly strong concept of a
string. I thought it would be better to save it for another day and instead brush up on OCaml.

* Partway through the solution, I realized that `List.map` exists which IMO makes for a much nicer syntax, but as far
as I can tell it's ultimately just a wrapper for the standard tail recursion method.
