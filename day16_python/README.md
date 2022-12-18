# Day 16: Python

This was by far the hardest problem of the year so far, at least in my opinion. Graph theory isn't really my strong
suit, and I was at such a loss for ideas on how to approach this problem that I ended up cheating a bit and turning to
the AoC subreddit for ideas. I didn't actually take ideas from other code, but I did model my basic algorithm off of
ideas from Reddit comments.

Part of the reason I had so much trouble with this problem was that I was overthinking it. On its face it resembles
the traveling salesman problem, which is famously NP-complete. I figured it would be absurd for AoC to present an
NP-complete problem and thus I must be missing something, so I set to work trying to think of ways to reconceptualize
the problem into a simpler one.

The first trick is to realize that you don't need to actually care about the amount of pressure being released per
minute, because a valve releasing X pressure per minute for the following Y minutes is identical to the valve releasing
X*Y pressure instantaneously. You still need to worry about the remaining time because it factors into the
"instantaneous" release, but it makes the problem much easier to reason about.

The other trick comes down to memoization. The trick is to divide the main problem into a series of subproblems which
take the form: "If I'm at node X with Y minutes remaining and Z set of valves already opened, what's the maximum "score"
I can hope to achieve?" From this we can derive a concrete "state" for each step that we take through the puzzle and
store the answer in a dictionary. We'll ultimately end up encountering states multiple times as we go down differnt
paths, so this does actually save a good deal of time. I didn't test this for part B, but for part A proper memoization
yielded around a 50-100% speedup.

I initially hit a roadblock when implementing this algorithm as my program seemed to run and run with no end in sight. I
thought there might be an infinite loop somewhere, but first I thought I'd try implementing an optimization that I had
already had in mind. You see, the given graph can actually be converted to a complete graph with each edge representing
the distance between the two vertices (since in the original graph, it takes 1 second to traverse each "tunnel"). I
implemented this conversion as a naïve DFS for each node in the graph. This is somewhat inefficient with a complexity of
_O(n^2)_, but it doesn't actually matter because it's only done once and _n_ is pretty small. Using the new complete
graph and updating the algorithm to modify some assumptions, it was able to generate an answer for part A within a
couple of seconds. This answer was incorrect because I forgot the traversal starts at node `AA` and not index 0 of the
node list (thanks to Reddit for that insight as well).

For part B, it was pretty simple to update the existing algorithm. Instead of iterating against the list of remaining
nodes (unopened valves) for each recursion, the updated function iterates against all combinations of remaining nodes.
Additionally, two separate values for remaining time need to be tracked, and the answer for each recursion is the sum of
both paths taken, plus the answer for the subtree. The algorithm is clearly not ideal, as it takes a few minutes to
generate the answer, but what matters is that it _did_ eventually generate the correct result and it didn't take all
night.

I usually take some time in each writeup to give some insight into my thoughts on the language of the day, but I
honestly don't have too much to say about Python. I chose to burn it as an option for today because I knew the algorithm
itself was going to take me a while, and I didn't want to also be fighting with unfamiliar syntax, paradigms, or
tooling at the same time. Conversely, Python is really terrific for quickly throwing together scripts like this and if
I weren't doing the polyglot challenge I would probably end up using it for every problem.
