filename = "day11_input.txt"
seating_chart = File.open(filename).readlines.map(&:chomp).map(&:chars)

def count_visible_occupied_seats(seating_chart, row, col)
  seat_directions = [
    { row_incr: -1, col_incr: -1 },
    { row_incr: -1, col_incr: 0 },
    { row_incr: -1, col_incr: 1 },
    { row_incr: 0, col_incr: 1 },
    { row_incr: 1, col_incr: 1 },
    { row_incr: 1, col_incr: 0 },
    { row_incr: 1, col_incr: -1 },
    { row_incr: 0, col_incr: -1 },
  ]

  occupied_seats = 0
  seat_directions.each do |direction|
    seat_row = row
    seat_col = col

    loop do
      seat_row += direction[:row_incr]
      seat_col += direction[:col_incr]

      break if seat_row < 0 || seat_col < 0 || seat_row >= seating_chart.length || seat_col >= seating_chart.first.length

      if seating_chart[seat_row][seat_col] == "#"
        occupied_seats += 1
        break
      elsif seating_chart[seat_row][seat_col] == "L"
        break
      end
    end
  end

  occupied_seats
end

rounds = 1

loop do
  new_seating_chart = Marshal::load(Marshal.dump(seating_chart))
  seating_chart.each_index do |row|
    seating_chart[row].each_index do |col|
      next if seating_chart[row][col] == "."

      occupied_adjacent_seats = count_visible_occupied_seats(seating_chart, row, col)
      if seating_chart[row][col] == "L" && occupied_adjacent_seats == 0
        new_seating_chart[row][col] = "#"
      elsif seating_chart[row][col] == "#" && occupied_adjacent_seats >= 5
        new_seating_chart[row][col] = "L"
      end
    end
  end

  if new_seating_chart != seating_chart
    rounds += 1
    seating_chart = Marshal::load(Marshal.dump(new_seating_chart))
  else
    break
  end

  puts "\n*** new seating chart: ***"
  new_seating_chart.each do |row|
    puts row.join
  end
end

puts "\nRounds until stable: #{rounds}"
puts "Occupied seats: #{seating_chart.join.count("#")}"
