# Day 12: Go

I haven't used Go in a few years, but I was able to pick the basics back up again fairly easily in part thanks to its
reasonably intuitive syntax. Obviously this program isn't using anything fancy like Goroutines, but I do recall even
more sophisticated programs being pretty pleasant to write back when I was using it in a full-fledged project.

In my experience, Go seems to fill a really odd middle ground between low-level languages like C and managed languages
like Java. You get access to low-level concepts like pointers and a scaled-back standard library, while also getting
(runtime) memory safety alongside garbage collection. That being said, it does feel like in a post-Rust world there's
not a whole lot of reasons to be using Go instead of Rust for new projects. Rust offers additional features like proper
generics while also providing much stronger guarantees regarding memory safety. I really don't _dislike_ Go, but I also
can't really see myself justifying it for a project in the future.

In any event, this solution uses a basic implementation of the A* algorithm for both parts. The heuristic for part A is
the Manhattan distance from the current cell to the target cell, and for part B it's just the elevation of the current
cell. For both parts, each step has equal cost. I haven't used the algorithm in quite some time so I needed to look it
up again, and admittedly I basically just copied the pseudocode from Wikipedia for my implementation in the interest of
time.
