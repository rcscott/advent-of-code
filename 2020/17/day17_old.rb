filename = "day17_input.txt"
initial_grid = File.open(filename).readlines.map(&:chomp).map(&:chars)
initial_grid = initial_grid.map.each_with_index do |row, i|
  [i, row.map.each_with_index { |col, j| [j, col]}.to_h]
end.to_h

# { w: { z: { y: { x: val } } }
grid = {
  0 => { 0 => initial_grid }
}

def print_grid(grid)
  grid.each do |w, z_planes|
    z_planes.each do |z, rows|
      puts "z=#{z}, w=#{w}"
      rows.keys.sort.each do |y|
        puts rows[y].keys.sort.map { |x| rows[y][x] }.join('')
      end
      puts "\n"
    end
  end
end

def create_empty_row(min, max)
  (min..max).map { |col| [col, '.'] }.to_h
end

def create_empty_z(min, max)
  z = {}
  (min..max).each do |row|
    z[row] = create_empty_row(min, max)
  end

  z
end

def create_empty_w(min, max, col_min, col_max)
  w = {}
  (min..max).each do |z_plane|
    w[z_plane] = create_empty_z(col_min, col_max)
  end

  w
end

def add_padding_to_grid(grid)
  new_grid = {}

  min = -15
  max = 15
  (min..max).each do |w|
    new_grid[w] = {}

    (min..max).each do |z|
      new_grid[w][z] = {}

      (min..max).each do |y|
        new_grid[w][z][y] = {}

        (min..max).each do |x|
          new_grid[w][z][y][x] = grid.dig(w, z, y, x) || '.'
        end
      end
    end
  end

  new_grid
end

def get_coordinates_to_check(x, y, z, w)
  coordinates = []
  x_current = x - 1
  y_current = y - 1
  z_current = z - 1
  w_current = w - 1

  while x_current <= x + 1 do
    while y_current <= y + 1 do
      while z_current <= z + 1 do
        while w_current <= w + 1 do
          unless x_current == x && y_current == y && z_current == z && w_current == w
            coordinates << {x: x_current, y: y_current, z: z_current, w: w_current}
          end

          w_current += 1
        end

        w_current = w - 1
        z_current += 1
      end

      z_current = z - 1
      y_current += 1
    end

    y_current = y - 1
    x_current += 1
  end

  coordinates
end

def get_new_cube_state(grid, x, y, z, w, cube_state)
  active_neighbors = 0
  neighbor_coordinates = get_coordinates_to_check(x, y, z, w)

  neighbor_coordinates.each do |neighbor|
    if grid.dig(neighbor[:w], neighbor[:z], neighbor[:y], neighbor[:x]) == '#'
      active_neighbors += 1
    end
  end

  # puts "#{x}, #{y}, #{z}, #{w}, active neighbors: #{active_neighbors}"

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

print_grid(grid)

grid = add_padding_to_grid(grid)

6.times do |i|
  new_grid = Marshal::load(Marshal.dump(grid))

  active_cube_count = 0

  grid.each do |w, z_planes|
    z_planes.each do |z, rows|
      rows.each do |y, cols|
        cols.each do |x, cube_state|
          new_cube_state = get_new_cube_state(grid, x, y, z, w, cube_state)
          active_cube_count += 1 if new_cube_state == '#'
          new_grid[w][z][y][x] = new_cube_state
        end
      end
    end
  end

  grid = new_grid

  puts "\n"
  puts "\nAfter #{i + 1} cycles: #{active_cube_count} active cubes"
end
