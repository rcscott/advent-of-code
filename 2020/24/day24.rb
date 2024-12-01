filename = "day24_example.txt"
tiles_list = File.open(filename).readlines.map(&:chomp)
tiles_list = [
  'ew',
  'se',
  'ne',
  'sw',
  'ww',
]

# { col(q): { row(r): black/white } }
tiles = {}

tiles_list.each do |directions_str|
  tile_directions = []
  while directions_str.length > 0 do
    ['se', 'sw', 'ne', 'nw', 'e', 'w'].each do |direction|
      if directions_str.start_with?(direction)
        directions_str.delete_prefix!(direction)
        tile_directions << direction
      end
    end
  end

  q = 0
  r = 0
  tile_directions.each do |direction|
    if direction == 'e'
      q += 1
    elsif direction == 'w'
      q -= 1
    else
      if r == 0 || r % 2 == 0
        case direction
        when 'se'
          r += 1
        when 'sw'
          q -= 1
          r += 1
        when 'nw'
          q -= 1
          r -= 1
        when 'ne'
          r -= 1
        end
      else
        case direction
        when 'se'
          q += 1
          r += 1
        when 'sw'
          r += 1
        when 'nw'
          r -= 1
        when 'ne'
          q += 1
          r -= 1
        end
      end
    end
  end

  # puts "#{tile_directions.join(', ')}: #{q}, #{r}"

  if !tiles.has_key?(q)
    tiles[q] = {}
  end

  if !tiles[q].has_key?(r)
    # tiles start with white side up,
    # if we're finding for the first time then we flip to black
    puts "setting tile (#{q}, #{r}) to black"
    tiles[q][r] = 'black'
  else
    # tile exists, flip it
    puts "flipping tile(#{q}, #{r}), currently #{tiles[q][r]}"
    tiles[q][r] = tiles[q][r] == 'black' ? 'white' : 'black'
  end
end

# tiles.each do |q, rows|
#   puts "#{q}: #{rows.map { |r, tile| "#{r},#{tile}"}.join(' ')}"
# end

black_tile_count = tiles.values.sum { |rows| rows.values.count { |t| t == 'black' } }
puts "Initial # of black tiles: #{black_tile_count}"

def count_adjacent_black_tiles(tiles, q, r)
  if r == 0 || r % 2 == 0
    direction_increments = [[1, 0], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1]]
  else
    direction_increments = [[1, 0], [1, 1], [0, 1], [-1, 0], [0, -1], [1, -1]]
  end

  direction_increments.count do |q_incr, r_incr|
    if tiles.dig(q + q_incr, r + r_incr)
      tiles[q + q_incr][r + r_incr] == 'black'
    end
  end
end

def flip_all_tiles(tiles)
  new_tiles = Marshal::load(Marshal.dump(tiles))

  tiles.each do |q, rows|
    rows.each do |r, tile|
      adjacent_black_tiles = count_adjacent_black_tiles(tiles, q, r)
      puts "(#{q}, #{r}) #{adjacent_black_tiles}"

      if tile == 'black' && (adjacent_black_tiles == 0 || adjacent_black_tiles > 2)
        # puts 'black tile flipping to white'
        new_tiles[q][r] = 'white'
      elsif tile == 'white' && adjacent_black_tiles == 2
        # puts 'white tile flipping to black'
        new_tiles[q][r] = 'black'
      end
    end
  end

  new_tiles
end

1.times do |i|
  tiles = flip_all_tiles(tiles)
  black_tile_count = tiles.values.sum { |rows| rows.values.count { |t| t == 'black' } }
  puts "Day #{i + 1}: #{black_tile_count}"
end
