def increment_day(fish)
  new_fish = {}
  # new fish created
  new_fish[8] = fish[0]

  # existing fish at 0 day go back to new cycle
  new_fish[6] = fish[0]
  # fish created two cycles ago join the normal cycle
  new_fish[6] += fish[7]

  # fish created last cycle decreased by one day
  new_fish[7] = fish[8]

  # all other fish decrease by one day
  (0..5).each do |timer|
    new_fish[timer] = fish[timer + 1]
  end

  new_fish
end

fish_timers = File.open('input.txt').readlines.map(&:chomp).first.split(',').map(&:to_i)

fish = Hash.new(0)
fish_timers.each do |fish_timer|
  fish[fish_timer.to_i] += 1
end

256.times do
  fish = increment_day(fish)
end

puts fish.values.inject(:+)
