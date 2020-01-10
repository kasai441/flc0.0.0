class Waitday < ApplicationRecord
  belongs_to :quizcard
  default_scope -> { order(wait_sequence: :desc) }
  validates :wait_sequence, uniqueness: { scope: :quizcard_id, case_sensitive: false }

  def update_real_wait_day(real_wait_day)
    update_attribute(:wait_day, real_wait_day)
  end
end
