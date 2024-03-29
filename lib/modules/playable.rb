require_relative 'displayable.rb'

module Playable

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

  # when player is the codebreaker
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

  def setup_comp_game(game)
    game.computer_rules_msg()
    # start_comp_game method will play out the game until the code is broken or 12 turns is reached
    start_comp_game(game)
  end

  def start_comp_game(match)
     # converting the color names to their numerical counterparts
    until match.turns == 12 || match.feedback.values == %w(black black black black)
      match.turns += 1
      match.computing_msg()
      match.compare_guess(match)
      match.turn_result_msg(match)
      match.update_guess(match)
    end
    if match.feedback.values == %w(black black black black)
      match.match_lost_msg(match)
    else
      match.match_won_msg
    end
    match.prompt_replay
  end

  def convert_to_hash(array)
    arr_2d = array.map.with_index { |v, idx| v = ["pos#{idx + 1}".to_sym, v]}
    return arr_2d.to_h
  end

  def get_guess(match)
    return match.breaker.guess.values.map { |v| v = match.color_nums[v.to_sym] }
  end

  def get_answer(match)
    return match.creator.secret_code.values.map { |v| v = match.color_nums[v.to_sym] }
  end
end
