require './displayable.rb'
require './playable.rb'
require './mastermind.rb'
require './codebreaker.rb'

class Game
  include Playable
  include Displayable

  attr_accessor :turns, :breaker, :creator, :feedback
  def initialize
    self.turns = 1
    self.feedback = {}
    setup_game()
  end

  def setup_game
    welcome_msg()
    new_player_msg()
    player_name = gets.chomp
    choice_msg()
    role_selection = gets.chomp.to_i
    designate_player(role_selection, player_name)
    # Playable method
    start_game(self)
  end

  def start_match
    options_msg(self.creator.color_options)
    self.breaker.guess.each_with_index do |(k, v), idx|
      print %(Color at position #{idx + 1}: )
      guess_color = gets.chomp.downcase
      until self.creator.color_options.include?(guess_color)
        puts %(That color is not an option, try again)
        print %(Position #{idx + 1} color: )
        guess_color = gets.chomp.downcase
      end
      self.breaker.guess[k] = guess_color
    end
  end

  def over?()
    self.feedback.values.all? { |v| v == 'black' }
  end

  def prompt_replay
    replay_msg()
    choice = gets.chomp.downcase
    until choice == 'y' || choice == 'n'
      puts %(That's not an option, try again)
      replay_msg()
      choice = gets.chomp.downcase
    end
    if choice == 'y'
      reset_game()
      setup_game()
    else
      goodbye_msg()
    end
  end

  # things to reset: player roles, feedback, guess, master code, turns
  def reset_game
    self.turns = 1
    self.feedback = {}
    # resetting the values
    self.creator.secret_code.map { |k, v| self.creator.secret_code[k] = '' }
    self.breaker.guess.map { |k, v| self.breaker.guess[k] = '' }
    # reset names
    self.creator.name = ''
    self.breaker.name = ''
  end

  private

  def designate_player(role, player_name)
    # 1 indicates that the player wants to be the codebreaker
    if role == 1
      self.breaker = Codebreaker.new(player_name)
      self.creator = Mastermind.new
    else
      self.breaker = Codebreaker.new
      self.creator = Mastermind.new(player_name)
    end
  end
end
