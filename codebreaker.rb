require_relative 'color.rb'

class Codebreaker
  include Displayable
  include Color

  attr_accessor :name, :guess, :color_options

  def initialize(name = "Computer")
    self.name = name
    self.color_options = init_colors()
    if name == "Computer"
      self.guess = {
      pos1: 'green',
      pos2: 'green',
      pos3: 'blue',
      pos4: 'blue'
      }
    else
      self.guess = {
      pos1: '',
      pos2: '',
      pos3: '',
      pos4: ''
      }
    end
  end
end
