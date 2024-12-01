filename = "day17_input.txt"
initial_grid = File.open(filename).readlines.map(&:chomp).map(&:chars)
initial_grid = initial_grid.map.each_with_index do |row, i|
  [i, row.map.each_with_index { |col, j| [j, col]}.to_h]
end.to_h

# { w: { z: { y: { x: val } } }
grid = {
  0 => { 0 => initial_grid }
}

grid_boundaries = {
  x: { min: initial_grid[0].keys.first, max: initial_grid[0].keys.last },
  y: { min: initial_grid.keys.first, max: initial_grid.keys.last },
  z: { min: 0, max: 0 },
  w: { min: 0, max: 0 },
}

def print_grid(grid, grid_boundaries)
  (grid_boundaries[:w][:min]..grid_boundaries[:w][:max]).each do |w|
    (grid_boundaries[:z][:min]..grid_boundaries[:z][:max]).each do |z|
      puts "z=#{z}, w=#{w}"

      (grid_boundaries[:y][:min]..grid_boundaries[:y][:max]).each do |y|
        puts (grid_boundaries[:x][:min]..grid_boundaries[:x][:max]).map { |x| grid.dig(w, z, y, x) || '.' }.join('')
      end

      puts "\n"
    end
  end
end

def increase_boundaries(grid, grid_boundaries)
  grid_boundaries.each do |axis, boundaries|
    grid_boundaries[axis] = { min: boundaries[:min] - 1, max: boundaries[:max] + 1}
  end
end

def get_coordinates_to_check(current_x, current_y, current_z, current_w)
  coordinates = []

  (current_x - 1..current_x + 1).each do |x|
    (current_y - 1..current_y + 1).each do |y|
      (current_z - 1..current_z + 1).each do |z|
        (current_w - 1..current_w + 1).each do |w|
          unless current_x == x && current_y == y && current_z == z && current_w == w
            coordinates << { x: x, y: y, z: z, w: w }
          end
        end
      end
    end
  end

  coordinates
end

def get_new_cube_state(grid, x, y, z, w)
  active_neighbors = 0
  neighbor_coordinates = get_coordinates_to_check(x, y, z, w)

  neighbor_coordinates.each do |neighbor|
    if grid.dig(neighbor[:w], neighbor[:z], neighbor[:y], neighbor[:x]) == '#'
      active_neighbors += 1
    end
  end

  cube_state = grid.dig(w, z, y, x)
  if cube_state == '#'
    unless [2, 3].include?(active_neighbors)
      cube_state = '.'
    end
  else
    if active_neighbors == 3
      cube_state = '#'
    end
  end

  return cube_state
end

def insert_cube_state(grid, x, y, z, w, new_cube_state)
  grid[w] = {} if grid.dig(w).nil?
  grid[w][z] = {} if grid.dig(w, z).nil?
  grid[w][z][y] = {} if grid.dig(w, z, y).nil?
  grid[w][z][y][x] = new_cube_state
end

print_grid(grid, grid_boundaries)

6.times do |i|
  increase_boundaries(grid, grid_boundaries)
  new_grid = Marshal::load(Marshal.dump(grid))

  active_cube_count = 0

  (grid_boundaries[:w][:min]..grid_boundaries[:w][:max]).each do |w|
    (grid_boundaries[:z][:min]..grid_boundaries[:z][:max]).each do |z|
      (grid_boundaries[:y][:min]..grid_boundaries[:y][:max]).each do |y|
        (grid_boundaries[:x][:min]..grid_boundaries[:x][:max]).each do |x|
          new_cube_state = get_new_cube_state(grid, x, y, z, w)
          active_cube_count += 1 if new_cube_state == '#'
          insert_cube_state(new_grid, x, y, z, w, new_cube_state)
        end
      end
    end
  end

  grid = new_grid
  # print_grid(grid, grid_boundaries)

  puts "\nAfter #{i + 1} cycles: #{active_cube_count} active cubes"
end
