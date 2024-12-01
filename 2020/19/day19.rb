filename = "day19_input.txt"
input = File.open(filename).readlines.map(&:chomp)

lines = input.each

rules = {}
loop do
  line = lines.next
  break if line.empty?
  m = line.match(/(?<rule_num>\d+): (?<rule>.+)/)
  rules[m[:rule_num]] = m[:rule]
end

messages = []
loop do
  begin
    line = lines.next
  rescue StopIteration
    break
  end

  messages << line
end

def get_valid_message_patterns(rules, solved_rules, rule_num)
  # puts "#{rule_num}"
  if rules.has_key?(rule_num) && rules[rule_num].start_with?('"')
    return [rules[rule_num][1...-1]]
  end

  if solved_rules.has_key?(rule_num)
    # puts "returning #{rule_num}: #{solved_rules[rule_num]}"
    return solved_rules[rule_num]
  end

  rule_pattern = rules[rule_num] || rule_num

  if rule_pattern.index('|')
    solution = rule_pattern.split(' | ').map do |sub_rule_pattern|
      # puts "#{sub_rule_pattern}"
      get_valid_message_patterns(rules, solved_rules, sub_rule_pattern)
    end.flatten.uniq

    solved_rules[rule_pattern] = solution
    return solution
  end

  patterns = []
  rule_pattern.split(' ').each do |rule_num|
    # puts "patterns: #{patterns}, rule_num: #{rule_num}"
    if patterns.empty?
      patterns = get_valid_message_patterns(rules, solved_rules, rule_num).flatten
      next
    end

    patterns.map! do |pattern|
      get_valid_message_patterns(rules, solved_rules, rule_num).map do |rule_pattern|
        # puts "rule_pattern: #{rule_pattern}, rule_num: #{rule_num}, pattern: #{pattern}"
        pattern + rule_pattern
      end
    end.flatten!.uniq!
  end

  solved_rules[rule_pattern] = patterns
  patterns
end

# solved_rules = {}
# valid_message_patterns = get_valid_message_patterns(rules, solved_rules, "0")

# valid_messages = messages.count { |m| valid_message_patterns.include?(m) }

# puts "Valid messages: #{valid_messages}"

solved_42_rules = {}
valid_42_patterns = get_valid_message_patterns(rules, solved_42_rules, "42")

solved_31_rules = {}
valid_31_patterns = get_valid_message_patterns(rules, solved_31_rules, "31")


def remove_prefixes(message, patterns)
  removed = 0

  loop do
    match_found = false
    patterns.each do |pattern|
      if message.start_with?(pattern)
        match_found = true
        removed += 1
        message.delete_prefix!(pattern)
      end
    end

    break unless match_found
  end

  return removed, message
end

# 8: 42 | 42 8
# 11: 42 31 | 42 11 31
# 0: 8 11

# Count of 31 patterns + 1 <= count of 42 patterns
valid_messages = 0

messages.each do |message|
  removed_42s, message = remove_prefixes(message, valid_42_patterns)

  next if removed_42s < 2 || message.empty?

  removed_31s, message = remove_prefixes(message, valid_31_patterns)

  if removed_42s >= removed_31s + 1 && message.empty?
    valid_messages += 1
  end
end

puts valid_messages
