class Waitday < ApplicationRecord
  belongs_to :quizcard
  default_scope -> { order(wait_sequence: :desc) }

  def calc_real_wait_day
  end
end
