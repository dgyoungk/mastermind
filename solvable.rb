module Solvable

  def update_guess(game)
    guess_code = game.get_guess(game)
    answer_code = game.get_answer(game)
    guesses = get_codes
    base_feedback = get_feedback(guess_code, answer_code)

    filtered_guesses = guesses.select do |guess|
      get_feedback(guess.digits.reverse, guess_code) == base_feedback
    end

    best_guesses = get_best_guesses(filter_scores(get_feedback_scores(guesses, guesses.dup)), filtered_guesses)

    next_guess = convert_to_hash(best_guesses.first.digits.reverse)

    next_guess.each do |k, v|
      next_guess[k] = game.color_nums.key(v).to_s
    end

    game.breaker.guess = next_guess
  end

  def get_codes()
    guesses = (1..6).to_a.repeated_permutation(4).map(&:join).map(&:to_i)
    guesses
  end

  # getting the scores for each potential guess and setting the max score as the score for each guess
  def get_feedback_scores(guesses, codes)
    feedback_scores = guesses.each.with_object({}) do |guess, outer_hash|
      scores = codes.each.with_object(Hash.new(0)) do |code, inner_hash|
        code_arr = code.digits.reverse
        guess_arr = guess.digits.reverse
        inner_hash[get_feedback(code_arr, guess_arr)] += 1
      end
      outer_hash[guess] = scores.values.max
    end
    feedback_scores
  end

  # filtering out the smallest max scores
  def filter_scores(feedback_scores)
    min_scores = feedback_scores.each.with_object({}) do |(guess, score), hash|
      min_max_score = feedback_scores.values.min
      hash[guess] = score if score == min_max_score
    end
    min_scores
  end

  # selecting all the min max scores that are included in the filtered out pool
  def get_best_guesses(min_scores, candidates)
    min_score_guesses = min_scores.map { |pair| pair = pair.first }
    ideal_guesses = min_score_guesses.select { |combi, score| candidates.include?(combi) }
    return min_score_guesses if ideal_guesses.empty?
    ideal_guesses
  end

  def compare_guess(match)
    answer = get_answer(match)
    guess = get_guess(match)
    comparison = get_feedback(guess, answer)
    match.feedback = convert_to_hash(comparison)
  end

  def get_feedback(guess, answer)
    comparison = guess.reduce([]) do |arr, item|
      if answer.include?(item)
        if guess.index(item) == answer.index(item)
          arr.push('black')
        else
          arr.push('white')
        end
      else
        arr << 'none'
      end
      arr
    end
    comparison
  end
end
