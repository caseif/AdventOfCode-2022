# Day 19: Kotlin

Kotlin, much like Go, seems to fill an odd niche in my mind. It bills itself (among other things) as a less-verbose
alternative to Java while still retaining interoperability with JVM languages. While it does have some compelling
offerings such as built-in syntax for nullable types (alongside compile-time enforcement of null-correctness), it also
seems to heavily focus on "modern" syntactic features often seen in scripting languages. This makes perfect sense, since
Kotlin also bills itself as a scripting language! However, it seems to make for a pretty poor one at that. It doesn't
bring anything to the table that languages like Python or Ruby don't as well, and as far as I can tell there's no
obvious way to run it via an interpreter - it needs to be compiled to bytecode and run in a JVM, which takes several
seconds on my laptop every time the script is run. The only use case I can picture where it would make sense to choose
Kotlin over a more established scripting langauge would be if you need your script to hook a Java library, although I
would think this would be a rare enough occasion that I wouldn't mind just writing a full-fledged Java or Kotlin class
instead.

With that all being said, I don't actually dislike Kotlin. I think it's generally pleasant to write, and while the more
novel aspects of the syntax can be slightly annoying (it's almost Rust-like, but it's just different enough to trip me
up repeatedly), it's mostly just a syntactically improved version of Java with a slightly more ergonomic standard
library. I mostly question the utility of the scripting funcitonality it provides. It just really doesn't seem all that
useful for such a use case compared to the alternatives that exist.

On to today's problem. This was fairly similar to day 16's valve problem, where the task is to find the maximum "score"
that can be obtained by manipulating a state machine in discrete time steps. This class of problem necessitates a search
algorithm of some kind that can traverse the tree of potential states and identify which path to t=0 will ultimately
yield the highest score.

However, this problem is also quite distinct from day 16 in that the state machine is significantly more complex.
Whereas the previous state machine consisted of the current time and position, this one consists of the current time,
the amount of stored resources, and the amount of resources produced each second at that time. Whereas the previous
state mutations could be reframed as an instantaneous score increase, in this problem we can't really take that approach
with resources since they can be consumed in a later time step, which is an operation contingent on the amount of
resources available at that specific time step rather than the amount of resources that will have been generated in
total by the end of the simulation. I'm sure that there's some insight here that I haven't worked out that would still
allow some sort of reframing into a simpler problem, but I'm trying to get to bed at a semi-reasonable time tonight so
I'll have to look more into it tomorrow.

Taking lessons from day 16, I implemented some basic memoization code before attempting to run the script for the first
time. This turned out to be a good move, as removing it slows the program down by several times. Unfortunately, the
problem space is so large that the size of the cache in memory becomes a concern. I addressed this first by making the
fields of the `State` class bytes (since the values likely won't exceed a fraction of `INT8_MAX`), and second just by
increasing the heap size to 24 gigs. I've got 'em, so may as well use 'em. When all was said and done, part A peaked at
around 4-5 gigs of usage and part B reached around 20 before completing.

Another serious optimization I made was to only branch without building a new robot if it was possible to build a robot
robot in a future step that can't be built now - in other words, figure out the max amount of each resource required for
any robot, then compare all resources against these maximums and branch if any are less. This prunes a substantial
number of deep subtrees and allows part A to complete within a minute.

Part B was still taking at least several minutes to run at this point, so I implemented another optimization wherein
geode robots are always selected for building if they can be afforded (in addition to the aforementioned wait branch),
and if not, obsidian bots are preferred. Only if neither a geode nor an obsidian bot can be built does the simulation
consider branches in which an ore or clay robot is built instead. This finally allowed part B to run to completion
within a minute or two.
