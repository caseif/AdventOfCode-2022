import java.io.File
import kotlin.collections.List
import kotlin.text.Regex

val INITIAL_TIME_A = 24
val INITIAL_TIME_B = 32

data class Blueprint(
    val oreCost: Byte,
    val clayCost: Byte,
    val obsidCostOre: Byte,
    val obsidCostClay: Byte,
    val geodeCostOre: Byte,
    val geodeCostObsid: Byte
)

data class State(
    var timeRemaining: Byte,
    var ore: Byte = 0,
    var clay: Byte = 0,
    var obsidian: Byte = 0,
    var geodes: Byte = 0,
    var oreProd: Byte = 1,
    var clayProd: Byte = 0,
    var obsidianProd: Byte = 0,
    var geodeProd: Byte = 0,
)

fun parseLine(line: String): Blueprint {
    val regex = Regex("Blueprint (\\d+): Each ore robot costs (\\d+) ore\\. "
            + "Each clay robot costs (\\d+) ore\\. "
            + "Each obsidian robot costs (\\d+) ore and (\\d+) clay\\. "
            + "Each geode robot costs (\\d+) ore and (\\d+) obsidian\\.")
    val m = regex.find(line)!!
    return Blueprint(m.groups[2]!!.value.toByte(), m.groups[3]!!.value.toByte(), m.groups[4]!!.value.toByte(),
            m.groups[5]!!.value.toByte(), m.groups[6]!!.value.toByte(), m.groups[7]!!.value.toByte())
}

fun parseInput(): List<Blueprint> {
    return File("input.txt").readLines().map { parseLine(it) }
}

fun advanceState(prevState: State): State {
    var state = prevState.copy()

    state.ore = (state.ore + state.oreProd).toByte()
    state.clay = (state.clay + state.clayProd).toByte()
    state.obsidian = (state.obsidian + state.obsidianProd).toByte()
    state.geodes = (state.geodes + state.geodeProd).toByte()

    state.timeRemaining = (state.timeRemaining - 1).toByte()

    return state
}

fun findMaxGeodesForState(blueprint: Blueprint, state: State, cache: MutableMap<State, Int>): Int {
    if (state.timeRemaining.toInt() == 1) {
        val newState = advanceState(state)
        return newState.geodes.toInt()
    }

    if (cache.containsKey(state)) {
        return cache.get(state)!!
    }

    val canMakeGeodeBot = state.ore >= blueprint.geodeCostOre && state.obsidian >= blueprint.geodeCostObsid
    val canMakeObsidBot = state.ore >= blueprint.obsidCostOre && state.clay >= blueprint.obsidCostClay
    val canMakeClayBot = state.ore >= blueprint.clayCost
    val canMakeOreBot = state.ore >= blueprint.oreCost

    val maxOreCost = maxOf(blueprint.oreCost, maxOf(blueprint.clayCost, maxOf(blueprint.obsidCostOre, blueprint.geodeCostOre)))
    val maxClayCost = blueprint.obsidCostClay
    val maxObsidCost = blueprint.geodeCostObsid

    var candidates = mutableListOf<Int>()

    if (canMakeGeodeBot) {
        var newState = advanceState(state)
        newState.ore = (newState.ore - blueprint.geodeCostOre).toByte()
        newState.obsidian = (newState.obsidian - blueprint.geodeCostObsid).toByte()
        newState.geodeProd++
        val maxGeodes = findMaxGeodesForState(blueprint, newState, cache)
        candidates.add(maxGeodes)
    } else if (canMakeObsidBot) {
        var newState = advanceState(state)
        newState.ore = (newState.ore - blueprint.obsidCostOre).toByte()
        newState.clay = (newState.clay - blueprint.obsidCostClay).toByte()
        newState.obsidianProd++
        val maxGeodes = findMaxGeodesForState(blueprint, newState, cache)
        candidates.add(maxGeodes)
    } else {
        if (canMakeClayBot) {
            var newState = advanceState(state)
            newState.ore = (newState.ore - blueprint.clayCost).toByte()
            newState.clayProd++
            val maxGeodes = findMaxGeodesForState(blueprint, newState, cache)
            candidates.add(maxGeodes)
        }

        if (canMakeOreBot) {
            var newState = advanceState(state)
            newState.ore = (newState.ore - blueprint.oreCost).toByte()
            newState.oreProd++
            val maxGeodes = findMaxGeodesForState(blueprint, newState, cache)
            candidates.add(maxGeodes)
        }
    }

    if (state.ore < maxOreCost || state.clay < maxClayCost || state.obsidian < maxObsidCost) {
        // only proceed without building anything if it makes sense to keep waiting for something
        // this should hopefully prune a decent chunk of the potential paths
        var newState = advanceState(state)
        val maxGeodes = findMaxGeodesForState(blueprint, newState, cache)
        candidates.add(maxGeodes)
    }

    val res = if (candidates.size > 0) candidates.max() else 0
    cache.put(state, res)
    return res
}

fun computeMaxGeodesForBlueprint(blueprint: Blueprint, initialTime: Int): Int {
    val state = State(initialTime.toByte())

    var cache: MutableMap<State, Int> = mutableMapOf()
    return findMaxGeodesForState(blueprint, state, cache)
}

val blueprints = parseInput()

var ansA = 0

var i = 1
for (blueprint in blueprints) {
    //println("Analyzing blueprint $i")
    val geodes = computeMaxGeodesForBlueprint(blueprint, INITIAL_TIME_A)
    //println("Max geodes: $geodes")

    val quality = geodes * i

    ansA += quality

    i++
}

println("Part A: " + ansA)

var ansB = 1

i = 1
for (blueprint in blueprints) {
    //println("Analyzing blueprint $i")
    val geodes = computeMaxGeodesForBlueprint(blueprint, INITIAL_TIME_B)
    //println("Max geodes: $geodes")

    ansB *= geodes

    if (i++ == 3) {
        break;
    }
}
println("Part B: " + ansB)
