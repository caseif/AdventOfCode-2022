# Day 23: Julia

Today's wasn't too bad. There was the usual battery of stupid typos and errors to deal with but overall I was able to
do it in around an hour and a half, which was a nice change of pace. Julia is another language I haven't used before,
and overall I think it's pretty neat. It seems to take some hints from Ruby, especially with respect to the notation for
void-returning functions (the `!` suffix). The main thing that seems to set it apart from Ruby or Python is its ability
to compile to native code, which is kind of cool for a dynamically-typed language. It's certainly not something you see
every day.

I do have some qualms about the `local` and `global` keywords. While I was able to fumble my way around most of the
language with relative ease, I couldn't seem to get the hang of how these are supposed to work. The obvious answer would
be that they control the scope of the variable declaration they're attached to, but this doesn't appear to be the full
picture. Apparently the `global` specifier is required when modifying global variables, even ones which have already
been declared, and it's necessary to make variables which will be used in a loop global because... reasons. There could
be a really good reason for all of this, but it just doesn't make sense to me at least off the bat.

Overall, while I once again can't really see myself moving away from Python and Ruby, I definitely feel that I like
Julia and I wouldn't mind using it again at some point.
