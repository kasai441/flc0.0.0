class Quizcard < ApplicationRecord
  belongs_to :user
  has_many :waitdays, dependent: :destroy
  default_scope -> { order(appearing_at: :desc) }
end
