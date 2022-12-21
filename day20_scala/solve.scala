import scala.collection.mutable.ListBuffer
import scala.io.Source

final val A_INDEX_1 = 1000
final val A_INDEX_2 = 2000
final val A_INDEX_3 = 3000

final val B_MULTIPLIER = 811589153

def mix(list: List[Long], iterations: Int): List[Long] = {
    val indexList = ListBuffer.range(0, list.length)

    val total = list.length

    for (t <- 0 to iterations - 1) {
        for (i <- 0 to total - 1) {
            var curIndex = indexList.indexOf(i)

            val num = list.apply(i)

            // account for wraparound so we don't need to handle it specially later
            var effNum = num
            if (effNum + curIndex < 0) {
                effNum = (effNum % (total - 1)) + total - 1
            } else if (effNum + curIndex >= total - 1) {
                effNum = effNum % (total - 1)
            }
            effNum = effNum % (total - 1)

            var newIndex = curIndex + effNum
            if (newIndex < 0) {
                newIndex = (total + newIndex - 1) % (total - 1)
            } else if (newIndex >= total - 1) {
                newIndex = (newIndex) % (total - 1)
            }

            indexList.remove(curIndex)
            indexList.insert(newIndex.toInt, i)

            if (effNum < 0) {
                curIndex = (curIndex + 1) % total
            }
        }
    }

    return indexList.map(idx => list.apply(idx)).toList
}

def computeA(list: List[Long]): Long = {
    val finalList = mix(list, 1)

    var zeroIndex = finalList.indexOf(0)
    if (zeroIndex == -1) {
        throw new Exception("Cannot find zero index")
    }

    val total = finalList.length

    val coord1 = finalList.apply((zeroIndex + A_INDEX_1) % total)
    val coord2 = finalList.apply((zeroIndex + A_INDEX_2) % total)
    val coord3 = finalList.apply((zeroIndex + A_INDEX_3) % total)
    val ans = coord1 + coord2 + coord3

    return ans
}

def computeB(list: List[Long]): Long = {
    val newList = list.map(v => v * B_MULTIPLIER).toList

    val finalList = mix(newList, 10)

    var zeroIndex = finalList.indexOf(0)
    if (zeroIndex == -1) {
        throw new Exception("Cannot find zero index")
    }

    val total = finalList.length

    val coord1 = finalList.apply((zeroIndex + A_INDEX_1) % total)
    val coord2 = finalList.apply((zeroIndex + A_INDEX_2) % total)
    val coord3 = finalList.apply((zeroIndex + A_INDEX_3) % total)
    val ans = coord1 + coord2 + coord3

    return ans
}

val list = Source.fromFile("input.txt").getLines().map(l => l.toLong).toList

val ansA = computeA(list)
println(s"Part A: $ansA")

val ansB = computeB(list)
println(s"Part B: $ansB")
