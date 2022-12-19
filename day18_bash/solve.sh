#!/usr/bin/env bash

lines=()

while read -r line; do
    lines="$lines $line"
done < "input.txt"
lines=($lines)

surface_a=0

for line in "${lines[@]}"; do
    cube=(${line//,/ })

    x=${cube[0]}
    y=${cube[1]}
    z=${cube[2]}

    left="$((x - 1)),$y,$z"
    right="$((x + 1)),$y,$z"
    down="$x,$((y - 1)),$z"
    up="$x,$((y + 1)),$z"
    back="$x,$y,$((z - 1))"
    front="$x,$y,$((z + 1))"

    sides=0

    if [[ ! " ${lines[*]} " =~ " ${left} " ]]; then
        sides=$((sides + 1))
    fi
    if [[ ! " ${lines[*]} " =~ " ${right} " ]]; then
        sides=$((sides + 1))
    fi
    if [[ ! " ${lines[*]} " =~ " ${down} " ]]; then
        sides=$((sides + 1))
    fi
    if [[ ! " ${lines[*]} " =~ " ${up} " ]]; then
        sides=$((sides + 1))
    fi
    if [[ ! " ${lines[*]} " =~ " ${back} " ]]; then
        sides=$((sides + 1))
    fi
    if [[ ! " ${lines[*]} " =~ " ${front} " ]]; then
        sides=$((sides + 1))
    fi

    surface_a=$((surface_a + sides))
done

echo "Part A: $surface_a"

visited=()
air=()

flood_fill () {
    local cur=($1)
    local oct_x=$2
    local oct_x=$3
    local oct_z=$4

    local x=${cur[0]}
    local y=${cur[1]}
    local z=${cur[2]}

    local cs="$x,$y,$z"

    if [[ " ${visited[*]} " =~ " ${cs} " ]]; then
        return
    fi

    visited="$visited $cs"

    if [[ " ${lines[*]} " =~ " ${cs} " ]]; then
        return
    fi

    air="$air $cs"

    if [[ $x -ge $((oct_x * 12)) ]]; then
        flood_fill "$((x - 1)) $y $z" $oct_x $oct_y $oct_z
    fi
    if [[ $x -lt $(($((oct_x + 1)) * 11)) ]]; then
        flood_fill "$((x + 1)) $y $z" $oct_x $oct_y $oct_z
    fi
    if [[ $y -ge $((oct_x * 12)) ]]; then
        flood_fill "$x $((y - 1)) $z" $oct_x $oct_y $oct_z
    fi
    if [[ $y -lt $(($((oct_x + 1)) * 11)) ]]; then
        flood_fill "$x $((y + 1)) $z" $oct_x $oct_y $oct_z
    fi
    if [[ $z -ge $((oct_x * 12)) ]]; then
        flood_fill "$x $y $((z - 1))" $oct_x $oct_y $oct_z
    fi
    if [[ $z -lt $(($((oct_x + 1)) * 11)) ]]; then
        flood_fill "$x $y $((z + 1))" $oct_x $oct_y $oct_z
    fi
}

flood_fill "0 0 0" 0 0 0
flood_fill "22 0 0" 1 0 0
flood_fill "0 22 0" 0 1 0
flood_fill "0 0 22" 0 0 1
flood_fill "22 22 0" 1 1 0
flood_fill "22 0 22" 1 0 1
flood_fill "0 22 22" 0 1 1
flood_fill "22 22 22" 1 1 1

surface_b=0

index=0
for line in "${lines[@]}"; do
    index=$((index + 1))
    cube=(${line//,/ })

    x=${cube[0]}
    y=${cube[1]}
    z=${cube[2]}

    left="$((x - 1)),$y,$z"
    right="$((x + 1)),$y,$z"
    down="$x,$((y - 1)),$z"
    up="$x,$((y + 1)),$z"
    back="$x,$y,$((z - 1))"
    front="$x,$y,$((z + 1))"

    sides=0

    if [[ " ${air[*]} " =~ " ${left} " ]]; then
        sides=$((sides + 1))
    fi
    if [[ " ${air[*]} " =~ " ${right} " ]]; then
        sides=$((sides + 1))
    fi
    if [[ " ${air[*]} " =~ " ${down} " ]]; then
        sides=$((sides + 1))
    fi
    if [[ " ${air[*]} " =~ " ${up} " ]]; then
        sides=$((sides + 1))
    fi
    if [[ " ${air[*]} " =~ " ${back} " ]]; then
        sides=$((sides + 1))
    fi
    if [[ " ${air[*]} " =~ " ${front} " ]]; then
        sides=$((sides + 1))
    fi

    surface_b=$((surface_b + sides))
done

echo "Part B: $surface_b"
