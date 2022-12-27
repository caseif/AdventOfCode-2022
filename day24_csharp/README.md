# Day 24: C#

I went about this all wrong initially. We were busy the last few days traveling to see family so I didn't have any time
to work on a solution, but I did peek at the prompt on Christmas Eve and mistakenly thought it would make sense to use
memoization a la day 16 to find a solution. Unfortunately, the problem space is absolutely massive (there are over 2
million distinct possible states), so all this got me was a stack overflow exception.

I ended up first converting the recursive DFS solver to an iterative priority-queue based solver which actually did
yield an answer (which was wrong due to me mixing up the flags I was using to indicate which direction each blizzard was
moving), but it took quite a while to halt (I didn't actually run it to completion) and I suspected it might be landing
on the wrong answer. At this point I was already using a priority queue, so I went the extra step and just converted it
to an A* solver instead. I'm not sure why this didn't occur to me sooner since I _did_ make the connection that the
time step can be treated as a sort of third axis in the problem space, but once this was implemented it spat out a
solution and halted within a couple of seconds.

Part B was nice for this problem. It basically just amounted to making the goal coordinate a parameter to the solver
function instead of hardcoding it and sprinkling a couple of `Math.Abs` calls into the existing code. Then, it's
essentially just pathfinding back to the start with the part A answer being part of the new "initial" state and doing
the same to get back to the end.

I currently spend most of time at work writing and debugging C#, so using it for today's problem was both really nice
and slightly stressful. Being very familiar with the language was great as always and made writing the solution much
less effortful, but I've also now spent my last day of holiday leave writing the same language I do at work and it
almost feels like I cut my own break short.
