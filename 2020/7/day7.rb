filename = "day7_input.txt"
bag_rules = File.open(filename).readlines.map(&:chomp)

# {"shiny gold": {"dark red": 2, "bright white": 1}}
bag_rules = bag_rules.map do |rule|
  outer_bag = rule.match(/^([a-z ]+) bags contain/)[1]
  inner_bags = rule.scan(/(\d+) ([a-z ]+) bag/).map(&:reverse).to_h
  [outer_bag, inner_bags]
end.to_h

# Part 1: How many bag colors can eventually contain at least one shiny gold bag?
def find_outer_bags(bag_rules, inner_bag)
  outer_bags = bag_rules.filter do |outer_bag, inner_bags|
    inner_bags.keys.include?(inner_bag)
  end

  return outer_bags.keys + outer_bags.keys.map { |bag| find_outer_bags(bag_rules, bag) }.flatten
end

puts find_outer_bags(bag_rules, "shiny gold").uniq.length

# Part 2: How many individual bags are required inside your single shiny gold bag?
def get_bag_count(bag_rules, bag)
  return bag_rules[bag].map do |bag_color, bag_count|
    bag_count.to_i + bag_count.to_i * get_bag_count(bag_rules, bag_color)
  end.sum(0)
end

puts get_bag_count(bag_rules, "shiny gold")
