grid = File.open("input.txt").readlines.map(&:chomp).map(&:chars).map do |line|
  line.map(&:to_i)
end

def evaluate_trail(grid, previous_height, x, y, unique_summits: true)
  return false if x < 0 || y < 0 || x >= grid.first.size || y >= grid.size

  height = grid[y][x]
  return false if height != previous_height + 1
  return {x:, y:} if height == 9

  results = [
    evaluate_trail(grid, height, x + 1, y, unique_summits:),
    evaluate_trail(grid, height, x, y + 1, unique_summits:),
    evaluate_trail(grid, height, x - 1, y, unique_summits:),
    evaluate_trail(grid, height, x, y - 1, unique_summits:),
  ].flatten.reject { |result| result == false }

  unique_summits ? results.uniq : results
end

puts "Part 1:"
tally = grid.each_with_index.sum do |row, y|
  row.each_with_index.sum do |height, x|
    next 0 unless height == 0
    evaluate_trail(grid, -1, x, y).count
  end
end
puts tally

puts "Part 2:"
tally = grid.each_with_index.sum do |row, y|
  row.each_with_index.sum do |height, x|
    next 0 unless height == 0
    evaluate_trail(grid, -1, x, y, unique_summits: false).count
  end
end
puts tally
