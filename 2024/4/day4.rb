wordsearch = File.open("input.txt").readlines.map(&:chomp).map(&:chars)

def has_word?(wordsearch, x1, y1, x2, y2, x3, y3)
  return false if [x1, y1, x2, y2, x3, y3].any? { |pos| pos < 0 }

  wordsearch.dig(x1, y1) == "M" &&
    wordsearch.dig(x2, y2) == "A" &&
    wordsearch.dig(x3, y3) == "S"
end

puts "Part 1:"

tally = wordsearch.each_with_index.sum do |row, i|
  row.each_with_index.sum do |letter, j|
    next 0 unless letter == "X"
    [
      # Horizontal
      has_word?(wordsearch, i, j + 1, i, j + 2, i, j + 3),
      has_word?(wordsearch, i, j - 1, i, j - 2, i, j - 3),
      # Vertical
      has_word?(wordsearch, i - 1, j, i - 2, j, i - 3, j),
      has_word?(wordsearch, i + 1, j, i + 2, j, i + 3, j),
      # Diagonal
      has_word?(wordsearch, i + 1, j + 1, i + 2, j + 2, i + 3, j + 3),
      has_word?(wordsearch, i + 1, j - 1, i + 2, j - 2, i + 3, j - 3),
      has_word?(wordsearch, i - 1, j + 1, i - 2, j + 2, i - 3, j + 3),
      has_word?(wordsearch, i - 1, j - 1, i - 2, j - 2, i - 3, j - 3),
    ].count(true)
  end
end

puts tally

puts "Part 2:"

tally = wordsearch.each_with_index.sum do |row, i|
  row.each_with_index.sum do |letter, j|
    next 0 unless letter == "A"
    combinations = [
      has_word?(wordsearch, i + 1, j - 1, i, j, i - 1, j + 1),
      has_word?(wordsearch, i - 1, j - 1, i, j, i + 1, j + 1),
      has_word?(wordsearch, i - 1, j + 1, i, j, i + 1, j - 1),
      has_word?(wordsearch, i + 1, j + 1, i, j, i - 1, j - 1),
    ]

    combinations.count(true) == 2 ? 1 : 0
  end
end

puts tally
