# Day 2: Prolog (GNU Prolog)

Ah, Prolog. Prolog is probably the most unique programming language I've used, and the only purely declarative one at
that. I honestly forgot how cool it is! There's just something immensely satisfying about being able to represent all of
your logic as a giant list of rules and nothing more.

I haven't touched Prolog since my sophomore year of college some 5 years ago, so I was a more than a little rusty
headed into today's problem and needed to jog my memory just a _tiny_ bit. Fortunately, I still have all of my CS
projects archived as private GitHub repos, so I was able to skim through the Prolog ones to try to get a handle on the
syntax and a general feel for declarative programming once again.

As it happens, the problem for Day 2 turned out to be a pretty great fit for this paradigm, since it basically boils
down to a set of rules for 1) how the outcome of a rock-paper-scissors game is determined, and 2) what outcomes and
"plays" correspond to which point values. These two rulesets were the obvious starting points, with the trivial game
outcome predicates being implemented first followed by the predicates pertaining to point values for given combinations
of plays. Once all that was done, all that was needed was a recursive predicate for folding each textual line into a
point sum.

Part B was also an absolute dream to implement atop the logic I already had. The only additional code required was a set
of predicates that could tell you what move to play based on the opponent's move and what the outcome should be, which
more or less just piggy-back off the existing outcome rules - no additional logic required beyond interpreting the input
for the desired outcome. Once the move was selected, it could be passed to the exact same predicates as in Part A.

You may notice that I completely skipped over input handling. This is because this part wasn't especially interesting to
implement (read a byte, compare against \n, finalize the line and recurse if so), and also just turns out to be a pretty
big pain in a declarative PL, because that's just not something a declarative language is very good for and it's hard
to do it elegantly. This is all compounded by my general lack of knowledge of the language - the biggest snags I hit
in terms of time wasted were failing to realize that `read/2` expects the input lines to be terms (which must have a
trailing period), and not properly handling `end_of_file` and causing a mysterious stack overflow.

To my dismay, my initial answer turned out to be incorrect. I thought I might have made some grave logical misstep, but
it turns out I just misread the rules and thought the first character corresponded to _your_ move rather than your
opponent's. I then went through this same ordeal for part B, where I once again misread the rules and mixed up what
corresponded to a win versus a loss in the "strategy guide."

All-in-all, this ended up taking me somewhere between 2 and 3 hours, and probably around half of that time was spent
grappling with the input loading routine. This is definitely one of the better problems I could have chosen for the
language, and it was overall a lot of fun playing around with it again.
