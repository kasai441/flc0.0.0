# frozen_string_literal: true

module QuizcardsHelper
  def answer_time(quizcard, begin_answer)
    time = (Time.zone.now.to_time - begin_answer.to_time).to_i
    quizcard.update_answer_time(time)
  end

  def model_sequences(quizcard)
    seq = quizcard.get_model_sequences
    quizcard.get_linear_function(seq)
  end

  def next_waitday(quizcard, result)
    quizcard.calc_beta
    quizcard.real_wait_day
    wait_day = quizcard.calc_waitday(result)
    quizcard.next_sequence(wait_day)
    quizcard.update_appearing(wait_day)
  end

  def assort_today_cards(quizcard, result)
    if result
      @quizcards_right = if (ids = cookies[:quizcards_right_ids])
                           JSON.parse(ids)
                         else
                           []
                         end
      @quizcards_right << quizcard.id
      cookies[:quizcards_right_ids] = { value: JSON.generate(@quizcards_right), expires: Time.zone.today + 1 }
    else
      @quizcards_wrong = if (ids = cookies[:quizcards_wrong_ids])
                           JSON.parse(ids)
                         else
                           []
                         end
      @quizcards_wrong << quizcard.id
      cookies[:quizcards_wrong_ids] = { value: JSON.generate(@quizcards_wrong), expires: Time.zone.today + 1 }
    end
  end

  def set_total_time(_user_id, answer_time)
    User.find(@quizcard.user_id).set_total_time(answer_time)
  end

  def get_cards_by_id(ids)
    ids = JSON.parse(ids)
    Quizcard.where(id: ids)
  end

  def today_range
    Time.zone.today.beginning_of_day..Time.zone.today.end_of_day
  end

  def hint(str)
    hide = "_#{str.size}_"
    str[1..-1] = hide
    str
  end
end
