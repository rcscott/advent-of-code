
puts "Part 1 (slow):"
stones = File.open("input.txt").read.chomp.split.map(&:to_i)
def blink(stones)
  new_stones = []
  stones.each_with_index do |stone, index|
    if stone == 0
      new_stones << 1
    elsif stone.to_s.size % 2 == 0
      new_stones += stone.to_s.chars.each_slice(stone.to_s.length / 2).map(&:join).map(&:to_i)
    else
      new_stones << stone * 2024
    end
  end

  new_stones
end

25.times do |i|
  stones = blink(stones)
end
puts stones.size

puts "Part 2 (fast!):"
stones = File.open("input.txt").read.chomp.split.map(&:to_i)
@stone_results = Hash.new { |h, k| h[k] = {} }

def blink2(stone, blinks_remaining)
  existing_result = @stone_results.dig(stone, blinks_remaining)
  return existing_result if existing_result

  if stone == 0
    new_stones = [1]
  elsif stone.to_s.size % 2 == 0
    new_stones = stone.to_s.chars.each_slice(stone.to_s.length / 2).map(&:join).map(&:to_i)
  else
    new_stones = [stone * 2024]
  end

  return new_stones.size if blinks_remaining <= 1

  return new_stones.sum do |stone|
    @stone_results[stone][blinks_remaining - 1] = blink2(stone, blinks_remaining - 1)
  end
end

tally = stones.sum do |stone|
  blink2(stone, 75)
end
puts tally
