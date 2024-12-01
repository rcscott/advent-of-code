require 'set'

filename = "day16_input.txt"
input = File.open(filename).readlines.map(&:chomp)

iter = input.each

num_to_fields = Hash.new { |h, k| h[k] = [] }
loop do
  line = iter.next
  break if line == ''

  m = line.match(/(?<field>[a-z ]+): (?<pos_range_1>\d+-\d+) or (?<pos_range_2>\d+-\d+)/)
  ranges = []
  ranges << m[:pos_range_1].split('-').map(&:to_i)
  ranges << m[:pos_range_2].split('-').map(&:to_i)
  ranges.each do |range|
    (range.first..range.last).each { |num| num_to_fields[num] << m[:field] }
  end
end

# puts valid_nums

iter.next  # your ticket:
your_ticket_nums = iter.next.split(',').map(&:to_i)

iter.next  # blank line
iter.next  # nearby tickets:

field_to_position_solutions = Hash.new { |h, k| h[k] = [] }
loop do
  begin
    line = iter.next
  rescue StopIteration
    break
  end

  ticket_nums = line.split(',').map(&:to_i)
  next if ticket_nums.any? { |num| !num_to_fields.keys.include?(num) }

  solutions = Hash.new { |h, k| h[k] = [] }
  ticket_nums.each_index do |position|
    num = ticket_nums[position]
    valid_fields = num_to_fields[num]
    valid_fields.each { |field| solutions[field] << position }
  end

  solutions.each_pair { |field, positions| field_to_position_solutions[field] << positions }
end

position_to_fields_solutions = Hash.new { |h, k| h[k] = [] }

field_to_position_solutions.each_pair do |field, positions|
  positions.inject(&:&).each { |p| position_to_fields_solutions[p] << field }
end

loop do
  solved = {}
  unsolved = {}

  position_to_fields_solutions.each_pair do |position, fields|
    if fields.length == 1
      solved[position] = fields
    else
      unsolved[position] = fields
    end
  end

  break if unsolved.empty?

  solved_fields = solved.values.flatten
  unsolved.each_pair do |position, fields|
    position_to_fields_solutions[position] = fields - solved_fields
  end
end

# puts position_to_fields_solutions

departure_values = []
your_ticket_nums.each_index do |position|
  if position_to_fields_solutions[position].first.start_with?('departure')
    departure_values << your_ticket_nums[position]
  end
end

# puts departure_values
puts "Departure values, multiplied: #{departure_values.inject(&:*)}"
