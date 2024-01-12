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
    until game.turns > 12
      game.turns_msg(game.turns)
      start_match()
      compare_guess(game)
      unless game.over?
        game.turn_result_msg(game)
        game.turns += 1
      else
        break
      end
    end
    game.match_won_msg
    game.prompt_replay()
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

  def setup_comp_game(game)
    # put display message detailing what will happen if the computer is the guesser
    # add a method in the Displayable module
    # remove the comment when the method is written: (computer_rules_msg())
    game.computer_rules_msg()
    # start_comp_game method will play out the game until the code is broken or 12 turns is reached
    start_comp_game(game)
  end

  def start_comp_game(match)
    # converting the color names to their numerical counterparts
   answer_arr = match.creator.secret_code.values.map { |v| v = match.color_nums[v.to_sym] }
   guess_arr = match.breaker.guess.values.map { |v| v = match.color_nums[v.to_sym] }
   until match.turns > 12 || match.feedback.values == %w(black black black black)
     match.turns += 1
     match.computing_msg()
     sleep(2)

     feedback_arr = comp_compare(answer_arr, guess_arr)
     match.feedback = convert_to_hash(feedback_arr)
     match.turn_result_msg(match)
     update_guess(match, guess_arr)
   end
   if match.feedback.values == %w(black black black black)
     match.match_lost_msg(match)
   else
     match.match_won_msg
   end
   match.prompt_replay
  end

  def comp_compare(answer, guess)
    comparison = []

    guess.each_with_index do |value, index|
      if answer.include?(value)
        if guess[index] == answer[index]
          comparison.push('black')
        else
          comparison.push('white')
        end
      else
        comparison.push('none')
      end
    end
    comparison
  end

  def update_guess(game, guess)
    compare_results = game.feedback.values
    compare_results.each_with_index do |value, idx|
      if value == 'white' || value == 'none'
        new_color = game.color_options.sample.to_sym
        until guess[idx] != game.color_nums[new_color]
          new_color = game.color_options.sample.to_sym
        end
        guess[idx] = game.color_nums[new_color]
      else
        guess[idx] = guess[idx]
      end
    end
  end

  def convert_to_hash(array)
    arr_2d = array.map.with_index { |v, idx| v = ["pos#{idx + 1}".to_sym, v]}
    return arr_2d.to_h
  end

end
