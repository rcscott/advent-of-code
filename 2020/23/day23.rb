def print_final_cups_output(cups)
  index = cups.index(1)
  solution = cups[index + 1...] + cups[0...index]
  puts "Part 1 solution: #{solution.join}"
end

def play_round(cups)
  current_cup = cups.shift
  moving_cups = cups.shift(3)

  # puts "cups: (#{current_cup}) #{moving_cups.join(' ')} #{cups.join(' ')}"
  # puts "pick up: #{moving_cups.join(' ')}"

  lowest_cup, highest_cup = cups.minmax

  destination_cup = current_cup - 1
  while cups.index(destination_cup).nil?
    destination_cup -= 1

    destination_cup = highest_cup if destination_cup < lowest_cup
  end

  # puts "destination: #{destination_cup}"

  cups.insert(cups.index(destination_cup) + 1, *moving_cups)
  cups.unshift(current_cup)
  cups.rotate
end

example = "389125467"
input = "712643589"

cups = input.chars.map(&:to_i)
cups_original = cups.clone

100.times do |move_num|
  # puts "-- move #{move_num + 1} --"
  cups = play_round(cups)
end

print_final_cups_output(cups)

# #### PART 2 ####

# Pad cups to 1 million numbers
highest_cup = cups_original.max
(highest_cup + 1..1_000_000).each do |n|
  cups_original << n
end

current_cup = cups_original.first
cups = {}
cups_original.each_index do |cup_index|
  if cups_original[cup_index + 1]
    cups[cups_original[cup_index]] = cups_original[cup_index + 1]
  else
    cups[cups_original[cup_index]] = cups_original.first
  end
end

10_000_000.times do |move_num|
  moving_cups = [cups[current_cup]]
  moving_cups << cups[moving_cups.last]
  moving_cups << cups[moving_cups.last]

  destination_cup = current_cup - 1
  loop do
    if moving_cups.include?(destination_cup)
      destination_cup -= 1
    elsif destination_cup < 1
      destination_cup = (cups.keys - moving_cups).max
    else
      break
    end
  end

  if (move_num + 1) % 1_000_000 == 0
    puts "\n-- move #{move_num + 1} --"
    puts "Current cup: #{current_cup}"
    puts "pick up: #{moving_cups.join(' ')}"
    puts "destination: #{destination_cup}"
  end

  destination_cup_previous_value = cups[destination_cup]
  last_moving_cup_previous_value = cups[moving_cups.last]

  cups[destination_cup] = moving_cups.first
  cups[moving_cups.last] = destination_cup_previous_value
  cups[current_cup] = last_moving_cup_previous_value
  current_cup = cups[current_cup]
end

puts
next_cup_1 = cups[1]
puts next_cup_1
next_cup_2 = cups[next_cup_1]
puts next_cup_2

puts "Part 2 solution: #{next_cup_1 * next_cup_2}"
