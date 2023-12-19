class Codebreaker
  include Displayable

  attr_accessor :name, :guess

  def initialize(name = "Computer")
    self.name = name
    self.guess = {
      pos1: '',
      pos2: '',
      pos3: '',
      pos4: ''
    }
  end


  # for debugging
  def to_s
    %(#{self.name}, #{self.guess})
  end
end
