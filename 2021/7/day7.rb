def calc_fuel_cost_part_1(crab_positions, target_position)
  crab_positions.map do |crab_position|
    (target_position - crab_position).abs
  end.inject(:+)
end

def calc_fuel_cost_part_2(crab_positions, target_position)
  crab_positions.map do |crab_position|
    distance = (target_position - crab_position).abs
     distance > 0 ? (1..distance).inject(:+) : 0
  end.inject(:+)
end

crab_positions = File.open('input.txt').readlines.map(&:chomp).first.split(',').map(&:to_i)
crab_positions.sort!

fuel_costs_part_1 = {}
(crab_positions.first..crab_positions.last).each do |target_position|
  fuel_cost = calc_fuel_cost_part_1(crab_positions, target_position)
  fuel_costs_part_1[fuel_cost] = target_position
end

puts fuel_costs_part_1.keys.sort.first

fuel_costs_part_2 = {}
(crab_positions.first..crab_positions.last).each do |target_position|
  fuel_cost = calc_fuel_cost_part_2(crab_positions, target_position)
  fuel_costs_part_2[fuel_cost] = target_position
end

puts fuel_costs_part_2.keys.sort.first
