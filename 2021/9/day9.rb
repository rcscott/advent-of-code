def is_less_than(point, comparison_point)
  return true if comparison_point.nil?
  point < comparison_point
end

def get_surrounding_points(heightmap, row_num, col_num, ignore_point: nil)
  surrounding_points = [
    [row_num - 1, col_num],
    [row_num, col_num - 1],
    [row_num + 1, col_num],
    [row_num, col_num + 1]
  ]

  surrounding_points.reject { |r, c| r < 0 || c < 0 || [r, c] == ignore_point }
end

def is_low_point(heightmap, row_num, col_num, ignore_point: nil)
  point = heightmap.dig(row_num, col_num)
  return false if point.nil?

  get_surrounding_points(heightmap, row_num, col_num, ignore_point: ignore_point).each do |r, c|
    return false unless is_less_than(point, heightmap.dig(r, c))
  end

  true
end

heightmap = File.open('example.txt').readlines.map(&:chomp).map(&:chars).map { |row| row.map(&:to_i) }

low_points = []
low_point_locations = []
heightmap.each_with_index do |row, row_num|
  row.each_with_index do |point, col_num|
    next unless is_low_point(heightmap, row_num, col_num)

    low_points << point
    low_point_locations << [row_num, col_num]
  end
end

# pp low_points
# pp low_point_locations

risk_level = low_points.inject(0) { |sum, p| sum + (p + 1) }
puts risk_level

def get_surrounding_low_points(heightmap, row_num, col_num, ignore_point: nil)
  if is_low_point(heightmap, row_num, col_num, ignore_point: ignore_point)
    surrounding_points = get_surrounding_points(heightmap, row_num, col_num, ignore_point: ignore_point)
    surrounding_low_points = []
    surrounding_points.each do |r, c|
      # pp [r, c]
      if is_low_point(heightmap, r, c, ignore_point: [row_num, col_num])
        surrounding_low_points << [r, c]
        surrounding_low_points += get_surrounding_low_points(heightmap, r, c, ignore_point: [row_num, col_num])
      end
    end
    return [[row_num, col_num]] + surrounding_low_points.compact
  else
    return []
  end
end

basin_sizes = []
low_point_locations.each do |row_num, col_num|
  points = get_surrounding_low_points(heightmap, row_num, col_num, ignore_point: nil).compact.uniq
  pp points
  basin_sizes << points.size
end

puts basin_sizes
