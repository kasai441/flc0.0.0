require 'test_helper'

class QuizcardsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    @quizcard = @user.quizcards.first
  end

  test "answer time rightly calculated" do
    assert_equal 3, answer_time(@quizcard, 3.seconds.ago)
  end
end
