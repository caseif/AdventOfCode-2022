#!/usr/bin/env julia

const ROUNDS_A = 10

const DIR_N = 0
const DIR_S = 1
const DIR_W = 2
const DIR_E = 3

global g_positions = Array{Tuple{Int64, Int64}, 1}()

global i = 0
for line in eachline("input.txt")
    global j = 0
    for char in line
        if char == '#'
            push!(g_positions, (j, i))
        end

        global j += 1
    end

    global i += 1
end

function simulate(positions, rounds)
    local next_positions = Dict{Tuple{Int64, Int64}, Int64}()
    local poison_positions = Array{Tuple{Int64, Int64}, 1}()
    global next_dir = DIR_N

    round = 1
    while true
        for (cur_idx, pos) in enumerate(positions)
            global found_neighbor = false
            for a in -1:1
                for b in -1:1
                    if a == 0 && b == 0
                        continue
                    end

                    if (pos[1] + a, pos[2] + b) in positions
                        found_neighbor = true
                        @goto end_neighbor_loop
                    end
                end
            end
            @label end_neighbor_loop

            if !found_neighbor
                continue
            end

            for d in 0:3
                local cur_dir = (next_dir + d) % 4
                local inspect = Array{Tuple{Int64, Int64}, 1}()
                local can1 = (0, 0)
                local can2 = (0, 0)
                local can3 = (0, 0)
                if cur_dir == DIR_N
                    can1 = (pos[1], pos[2] - 1)
                    can2 = (can1[1] - 1, can1[2])
                    can3 = (can1[1] + 1, can1[2])
                elseif cur_dir == DIR_S
                    can1 = (pos[1], pos[2] + 1)
                    can2 = (can1[1] - 1, can1[2])
                    can3 = (can1[1] + 1, can1[2])
                elseif cur_dir == DIR_W
                    can1 = (pos[1] - 1, pos[2])
                    can2 = (can1[1], can1[2] - 1)
                    can3 = (can1[1], can1[2] + 1)
                elseif cur_dir == DIR_E
                    can1 = (pos[1] + 1, pos[2])
                    can2 = (can1[1], can1[2] - 1)
                    can3 = (can1[1], can1[2] + 1)
                end

                if can1 ∉ positions && can2 ∉ positions && can3 ∉ positions
                    if haskey(next_positions, can1) || can1 in poison_positions
                        delete!(next_positions, can1)
                        if can1 ∉ poison_positions
                            push!(poison_positions, can1)
                        end
                        break
                    end

                    next_positions[can1] = cur_idx

                    break
                end
            end
        end

        for (new_pos, idx) in next_positions
            positions[idx] = new_pos
        end

        if round == rounds || (rounds == nothing && length(next_positions) == 0)
            break
        end

        round += 1

        empty!(next_positions)
        empty!(poison_positions)
        global next_dir = (next_dir + 1) % 4
    end

    if rounds == nothing
        return round 
    else
        global min_x = 100000
        global min_y = 100000
        global max_x = -100000
        global max_y = -100000

        for pos in positions
            if pos[1] < min_x
                global min_x = pos[1]
            elseif pos[1] > max_x
                global max_x = pos[1]
            end

            if pos[2] < min_y
                global min_y = pos[2]
            elseif pos[2] > max_y
                global max_y = pos[2]
            end
        end

        global total_area = (max_x - min_x + 1) * (max_y - min_y + 1)
        global empty_tiles = total_area - length(positions)

        return empty_tiles
    end
end

global ansA = simulate(copy(g_positions), ROUNDS_A)
println("Part A: $ansA")
global ansB = simulate(copy(g_positions), nothing)
println("Part B: $ansB")
