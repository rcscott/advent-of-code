filename = "day13_input.txt"
earliest_departure_time, bus_id_data = File.open(filename).readlines.map(&:chomp)

# Part 1
# earliest_departure_time = earliest_departure_time.to_i

# bus_times = {}
# bus_ids.each do |bus_id|
#   if earliest_departure_time % bus_id == 0
#     bus_times[earliest_departure_time] = bus_id
#   else
#     departure = ((earliest_departure_time / bus_id) + 1) * bus_id
#     bus_times[departure] = bus_id
#   end
# end

# first_arrival_time = bus_times.keys.sort.first
# first_bus = bus_times[first_arrival_time]
# puts "First bus: #{first_bus}, first arrival: #{first_arrival_time}"
# puts "Solution: #{first_bus * (first_arrival_time - earliest_departure_time)}"

# Part 2
# [{bus_id: 1, t_incr: 0, bus_id: 3, t_incr: 5}]
buses = []
bus_id_data = bus_id_data.split(',')
bus_id_data.each_index do |i|
  next if bus_id_data[i] == 'x'

  buses << { bus_id: bus_id_data[i].to_i, t_incr: i }
end

first_bus = buses.shift
t = first_bus[:bus_id]
t_incr = t

buses.each do |bus|
  loop do
    break if (t + bus[:t_incr]) % bus[:bus_id] == 0
    t += t_incr
  end

  puts "Solved #{bus[:bus_id]} at #{t}"
  t_incr *= bus[:bus_id]
end

puts "Earliest timestamp: #{t}"
