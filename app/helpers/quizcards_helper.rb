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
    beta = quizcard.calc_beta
    quizcard.real_wait_day
    wait_day = quizcard.calc_waitday(result)
    # beta = quizcard.revise_beta(result)
    # waitdays更新　wait_sequence++. wait_day
    quizcard.next_sequence(wait_day)
    # quizcard更新 appearing_at, beta
    quizcard.update_record
  end

  def assort_today_cards(quizcard, result)

  end
end
