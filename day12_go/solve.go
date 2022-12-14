package main

import (
    "bufio"
    "fmt"
    "math"
    "os"
)

const (
    kDirUp = iota
    kDirDown = iota
    kDirLeft = iota
    kDirRight = iota
)

const kMaskUp = 1
const kMaskDown = 2
const kMaskLeft = 4
const kMaskRight = 8

const kBaseElev = 0
const kSummitElev = 26

var heightMap [41][113]byte

func main() {
    readFile, err := os.Open("input.txt")

    if err != nil {
        fmt.Println(err)
    }
    fileScanner := bufio.NewScanner(readFile)

    fileScanner.Split(bufio.ScanLines)

    var startX uint32
    var startY uint32
    var targetX uint32
    var targetY uint32

    var y uint32 = 0
    for fileScanner.Scan() {
        var x uint32 = 0
        for _, b := range fileScanner.Text() {
            if b == 'S' {
                heightMap[y][x] = kBaseElev
                startX = x
                startY = y
            } else if b == 'E' {
                heightMap[y][x] = kSummitElev
                targetX = x
                targetY = y
            } else {
                heightMap[y][x] = byte(b) - 97
            }

            x += 1
        }

        y += 1
    }

    readFile.Close()

    pathA, ok := doAstar(ordinal(startX, startY), kSummitElev, false)
    if !ok {
        fmt.Println("No path found")
        return
    }

    pathB, ok := doAstar(ordinal(targetX, targetY), kBaseElev, true)
    if !ok {
        fmt.Println("No path found")
        return
    }

    // number of steps = one less than number of nodes in path
    fmt.Printf("Part A: %d\n", len(pathA) - 1)
    fmt.Printf("Part B: %d\n", len(pathB) - 1)
}

func doAstar(startNode uint32, targetElev uint32, reverse bool) ([]uint32, bool) {
    startX, startY := xy(startNode)

    openSet := map[uint32]bool { startNode: true }
    cameFrom := map[uint32]uint32 {}
    gScore := map[uint32]uint32 { startNode: 0 }
    fScore := map[uint32]uint32 { startNode: h(startX, startY) }

    for len(openSet) > 0 {
        var curNode uint32
        var lowestScore uint32 = math.MaxUint32
        for node := range openSet {
            curScore, ok := fScore[node]
            if ok && curScore < lowestScore {
                lowestScore = fScore[node]
                curNode = node
            }
        }

        curX, curY := xy(curNode)

        if uint32(heightMap[curY][curX]) == targetElev {
            return reconstructPath(cameFrom, curNode), true
        }

        delete(openSet, curNode)

        var curHeight = heightMap[curY][curX]

        dirs := []uint {}
        if curX > 0 && canStep(heightMap[curY][curX - 1], curHeight, reverse) {
            dirs = append(dirs, kDirLeft)
        }
        if curX < uint32(len(heightMap[curY])) - 1 && canStep(heightMap[curY][curX + 1], curHeight, reverse) {
            dirs = append(dirs, kDirRight)
        }
        if curY > 0 && canStep(heightMap[curY - 1][curX], curHeight, reverse) {
            dirs = append(dirs, kDirUp)
        }
        if curY < uint32(len(heightMap)) - 1 && canStep(heightMap[curY + 1][curX], curHeight, reverse) {
            dirs = append(dirs, kDirDown)
        }

        for _, dir := range dirs {
            var neighbor uint32
            switch (dir) {
            case kDirUp:
                neighbor = ordinal(curX, curY - 1)
            case kDirDown:
                neighbor = ordinal(curX, curY + 1)
            case kDirLeft:
                neighbor = ordinal(curX - 1, curY)
            case kDirRight:
                neighbor = ordinal(curX + 1, curY)
            default:
                continue
            }

            tentGScore := gScore[curNode] + 1
            curGScore, hasGScore := gScore[neighbor]
            if !hasGScore || tentGScore < curGScore {
                cameFrom[neighbor] = curNode
                gScore[neighbor] = tentGScore
                if reverse {
                    fScore[neighbor] = curHeight
                } else {
                    fScore[neighbor] = tentGScore + manhattanDist(xy(neighbor))
                }
                if _, ok := openSet[neighbor]; !ok {
                    openSet[neighbor] = true
                }
            }
        }
    }

    return nil, false
}

func canStep(fromElev byte, toElev byte, reverse bool) bool {
    diff := int32(fromElev) - int32(toElev)
    if reverse {
        return diff >= -1
        } else {
        return diff <= 1
    }
}

func reconstructPath(cameFrom map[uint32]uint32, curNode uint32) []uint32 {
    totalPath := []uint32 { curNode }
    for {
        prev, ok := cameFrom[curNode]
        if !ok {
            break
        }
        curNode = prev
        totalPath = append([]uint32{prev}, totalPath...)
    }

    return totalPath
}

func ordinal(x uint32, y uint32) uint32 {
    return y * uint32(len(heightMap[0])) + x
}

func xy(ordinal uint32) (uint32, uint32) {
    cols := uint32(len(heightMap[0]))
    return ordinal % cols, ordinal / cols
}

func getMask(dir int) byte {
    switch dir {
    case kDirUp:
        return kMaskUp
    case kDirDown:
        return kMaskDown
    case kDirLeft:
        return kMaskLeft
    case kDirRight:
        return kMaskRight
    }
    panic("Unknown direction")
}

func manhattanDist(x uint32, y uint32, targetX uint32, targetY uint32) uint32 {
    return uint32(math.Abs(float64(int32(x) - int32(targetX))) + math.Abs(float64(int32(y) - int32(targetY))))
}
