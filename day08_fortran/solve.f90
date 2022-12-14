program solve
    implicit none

    integer, parameter :: SIZE = 99

    integer, dimension (SIZE, SIZE) :: heights = 0
    integer, dimension (SIZE, SIZE) :: visible = 0
    integer, dimension (SIZE, SIZE) :: hori_grad = 0
    integer, dimension (SIZE, SIZE) :: vert_grad = 0
    integer, dimension (SIZE, SIZE) :: scene_scores = 1

    character(SIZE) :: line

    integer :: prev_val = 0
    integer :: running_score = 0

    integer :: x, y, x2, y2

    integer :: answer_a = 0
    integer :: answer_b = 0

    open(unit=10, file="input.txt")

    do y = 1, SIZE
        read (10, *) line
        do x = 1, SIZE
            read(line(x:x),'(I1)') heights(x, y)
        end do
    end do

    close(10)

    do y = 1, SIZE
        do x = 1, SIZE
            if (x == 1) then
                visible(x, y) = 1
                prev_val = heights(x, y)
            else
                if (heights(x, y) >= prev_val) then
                    if (heights(x, y) > prev_val) then
                        visible(x, y) = 1
                    end if
                    prev_val = heights(x, y)
                end if
            end if
        end do
    end do

    prev_val = 0

    do y = 1, SIZE
        do x = SIZE, 1, -1
            if (x == SIZE) then
                visible(x, y) = 1
                prev_val = heights(x, y)
            else
                if (heights(x, y) >= prev_val) then
                    if (heights(x, y) > prev_val) then
                        visible(x, y) = 1
                    end if
                    prev_val = heights(x, y)
                end if
            end if
        end do
    end do

    prev_val = 0

    do x = 1, SIZE
        do y = 1, SIZE
            if (y == 1) then
                visible(x, y) = 1
                prev_val = heights(x, y)
            else
                if (heights(x, y) >= prev_val) then
                    if (heights(x, y) > prev_val) then
                        visible(x, y) = 1
                    end if
                    prev_val = heights(x, y)
                end if
            end if
        end do
    end do

    prev_val = 0

    do x = 1, SIZE
        do y = SIZE, 1, -1
            if (y == SIZE) then
                visible(x, y) = 1
                prev_val = heights(x, y)
            else
                if (heights(x, y) >= prev_val) then
                    if (heights(x, y) > prev_val) then
                        visible(x, y) = 1
                    end if
                    prev_val = heights(x, y)
                end if
            end if
        end do
    end do

    answer_a = 0
    do y = 1, SIZE
        answer_a = answer_a + sum(visible(:, y))
    end do

    prev_val = 0
    do y = 1, SIZE
        do x = 1, SIZE
            if (x == 1 .or. heights(x, y) == prev_val) then
                hori_grad(x, y) = 0
            else if (heights(x, y) > prev_val) then
                hori_grad(x, y) = 1
            else
                hori_grad(x, y) = -1
            end if

            prev_val = heights(x, y)
        end do
    end do

    do y = 1, SIZE
        do x = 1, SIZE
            if (x == 1 .or. x == SIZE .or. y == 1 .or. y == SIZE) then
                scene_scores(x, y) = 0
                scene_scores(y, x) = 0
            end if

            running_score = 0
            do x2 = x - 1, 1, -1
                running_score = running_score + 1
                if (x == 1 .or. heights(x2, y) >= heights(x, y)) then
                    exit
                end if
            end do
            if (running_score > 0) then
                scene_scores(x, y) = scene_scores(x, y) * running_score
            end if

            running_score = 0
            do x2 = x + 1, SIZE, 1
                running_score = running_score + 1
                if (x == SIZE .or. heights(x2, y) >= heights(x, y)) then
                    exit
                end if
            end do
            if (running_score > 0) then
                scene_scores(x, y) = scene_scores(x, y) * running_score
            end if

            running_score = 0
            do x2 = x - 1, 1, -1
                running_score = running_score + 1
                if (x == 1 .or. heights(y, x2) >= heights(y, x)) then
                    exit
                end if
            end do
            if (running_score > 0) then
                scene_scores(y, x) = scene_scores(y, x) * running_score
            end if

            running_score = 0
            do x2 = x + 1, SIZE, 1
                running_score = running_score + 1
                if (x == SIZE .or. heights(y, x2) >= heights(y, x)) then
                    exit
                end if
            end do
            if (running_score > 0) then
                scene_scores(y, x) = scene_scores(y, x) * running_score
            end if
        end do
    end do

    answer_b = maxval(maxval(scene_scores, dim=1))

    do y = 1, SIZE
        do x = 1, SIZE
            if (scene_scores(x, y) < 100) then
                line(x:x) = CHAR(scene_scores(x, y) + 33)
            else
                line(x:x) = ' '
            end if
        end do
    end do

    write (*, *) "Part A:", answer_a
    write (*, *) "Part B:", answer_b
end