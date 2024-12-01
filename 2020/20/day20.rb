filename = "day20_input.txt"
input = File.open(filename).readlines.map(&:chomp)

def parse_tile(tile_data)
  tile_id = tile_data.shift.split(' ').last.delete_suffix(':').to_i

  left = []
  right = []
  tile_data.each do |line|
    left << line.chars.first
    right << line.chars.last
  end

  top = tile_data.first.chars
  bottom = tile_data.last.chars

  middle = tile_data[1...-1].map { |line| line[1...-1] }

  return tile_id, {
    id: tile_id,
    top: top,
    right: right,
    bottom: bottom,
    left: left,
    middle: middle,
  }
end

def flip_tile_vertical(tile)
  {
    id: tile[:id],
    top: tile[:bottom],
    right: tile[:right].reverse,
    bottom: tile[:top],
    left: tile[:left].reverse,
    middle: tile[:middle].reverse,
  }
end

def rotate_tile(tile)
  new_middle = []
  tile[:middle].length.times { new_middle << "" }

  tile[:middle].reverse.each do |line|
    line.chars.each_index do |char_index|
      new_middle[char_index] << line[char_index]
    end
  end

  {
    id: tile[:id],
    top: tile[:left].reverse,
    right: tile[:top],
    bottom: tile[:right].reverse,
    left: tile[:bottom],
    middle: new_middle,
  }
end

def generate_tile_combinations(combinations)
  base_tile = combinations.first
  combinations << base_tile

  flipped_tile = flip_tile_vertical(base_tile)
  combinations << flipped_tile

  3.times do
    base_tile = rotate_tile(base_tile)
    combinations << base_tile

    flipped_tile = rotate_tile(flipped_tile)
    combinations << flipped_tile
  end

  combinations.uniq!
end

def rotate_image(image)
  new_image = []
  image.length.times { new_image << "" }

  image.reverse.each do |line|
    line.chars.each_index do |char_index|
      new_image[char_index] << line[char_index]
    end
  end

  new_image
end

def get_image_combinations(image)
  combinations = [image]

  flipped_image = image.reverse
  combinations << flipped_image

  3.times do
    image = rotate_image(image)
    combinations << image

    flipped_image = rotate_image(flipped_image)
    combinations << flipped_image
  end

  combinations.uniq
end

def find_valid_pairs(tile, tiles, used_tile_ids)
  pairs = []

  tiles.each do |tile_id, combinations|
    next if tile_id == tile[:id] || used_tile_ids.include?(tile_id)

    combinations.each do |combination|
      if tile[:right] == combination[:left]
        pairs << [tile, combination]
      end
    end
  end

  pairs
end

def find_valid_rows(starting_tile, tiles, dimension)
  rows = find_valid_pairs(starting_tile, tiles, [])

  loop do
    new_rows = []

    rows.each do |row|
      if row.length == dimension
        new_rows << row
        next
      end

      used_tile_ids = row.map { |t| t[:id] }
      next_tiles = find_valid_pairs(row.last, tiles, used_tile_ids).map(&:last)

      next_tiles.each do |next_tile|
        new_rows << [*row, next_tile]
      end
    end

    rows = new_rows
    break if rows.empty? || rows.map(&:length).uniq == [dimension]
  end

  rows
end

def find_next_rows(starting_row, rows, used_tile_ids)
  next_rows = []

  rows.each do |row|
    next if row.any? do |tile|
      used_tile_ids.include?(tile[:id])
    end

    valid = true
    row.each_index do |i|
      if row[i][:top] != starting_row[i][:bottom]
        valid = false
        break
      end
    end

    next_rows << row if valid
  end

  next_rows
end

def find_final_layout(valid_rows, dimension)
  layouts = valid_rows.map { |row| [row] }

  loop do
    new_layouts = []

    layouts.each do |layout|
      used_tile_ids = layout.map { |row| row.map {|tile| tile[:id]} }.flatten
      next_rows = find_next_rows(layout.last, valid_rows, used_tile_ids)

      next_rows.each do |next_row|
        new_layouts << [*layout, next_row]
      end
    end

    layouts = new_layouts
    break if layouts.empty? || layouts.map(&:length).uniq == [dimension]
  end

  layouts.first
end

def count_sea_dragons(image)
  # Looking for (each O must be a #):
  # .#.#...#.###...#.##.O#..
  # #.O.##.OO#.#.OO.##.OOO##
  # ..#O.#O#.O##O..O.#O##.##

  dragons = 0

  image[1...-1].each_index do |line_index|
    current_index = 0
    while found = image[line_index].index(/#....##....##....###/, current_index) do
      if image[line_index - 1][found + 18] == '#'
        if image[line_index + 1][found + 1..].match(/^#..#..#..#..#..#/)
          dragons += 1
        end
      end

      current_index = found + 1
    end
  end

  dragons
end

# { id: [ combinations ] }
# each combination: { id: 1, top: [], right: [], bottom: [], left: [] }
tiles = {}

tile_data = []
lines = input.each
loop do
  begin
    line = lines.next
  rescue StopIteration
    break
  end

  if line == ''
    tile_id, base_combination = parse_tile(tile_data)
    tiles[tile_id] = [base_combination]
    tile_data = []
    next
  end

  tile_data << line
end

tile_id, base_combination = parse_tile(tile_data)
tiles[tile_id] = [base_combination]

tiles.each do |tile_id, combinations|
  generate_tile_combinations(combinations)
end

valid_rows = []
dimension = Math.sqrt(tiles.length).to_i

tiles.each do |tile_id, combinations|
  combinations.each do |tile|
    valid_rows += find_valid_rows(tile, tiles, dimension)
  end
end

valid_rows
# valid_rows.each do |row|
#   puts "#{row.map {|t| t[:id]}.join(', ')}"
# end
# puts "\n"

final_layout = find_final_layout(valid_rows, dimension)


solution = final_layout.first.first[:id] *
  final_layout.first.last[:id] *
  final_layout.last.first[:id] *
  final_layout.last.last[:id]
puts "Part 1 solution: #{solution}"

# Iterate final layout, combine middle pieces into single image
image = []

final_layout.each do |row|
  puts "#{row.map {|t| t[:id]}.join(', ')}"

  combined_rows = []
  row.first[:middle].length.times { combined_rows << "" }
  row.each do |tile|
    tile[:middle].each_index do |line_index|
      combined_rows[line_index] << tile[:middle][line_index]
    end
  end

  image += combined_rows
end


image_combinations = get_image_combinations(image)
image_combinations.each do |image_combination|
  sea_dragons = count_sea_dragons(image_combination)

  if sea_dragons > 0
    puts "Found #{sea_dragons} sea dragons!"
    pound_count = image_combination.sum { |line| line.count('#') }
    puts "Pound count: #{pound_count}"
    rough_waters_count = pound_count - (sea_dragons * 15)
    puts "Habitat water roughness: #{rough_waters_count}"
  end
end
