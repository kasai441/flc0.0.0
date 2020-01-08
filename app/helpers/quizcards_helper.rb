module QuizcardsHelper
  def answer_time(quizcard, begin_answer)
    time = (Time.zone.now.to_time - begin_answer.to_time).to_i
    quizcard.update_answer_time(time)
  end

  def model_sequences(quizcard)
    seq = quizcard.get_model_sequences
    quizcard.get_linear_function(seq)
  end

  def real_wait_day(quizcard)
    # record_waitdays 現在時刻　ー　last_appeard_at
    max = quizcard.waitdays.maximum(:wait_sequence)
    waitday = quizcard.waitdays.find_by(wait_sequence: max)
    waitday.calc_real_wait_day
  end

  def next_waitday(quizcard, result)
    # calc_waidays beta * model_wait(wait_sequence)

    quizcard.calc_waitday(result)
    quizcard.revise_beta(result)

    # waitdays更新　wait_sequence++. wait_day
    quizcard.next_sequence
    # quizcard更新　answer_time, appearing_at, beta
    quizcard.update_record
  end
end
