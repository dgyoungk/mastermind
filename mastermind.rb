class Mastermind
  include Displayable

  attr_accessor :name, :color_options, :secret_code

  # constructor to be used when the player wants to be the mastermind
  def initialize
  end

  # constructor to be used when the computer is the mastermind
  def initialize(name = "Computer")
    self.name = name
    self.secret_code = {
      pos1: '',
      pos2: '',
      pos3: '',
      pos4: ''
    }
    init_colors()
    if name == 'Computer'
      compute_secret()
    else
      generate_secret()
    end

  end

  def init_colors
    self.color_options = %w(green blue red purple)
  end

  def compute_secret
    colors_shuffled = color_options.shuffle
    secret_code.each_with_index do |(k, v), idx|
      secret_code[k] = colors_shuffled[idx]
    end
  end

  # method to get the colors from the players to generate the code
  def generate_secret
    create_code_msg(self.color_options)
    self.secret_code.each do |k, v|
      print %(Color: )
      color_choice = gets.chomp.downcase
      until self.color_options.include?(color_choice)
        puts %(That color is not one of the options. Try again)
        print %(Color: )
        color_choice = gets.chomp.downcase
      end
      self.secret_code[k] = color_choice
    end
  end

  # for debugging
  def to_s
    %(#{self.name}, #{self.secret_code})
  end
end
