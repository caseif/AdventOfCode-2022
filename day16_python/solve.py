#!/usr/bin/env python3

import bisect
import re

INITIAL_TIME_A = 30
INITIAL_TIME_B = 26

START_NODE = "AA"

class Node:
    def __init__(self, valve, rate, tunnels):
        self.valve = valve
        self.rate = rate
        self.tunnel_ids = tunnels

class FCNode:
    def __init__(self, valve, rate, distances):
        self.valve = valve
        self.rate = rate
        self.distances = distances

class StateA:
    def __init__(self, cur_valve, rem_time, opened_valves):
        self.valve = cur_valve
        self.rem_time = rem_time
        self.opened_valves = opened_valves

    def __repr__(self):
        return f"State(valve={self.valve}, time={self.rem_time}, opened={self.opened_valves})"

    def __hash__(self):
        return hash((self.valve, self.rem_time, frozenset(self.opened_valves)))

class StateB:
    def __init__(self, cur_valves_and_times, opened_valves):
        self.valves_and_times = cur_valves_and_times
        self.opened_valves = opened_valves

    def __repr__(self):
        return f"State(valves/times={self.valves_and_times}, opened={self.opened_valves})"

    def __hash__(self):
        return hash((frozenset(self.valves_and_times), frozenset(self.opened_valves)))

def parse_line_to_node(line):
    match = re.search("Valve (.+) has flow rate=(\d+); tunnels? leads? to valves? ((?:.+)(?:, (.+))*)", line)
    valve = match.group(1)
    rate = int(match.group(2))
    tunnels = match.group(3).split(", ")
    return Node(valve, rate, tunnels)

def compute_distances(distances, start_node, cur_node = None, cur_dist = 0, visited = []):
    if cur_node is None:
        cur_node = start_node

    new_visited = visited.copy() + [cur_node.valve]
    new_dist = cur_dist + 1

    if start_node.valve not in distances:
        distances[start_node.valve] = {}

    for tunnel in cur_node.tunnels:
        if tunnel.valve in visited:
            continue
        if tunnel.valve in distances[start_node.valve] and new_dist >= distances[start_node.valve][tunnel.valve]:
            continue

        if tunnel.valve not in distances:
            distances[tunnel.valve] = {}

        distances[start_node.valve][tunnel.valve] = new_dist

        compute_distances(distances, start_node, tunnel, new_dist, new_visited)

def find_best_path_a(cur_node, rem_time, opened_valves, all_nodes, cache = {}, level = 0):
    if rem_time == 0:
        return ([], 0)

    indent = " " * level

    cur_state = StateA(cur_node.valve, rem_time, opened_valves)
    cur_state_hash = hash(cur_state)
    if cur_state_hash in cache:
        return cache[cur_state_hash]

    options = []

    for next_valve in cur_node.distances:
        if next_valve in opened_valves or next_valve not in all_nodes:
            continue

        distance = cur_node.distances[next_valve]

        new_time = rem_time - distance - 1
        if new_time < 0:
            continue

        next_node = all_nodes[next_valve]

        if next_node.rate == 0:
            continue

        subres = find_best_path_a(next_node, new_time, opened_valves + [next_valve], all_nodes, cache, level + 1)
        node_payout = next_node.rate * new_time
        total_payout = node_payout + subres[1]
        options.append(([next_node.valve] + subres[0], total_payout))

    if len(options) > 0:
        res = max(options, key = lambda o: o[1])
    else:
        res = ([], 0)

    cache[cur_state_hash] = res
    return res

def find_best_path_b(cur_node_a, cur_node_b, rem_time_a, rem_time_b, opened_valves, all_nodes, cache = {}, level = 0):
    if rem_time_a == 0 and rem_time_b == 0:
        return ([], 0)

    indent = " " * level

    cur_state = StateB([(cur_node_a.valve, rem_time_a), (cur_node_b.valve, rem_time_b)], opened_valves)
    cur_state_hash = hash(cur_state)
    if cur_state_hash in cache:
        return cache[cur_state_hash]

    options = []

    for next_valve_a in cur_node_a.distances:
        if next_valve_a in opened_valves or next_valve_a not in all_nodes:
            continue

        distance_a = cur_node_a.distances[next_valve_a]

        new_time_a = rem_time_a - distance_a - 1
        if new_time_a < 0:
            continue

        next_node_a = all_nodes[next_valve_a]

        if next_node_a.rate == 0:
            continue

        for next_valve_b in cur_node_b.distances:
            if next_valve_b in opened_valves or next_valve_b not in all_nodes or next_valve_b == next_valve_a:
                continue

            distance_b = cur_node_b.distances[next_valve_b]

            new_time_b = rem_time_b - distance_b - 1
            if new_time_b < 0:
                continue

            next_node_b = all_nodes[next_valve_b]
            if next_node_b.rate == 0:
                continue

            subres = find_best_path_b(next_node_a, next_node_b, new_time_a, new_time_b, opened_valves + [next_valve_a, next_valve_b], all_nodes, cache, level + 1)
            node_payout_a = next_node_a.rate * new_time_a
            node_payout_b = next_node_b.rate * new_time_b
            total_payout = node_payout_a + node_payout_b + subres[1]
            options.append(([[next_node_a.valve, next_node_b.valve]] + subres[0], total_payout))

    if len(options) > 0:
        res = max(options, key = lambda o: o[1])
    else:
        res = ([], 0)

    cache[cur_state_hash] = res
    return res

in_file = open("input.txt", "r")
lines = in_file.readlines()

nodes_list = list(map(parse_line_to_node, lines))
nodes = {nodes_list[i].valve: nodes_list[i] for i in range(0, len(nodes_list))}

for node in nodes_list:
    node.tunnels = list(map(lambda id: nodes[id], node.tunnel_ids))

distances = {}
for node in nodes_list:
    compute_distances(distances, node)

fc_nodes = {}
for node in nodes_list:
    if node.rate == 0 and node.valve != START_NODE:
        continue

    fc_nodes[node.valve] = FCNode(node.valve, node.rate, distances[node.valve])

best_score = find_best_path_a(fc_nodes[START_NODE], INITIAL_TIME_A, [], fc_nodes)
print(f"Part A: {best_score[1]}")

best_score = find_best_path_b(fc_nodes[START_NODE], fc_nodes[START_NODE], INITIAL_TIME_B, INITIAL_TIME_B, [], fc_nodes)
print(f"Part B: {best_score[1]}")
