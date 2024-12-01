filename = "day21_input.txt"
input = File.open(filename).readlines.map(&:chomp)

allergens = {}
ingredients = Hash.new(0)

input.each do |line|
  m = line.match(/(?<ingredient_list>[\w ]+) \(contains (?<allergen_list>.+)\)/)

  ingredient_list = m[:ingredient_list].split(' ')
  allergen_list = m[:allergen_list].split(', ')

  ingredient_list.each do |i|
    ingredients[i] += 1
  end

  allergen_list.each do |a|
    if !allergens.has_key?(a) || allergens[a].empty?
      allergens[a] = ingredient_list
    else
      allergens[a] = allergens[a] & ingredient_list
    end
  end
end

ingredients_with_possible_allergens = allergens.values.inject(&:|)
ingredients_without_allergens = ingredients.keys - ingredients_with_possible_allergens
ingredients_without_allergens_count = ingredients_without_allergens.sum { |i| ingredients[i] }

puts "Occurrence of ingredients without allergens: #{ingredients_without_allergens_count}"

final_allergen_mapping = {}

while allergens.length > 0 do
  allergens.select { |_, ingredient_list| ingredient_list.length == 1 }.each do |a, ingredient_list|
    final_allergen_mapping[a] = ingredient_list.first
    allergens.delete(a)

    allergens.each do |a2, i2|
      allergens[a2] = i2 - ingredient_list
    end
  end
end

puts final_allergen_mapping
puts "Sorted by allergen: #{final_allergen_mapping.sort.map(&:last).join(',')}"
