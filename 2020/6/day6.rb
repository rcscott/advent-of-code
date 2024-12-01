filename = "day6_input.txt"
customs_declaration_lines = File.open(filename).readlines.map(&:chomp)

customs_declaration_groups = [{people_count: 0, responses: ""}]
customs_declaration_lines.each do |line|
  if line == ""
    customs_declaration_groups << {people_count: 0, responses: ""}
  else
    group = customs_declaration_groups.pop
    group[:people_count] += 1
    group[:responses] += line
    customs_declaration_groups << group
  end
end


total_yes_count = customs_declaration_groups.sum(0) do |group_response|
  unique_yes_questions = group_response[:responses].chars.uniq
  response_counts = unique_yes_questions.map { |q| [q, group_response[:responses].chars.count(q)] }.to_h
  response_counts.filter { |q, count| count == group_response[:people_count] }.length
end
puts total_yes_count
