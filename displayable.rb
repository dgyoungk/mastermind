module Displayable

  def welcome_msg
    puts %(Welcome, brave challenger. Push your wits to the limit with Mastermind!)
  end

  def new_player_msg
    puts %(\nWhat is your name, challenger?)
  end

  # offering a choice to either be the codebreaker or the mastermind
  def choice_msg
    puts %(\nThere are 2 roles, which is your choice?)
    puts %(1-Codebreaker, 2-Mastermind (Code creation))
  end

  # when the player decides to be the mastermind
  def create_code_msg(colors)
    puts %(\nMastermind, enter 4 colors of your choice:)
    options_msg(colors)
  end

  def options_msg(colors)
    print %(Color options: #{colors.join(', ')}\n)
  end

  # when player is the codebreaker
  def player_rules_msg
    puts %(\nYou will have 12 tries to guess the Mastermind's color combination)
    puts %(With each try, you will receive a feedback on the color and its place:)
    feedback_label = %(|Black: right color, right place | White: right color, wrong place | None: wrong color).upcase
    puts feedback_label
    puts %(Use the feedback to help you solve the code, good luck!)
  end

  # when player is the Mastermind
  def computer_rules_msg
  end

  def turns_msg(turn)
    puts %(\nTurn #{turn})
  end

  # to display when the player is codebreaker and is inputting their color combo

  # displays result of the comparison between guess and master code
  def results_msg(feedback)

  end

  def goodbye_msg
  end
end
