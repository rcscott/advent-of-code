reports = File.open("input.txt").readlines.map(&:chomp).map(&:split).map do |report|
  report.map(&:to_i)
end

# Part 1
def is_report_safe?(report)
  report.each_with_index.all? do |level, index|
    next_level = report.dig(index + 1)
    next true if next_level.nil?

    diff = next_level - level
    diff >= 1 && diff <= 3
  end
end

tally = reports.count do |report|
  is_report_safe?(report) || is_report_safe?(report.reverse)
end

puts tally

# Part 2
def is_report_safe_with_bad_level?(report)
  return true if is_report_safe?(report) || is_report_safe?(report.reverse)

  report.count.times.any? do |index|
    report_with_skip = report.clone
    report_with_skip.delete_at(index)
    is_report_safe?(report_with_skip) || is_report_safe?(report_with_skip.reverse)
  end
end

tally = reports.count do |report|
  is_report_safe_with_bad_level?(report)
end

puts tally
