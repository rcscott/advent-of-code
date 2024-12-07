grid = File.open("input.txt").readlines.map(&:chomp).map(&:chars)

class GridWalker
  attr_reader :visited_positions, :looped, :start_x, :start_y

  def initialize(grid)
    @directions = {
      up: { turn: :right, next_pos: ->(x, y) { [x, y - 1] } },
      right: { turn: :down, next_pos: ->(x, y) { [x + 1, y] } },
      down: { turn: :left, next_pos: ->(x, y) { [x, y + 1] } },
      left: { turn: :up, next_pos: ->(x, y) { [x - 1, y] } },
    }
    @direction = :up
    @direction_instructions = @directions[@direction]

    @grid = grid
    @grid.each_with_index do |row, y|
      row.each_with_index do |position, x|
        if position == "^"
          @current_x = x
          @current_y = y
          break
        end
      end

      break unless @current_x.nil?
    end

    @start_x = @current_x
    @start_y = @current_y

    @visited_positions = Set.new()
    @visited_positions_with_direction = Set.new()
    save_current_position
  end

  def save_current_position
    @visited_positions << [@current_x, @current_y]
  end

  def save_current_position_with_direction
    @visited_positions_with_direction << [@current_x, @current_y, @direction]
  end

  def within_bounds?(x, y)
    x >= 0 && x < @grid.first.size && y >= 0 && y < @grid.size
  end

  def finished?
    !within_bounds?(@current_x, @current_y)
  end

  def check_for_loop(next_x, next_y, direction)
    if @visited_positions_with_direction.include?([next_x, next_y, direction])
      @looped = true
    end
  end

  def turn
    @direction = @direction_instructions[:turn]
    @direction_instructions = @directions[@direction]
  end

  def move
    next_x, next_y = @direction_instructions[:next_pos].call(@current_x, @current_y)

    while within_bounds?(next_x, next_y) && @grid[next_y][next_x] == "#" do
      turn
      next_x, next_y = @direction_instructions[:next_pos].call(@current_x, @current_y)
    end

    check_for_loop(next_x, next_y, @direction)

    @current_x, @current_y = next_x, next_y
    save_current_position if within_bounds?(@current_x, @current_y)
    save_current_position_with_direction if within_bounds?(@current_x, @current_y)
  end
end

puts "Part 1:"
walker = GridWalker.new(grid)

while !walker.finished?
  walker.move
end

puts walker.visited_positions.size

puts "Part 2:"
valid_obstructions = (walker.visited_positions - [[walker.start_x, walker.start_y]]).sum do |x, y|
  grid_with_obstruction = grid.map(&:dup)
  grid_with_obstruction[y][x] = "#"

  walker_with_obscruction = GridWalker.new(grid_with_obstruction)
  while !walker_with_obscruction.finished? && !walker_with_obscruction.looped
    walker_with_obscruction.move
  end

  walker_with_obscruction.looped ? 1 : 0
end

puts valid_obstructions
