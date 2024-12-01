require 'set'

filename = "day22_input.txt"
input = File.open(filename).readlines.map(&:chomp)

player1_cards = []
player2_cards = []

lines = input.each
loop do
  line = lines.next
  next if line.start_with?('Player')
  break if line.empty?

  player1_cards << line.to_i
end

loop do
  begin
    line = lines.next
  rescue StopIteration
    break
  end

  next if line.start_with?('Player')

  player2_cards << line.to_i
end

def play_game(player1_cards, player2_cards, game_num)
  # puts "\n=== Game #{game_num} ==="

  round_num = 0
  game_winner = nil
  previous_rounds = Set.new

  # loop rounds, check for empty decks or repeated flag
  while !player1_cards.empty? && !player2_cards.empty?
    round_num += 1

    round_hash = player1_cards.join(',') + '|' + player2_cards.join(',')

    if previous_rounds.include?(round_hash)
      game_winner = 1
      break
    end

    previous_rounds << round_hash

    # puts "\n-- Round #{round_num} (Game #{game_num}) --"
    # puts "Player 1's deck: #{player1_cards.join(', ')}"
    # puts "Player 2's deck: #{player2_cards.join(', ')}"

    card1 = player1_cards.shift
    # puts "Player 1 plays: #{card1}"

    card2 = player2_cards.shift
    # puts "Player 2 plays: #{card2}"

    if player1_cards.length >= card1 && player2_cards.length >= card2
      # puts 'Playing a sub-game to determine the winner...'
      winner, _, _ = play_game(player1_cards[0...card1], player2_cards[0...card2], game_num + 1)

      # puts "\n...anyway, back to game #{game_num}."
    elsif card1 > card2
      winner = 1
    else
      winner = 2
    end

    # puts "Player #{winner} wins round #{round_num} of game #{game_num}!"
    if winner == 1
      player1_cards += [card1, card2]
    else
      player2_cards += [card2, card1]
    end
  end

  if game_winner.nil?
    game_winner = player1_cards.empty? ? 2 : 1
  end

  return game_winner, player1_cards, player2_cards
end

winner, player1_cards, player2_cards = play_game(player1_cards, player2_cards, 1)

puts "\n== Post-game results =="
puts "Player 1's deck: #{player1_cards.join(', ')}"
puts "Player 2's deck: #{player2_cards.join(', ')}"

winning_deck = player1_cards.empty? ? player2_cards : player1_cards

winning_score = 0
winning_deck.reverse!.each_index do |i|
  winning_score += winning_deck[i] * (i + 1)
end

puts "Winner's score: #{winning_score}"
