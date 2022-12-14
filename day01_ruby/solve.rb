#!/usr/bin/env ruby

in_path = './input.txt'

sums = []
sum = 0

File.readlines(in_path, chomp: true).each do |line|
    if line.empty?
        sums.push sum
        sum = 0
    else
        sum += line.to_i
    end
end

sums.sort!
sums.reverse!
puts 'Part 1: ' + sums[0].to_s
puts 'Part 2: ' + (sums[0] + sums[1] + sums[2]).to_s
