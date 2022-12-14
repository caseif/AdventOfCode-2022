local file = io.open("input.txt")
local lines = file:lines()

local minX = 10000
local minY = 10000
local maxX = 0
local maxY = 0

local structures = {}

local grid = {}

local i = 1
for line in lines do
    local coords = {}
    local j = 1
    for x, y in string.gmatch(line, "(%d+),(%d+)") do
        coords[j] = { tonumber(x), tonumber(y) }
        j = j + 1
    end

    for _, coord in ipairs(coords) do
        if coord[1] < minX then
            minX = coord[1]
        end
        if coord[1] > maxX then
            maxX = coord[1]
        end
        if coord[2] < minY then
            minY = coord[2]
        end
        if coord[2] > maxY then
            maxY = coord[2]
        end
    end

    structures[i] = coords

    i = i + 1
end

for i = minX - 1, maxX + 1, 1 do
    grid[i] = {}
    for j = minY - 1, maxY + 1, 1 do
        grid[i][j] = 0
    end
end

for _, structure in ipairs(structures) do
    local lastPoint = nil
    for _, point in ipairs(structure) do
        if lastPoint ~= nil then
            if lastPoint[1] ~= point[1] then
                -- horizontal line, y stays constant
                for i = math.min(lastPoint[1], point[1]), math.max(lastPoint[1], point[1]), 1 do
                    grid[i][point[2]] = 1
                end
            else
                -- vertical line, x stays constant
                for i = math.min(lastPoint[2], point[2]), math.max(lastPoint[2], point[2]), 1 do
                    grid[point[1]][i] = 1
                end
            end
        end

        lastPoint = point
    end
end

local totalSand = 0

while true do
    ::outer::

    local sandX = 500
    local sandY = 0

    while true do
        sandY = sandY
        if grid[sandX][sandY + 1] == nil or grid[sandX][sandY + 1] == 0 then
            sandY = sandY + 1
        elseif grid[sandX - 1][sandY + 1] == nil or grid[sandX - 1][sandY + 1] == 0 then
            sandY = sandY + 1
            sandX = sandX - 1
        elseif grid[sandX + 1][sandY + 1] == nil or grid[sandX + 1][sandY + 1] == 0 then
            sandY = sandY + 1
            sandX = sandX + 1
        else
            grid[sandX][sandY] = 2
            totalSand = totalSand + 1
            goto outer
        end

        if sandY > maxY then
            goto done
        end
    end
end

::done::

--[[for i = minY, maxY, 1 do
    for j = minX, maxX, 1 do
        if grid[j][i] == 1 then
            io.write("#")
        elseif grid[j][i] == 2 then
            io.write("O")
        else
            io.write(".")
        end
    end
    io.write("\n")
end--]]

print("Part A: "..totalSand)
