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
    # attribute = result ? "right" : "wrong"
    # if ids = cookies[send(":quizcards_#{attribute}_ids")]
    #   instance_variable_set("@quizcards_#{attribute}", JSON.parse(ids))
    # else
    #   instance_variable_set("@quizcards_#{attribute}", [])
    # end

    # instance_variable_get("@quizcards_#{attribute}") << quizcard.id
    # cookies[send(":quizcards_#{attribute}_ids")] = JSON.generate(instance_variable_get("@quizcards_#{attribute}"))

    if result
      if (ids = cookies[:quizcards_right_ids])
        @quizcards_right = JSON.parse(ids)
      else
        @quizcards_right = []
      end
  
      @quizcards_right << quizcard.id
      cookies[:quizcards_right_ids] = { value: JSON.generate(@quizcards_right), expires: Time.zone.today + 1}
    else
      if (ids = cookies[:quizcards_wrong_ids])
        @quizcards_wrong = JSON.parse(ids)
      else
        @quizcards_wrong = []
      end
  
      @quizcards_wrong << quizcard.id
      cookies[:quizcards_wrong_ids] =  { value: JSON.generate(@quizcards_wrong), expires: Time.zone.today + 1}
  
    end  
    # cookieの期限を今日中にする
  end
  
  def get_cards_by_id(ids)
    ids = JSON.parse(ids)
    Quizcard.where(id: ids)
  end
end
