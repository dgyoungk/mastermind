require_relative 'color.rb'
require_relative 'mastermind.rb'
require_relative 'codebreaker.rb'
require_relative 'modules/displayable.rb'
require_relative 'modules/playable.rb'
require_relative 'modules/solvable.rb'

class Game
  include Playable
  include Displayable
  include Color
  include Solvable

  attr_accessor :turns, :breaker, :creator, :feedback, :color_nums, :color_options, :candidates
  def initialize
    self.turns = 0
    self.feedback = {}
    self.color_nums = init_color_nums()
    self.color_options = init_colors()
    self.candidates = []
    setup_game()
  end

  def setup_game
    welcome_msg()
    new_player_msg()
    player_name = gets.chomp
    choice_msg()
    role_selection = gets.chomp.to_i
    until role_selection == 1 || role_selection == 2
      puts %(Please choose either 1 or 2)
      choice_msg()
      role_selection = gets.chomp.to_i
    end
    designate_player(role_selection, player_name)

    if self.breaker.name == player_name
      # Playable method
      start_game(self)
    else
      # Playable method
      setup_comp_game(self)
    end
  end

  def start_match
    options_msg(self.creator.color_options)

    self.breaker.guess.each_with_index do |(k, v), idx|
      print %(Position #{idx + 1} color: )
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
      puts %(\nThat's not an option, try again)
      replay_msg()
      choice = gets.chomp.downcase
    end
    if choice == 'y'
      reset_game()
      replay = Game.new
    else
      goodbye_msg()
    end
  end

  def reset_game
    self.turns = 0
    self.feedback = {}
    # resetting the values
    self.creator.secret_code.map { |k, v| self.creator.secret_code[k] = '' }
    self.breaker.guess.map { |k, v| self.breaker.guess[k] = '' }
    # reset names
    self.creator.name = ''
    self.breaker.name = ''
    self.candidates = []
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
