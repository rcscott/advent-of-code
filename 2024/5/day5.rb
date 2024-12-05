input = File.open("input.txt").readlines.map(&:chomp)

divider = input.find_index(&:empty?)
rules = input[0...divider].map { |rule| rule.split("|").map(&:to_i) }.to_set
page_updates = input[divider + 1..].map { |rule| rule.split(",").map(&:to_i) }

# If pages are ordered (p1|p2) and rules specify (p2|p1) then order is invalid
def is_valid_pair?(page1, page2, rules)
  true unless rules.include?([page2, page1])
end

def is_valid_page_update?(page_update, rules)
  valid_page_update = page_update.each_with_index.all? do |page, index|
    page_update[index + 1..].all? do |future_page|
      is_valid_pair?(page, future_page, rules)
    end
  end
end

puts "Day 1:"
tally = page_updates.sum do |page_update|
  if is_valid_page_update?(page_update, rules)
    page_update[page_update.count / 2]
  else
    0
  end
end

puts tally

puts "Day 2:"
tally = page_updates.sum do |page_update|
  # Ignore updates that are already valid
  next 0 if is_valid_page_update?(page_update, rules)

  valid = false
  while valid == false
    new_page_update = []
    page_update.each_with_index do |page, index|
      page_update[index + 1..].each do |future_page|
        # If invalid, move future page earlier than current page
        new_page_update << future_page if !is_valid_pair?(page, future_page, rules)
      end

      # Add current page to end (after any future pages that were moved)
      new_page_update << page
    end

    # Drop dups from new update array (in case a future page was moved multiple times)
    page_update = new_page_update.uniq
    # Loop again if we don't yet have a fully valid update
    valid = true if is_valid_page_update?(page_update, rules)
  end

  page_update[page_update.count / 2]
end

puts tally
