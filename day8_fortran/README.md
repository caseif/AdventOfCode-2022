# Day 8: Fortran (Fortran 90)

I don't like Fortran. It's not the _worst_ per se, but even in its relatively modern carnation of FORTRAN 90, the syntax
clearly shows its age. I found it extremely unergonomic to work in, although that may be down to my brain insisting on
pretending it was a flavor of C so it's quite likely that my program isn't even close to idiomatic Fortran.

I found the most frustrating part of solving today's puzzle to be the inflexibility of the `write` call - I was
desprately wanting a `printf` to call the entire time. Also annoying is the C90-esque requirement of separating
declarations from the rest of the code - this isn't a _huge_ deal on its own, but it's kind of a death by a thousand
cuts type of deal that I was feeling.

I ended up using multiple attempts for each part due to a huge number of off-by-one errors that just seemed to keep
cropping up all over the place. Combined with the lack of proper debugging facilities (that were easily accessible to a
novice, at least), this problem ended up taking me somewhere between 2 and 3 hours in total.

As far as the actual implementation, I ended up more or less using brute force for both parts. For part A, the program
just goes along each edge and checks how far the sightline penetrates into the block and flags the elements accordingly.
For part B, it iterates through every element and then iteratively checks the sightline for each direction. I think the
worst case for part B might actually work out to cubic time, but it doesn't matter too much for this application.

I don't intend to ever touch Fortran again to be completely honest. It's neat to get some surface-level hands-on
experience with it given its historical significance and relative obscurity in the modern day, but at the end of the day
it really is just an absolute pain.
