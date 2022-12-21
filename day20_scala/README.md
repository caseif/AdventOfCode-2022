# Day 20: Scala

Scala probably wasn't a great choice for today. The problem is centered around lists which in theory should jive pretty
well with a more functional approach, but in reality the system described by the problem behaves chaotically and thus
effectively random access into the list is required as the next index to be processed shifts around with each turn.

My initial solution involved making a copy of the number list as a list of tuples, with the second tuple parameter being
a simple flag for whether the number had been visited yet or not. Going through the list in order, the next non-visited
item going forward from the current offset is guaranteed to be next in the original sequence. In other words, the order
order of non-visited items is always preserved (until they're ultimately visited).

Part B forced a rewrite of this logic, as it became a requirement to be able to track the original order of nodes
_after_ they had all been shuffled around. The obvious way to do this is to shuffle the list indirectly, replacing it
with a simple range of numbers from 0 to n representing indices into the original list and then restoring the original
numbers once a final shuffle is reached.

This was pretty simple in concept but took me a good while to complete due to just an absolutely obscene number of
off-by-one errors. The trickiest part of this problem is the fact that to place a number at the head or tail of the list
is to place it in between the same numbers, making these two ends effectively the same index. This throws off
assumptions regarding modulo math as well as wraparound logic that are intuitive, but technically wrong because of this
caveat.

As for Scala, this was my first time using it. I'm not especially impressed, as the subset of the standard library I
used for this problem seems a little obtuse. It also has a weird syntax for nullary method calls that allows the
parentheses to be omitted, which I don't like because it's totally unnecessary and creates ambiguity that doesn't need
to exist. This all being said, my understanding is that it's somewhat beloved as a language and I'm certain that my
opinion on it would soften a good deal if I were to use and practice with it more. However, Kotlin (the _other_ Java
alternative) still edges it out in my mind so I don't think I would be too inclined to consider using it in a project
myself.

I also want to point out that I didn't really take advantage of Scala's most prominent feature, which is the notion of
everything being an expression rather than a statement. If I spent more time getting the hang of this time and writing
more idiomatic Scala I would think my opinion would probably soften even more. As it stands, this solution code is
_certainly_ not idiomatic and honestly not all that different from how it would be written in Java.
