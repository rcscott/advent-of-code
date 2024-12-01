grid = File.open("day3_input.txt").readlines.map(&:chomp)
grid_width = grid.first.length

trees_encountered = []
slopes = [[1, 1], [1, 3], [1, 5], [1, 7], [2, 1]]

slopes.each do |slope|
  row = 0
  col = 0
  trees = 0

  while true do
    row += slope.first
    col += slope.last
    if col >= grid_width
      col = col - grid_width
    end

    break if row >= grid.length

    if grid[row][col] == "#"
      trees += 1
    end
  end

  trees_encountered.push(trees)
end

puts "Trees encountered: #{trees_encountered.reject(&:zero?).inject(:*)}"
