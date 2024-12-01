class VentLine
  attr_accessor :start_x, :end_x, :start_y, :end_y

  def initialize(raw_str)
    raw_start, raw_end = raw_str.split(' -> ')
    @start_x, @start_y = raw_start.split(',').map(&:to_i)
    @end_x, @end_y = raw_end.split(',').map(&:to_i)
  end
end

data = File.open('input.txt').readlines.map(&:chomp)
vents = data.map { |line| VentLine.new(line) }

grid = Hash.new { |h, k| h[k] = {} }
vents.each do |vent|
  if vent.start_x == vent.end_x
    start_y, end_y = [vent.start_y, vent.end_y].minmax
    (start_y..end_y).each do |y|
      if grid[vent.start_x][y].nil?
        grid[vent.start_x][y] = 1
      else
        grid[vent.start_x][y] += 1
      end
    end
  elsif vent.start_y == vent.end_y
    start_x, end_x = [vent.start_x, vent.end_x].minmax
    (start_x..end_x).each do |x|
      if grid[x][vent.start_y].nil?
        grid[x][vent.start_y] = 1
      else
        grid[x][vent.start_y] += 1
      end
    end
  else # diagonal line
    x_range = vent.start_x < vent.end_x ? vent.start_x.upto(vent.end_x) : vent.start_x.downto(vent.end_x)
    y_range = vent.start_y < vent.end_y ? vent.start_y.upto(vent.end_y) : vent.start_y.downto(vent.end_y)
    combined = x_range.zip(y_range)
    combined.each do |x, y|
      if grid[x][y].nil?
        grid[x][y] = 1
      else
        grid[x][y] += 1
      end
    end
  end
end

overlap_count = 0
grid.each do |x, column|
  column.each do |y, count|
    if count >= 2
      overlap_count += 1
    end
  end
end

puts overlap_count
