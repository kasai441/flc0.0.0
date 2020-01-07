class Waitday < ApplicationRecord
  belongs_to :quizcard
  default_scope -> { order(wait_sequence: :desc) }

  def calc_real_wait_day
  end

  def calc_waitdays(result)
    
  end

  def begin_new_sequence

  end
end
