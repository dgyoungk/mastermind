module Solvable

  def update_guess(game)
    guess_code = game.get_guess(game)
    answer_code = game.get_answer(game)
    guesses = get_codes
    base_feedback = get_feedback(guess_code, answer_code)
    feedback_count = get_feedback_counts(base_feedback)

    if game.turns == 1
      game.candidates = guesses
      filtered_guesses = game.candidates.select do |guess|
        get_feedback_counts(get_feedback(guess_code, guess.digits.reverse)) == feedback_count
      end
      best_guess = get_next_guess(filter_scores(get_feedback_scores(guesses, guesses.dup)), filtered_guesses).digits.reverse
      filtered_guesses.delete_if { |guess| guess.digits.reverse == guess_code }

      next_guess = convert_to_hash(best_guess)
      next_guess.each do |k, v|
        next_guess[k] = game.color_nums.key(v).to_s
      end

      game.breaker.guess = next_guess
    else
      filtered_guesses = game.candidates.select do |guess|
        get_feedback_counts(get_feedback(guess_code, guess.digits.reverse)) == feedback_count
      end
      best_guess = get_next_guess(filter_scores(get_feedback_scores(guesses, guesses.dup)), filtered_guesses).digits.reverse
      filtered_guesses.delete_if { |guess| guess.digits.reverse == guess_code }

      next_guess = convert_to_hash(best_guess)
      next_guess.each do |k, v|
        next_guess[k] = game.color_nums.key(v).to_s
      end

      game.breaker.guess = next_guess
    end

    game.candidates = filtered_guesses
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
  def get_next_guess(min_scores, candidates)
    next_guess = min_scores.each { |guess, score| return guess if candidates.include?(guess) }
    min_scores.first.first
  end

  def compare_guess(match)
    answer = get_answer(match)
    guess = get_guess(match)
    comparison = get_feedback(guess, answer)
    match.feedback = convert_to_hash(comparison)
  end

  def get_feedback(guess, answer)
    comparison = guess.each_with_index.reduce([]) do |arr, (item, idx)|
      if answer.include?(item)
        if answer[idx] == guess[idx]
          arr.push('black')
        else
          arr.push('white')
        end
      else
        arr.push('none')
      end
      arr
    end
  end

  def get_feedback_counts(feedback)
    counts = feedback.each.with_object(Hash.new(0)) do |outcome, hash|
      hash[outcome] += 1
      unless feedback.include?('black')
        hash['black'] = 0
      end
      unless feedback.include?('white')
        hash['white'] = 0
      end
    end
    counts.reject! { |k, v| k == 'none' }
    counts.values
  end
end
