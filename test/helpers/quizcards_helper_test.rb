require 'test_helper'

class QuizcardsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    @quizcard = @user.quizcards.first
  end

  test "answer time rightly calculated" do
    assert_equal 3, answer_time(@quizcard, 3.seconds.ago)
  end

  test "get model sequences" do
    assert_equal '{1=>10, 0=>3}' ,model_sequences(@quizcard).to_s
  end

  test "get lenear function" do
    model_sequences(@quizcard)
    assert_equal 7 ,@quizcard.gradients
    assert_equal 3 ,@quizcard.intercepts
  end
end
