require_relative 'displayable.rb'


module Playable

  def compare_guess(match)
    guess = match.breaker.guess
    secret = match.creator.secret_code
    result = guess.reduce(Hash.new()) do |feedback, (k, v)|
      if secret.has_value?(guess[k]) == false
        feedback[k] = 'none'
      elsif guess[k] != secret[k] && secret.has_value?(guess[k])
        feedback[k] = 'white'
      elsif guess[k] == secret[k]
        feedback[k] = 'black'
      end
      feedback
    end
    match.feedback = result
  end

  def start_game(game)
    game.player_rules_msg()
    # change the condition into 12 after testing is done
    until game.turns == 12
      game.turns_msg(game.turns)
      start_match()
      compare_guess(game)
      match.turn_result_msg(match)
      # after the guess is put in and the guess is compared, increment turns
      game.turns += 1
    end
  end

  def start_match(match)
    options_msg(match.creator.color_options)
    match.breaker.guess.each_with_index do |(k, v), idx|
      print %(Color at position #{idx + 1}: )
      guess_color = gets.chomp.downcase
      until match.creator.color_options.include?(guess_color)
        puts %(That color is not an option, try again)
        print %(Color at position #{idx + 1}: )
        guess_color = gets.chomp.downcase
      end
      match.breaker.guess[k] = guess_color
    end
  end

end
