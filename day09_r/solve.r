lines <- readLines("input.txt")

compute_tail_pos_count <- function(knots) {
    knot_pos <- list()
    for (i in 1:knots) {
        knot_pos[[i]] <- c(0, 0)
    }

    visited <- list(c(0, 0))

    for (line in lines) {
        line_split <- strsplit(line, " ")[[1]]
        dir <- line_split[1]
        dist <- strtoi(line_split[2])

        for (i in 1:dist) {
            head_pos <- knot_pos[[1]]
            knot_pos[[1]] <- knot_pos[[1]] + switch(dir,
                "U" = c(0, 1),
                "D" = c(0, -1),
                "L" = c(-1, 0),
                "R" = c(1, 0))

            for (cur_knot in 2:knots) {
                cur_head_pos <- knot_pos[[cur_knot - 1]]
                cur_tail_pos <- knot_pos[[cur_knot]]

                x_diff <- cur_tail_pos[1] - cur_head_pos[1]
                y_diff <- cur_tail_pos[2] - cur_head_pos[2]

                if (abs(x_diff) < 2 && abs(y_diff) < 2) {
                    # no need to move the tail
                    next
                }

                if (x_diff == 0) {
                    # x-coordinate is the same, need to move up or down
                    if (y_diff > 0) {
                        # tail is far above head, need to move down
                        cur_tail_pos <- cur_tail_pos - c(0, 1)
                    } else {
                        # tail is far below head, need to move up
                        cur_tail_pos <- cur_tail_pos + c(0, 1)
                    }
                } else if (y_diff == 0) {
                    # y-coordinate is the same, need to move left or right
                    if (x_diff > 0) {
                        # tail is far right of head, need to move left
                        cur_tail_pos <- cur_tail_pos - c(1, 0)
                    } else {
                        # tail is far left of head, need to move right
                        cur_tail_pos <- cur_tail_pos + c(1, 0)
                    }
                } else {
                    # need to move diagonally

                    if (y_diff > 0) {
                        # tail is far above head, need to move down
                        cur_tail_pos <- cur_tail_pos - c(0, 1)
                    } else {
                        # tail is far below head, need to move up
                        cur_tail_pos <- cur_tail_pos + c(0, 1)
                    }

                    if (x_diff > 0) {
                        # tail is right of head, need to move left
                        cur_tail_pos <- cur_tail_pos - c(1, 0)
                    } else {
                        # tail is left of head, need to move right
                        cur_tail_pos <- cur_tail_pos + c(1, 0)
                    }
                }

                if (cur_knot == knots) {
                    visited <- append(visited, list(cur_tail_pos))
                }

                knot_pos[[cur_knot - 1]] = cur_head_pos
                knot_pos[[cur_knot]] = cur_tail_pos
            }
        }
    }

    visited <- unique(visited)

    return (length(unique(visited)))
}

ans_a = compute_tail_pos_count(2)
ans_b = compute_tail_pos_count(10)

print(paste("Part A:", ans_a))
print(paste("Part B:", ans_b))
