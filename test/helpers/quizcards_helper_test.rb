require 'test_helper'

class QuizcardsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    @quizcard = @user.quizcards.first
    @user2 = users(:malory)
    @quizcard2 = @user2.quizcards.first
    @quizcard3 = quizcards(:q_five)
  end

  test "answer time rightly calculated" do
    assert_equal 3, answer_time(@quizcard, 3.seconds.ago)
  end

  test "get model sequences" do
    assert_equal '{1=>100, 0=>35}' ,model_sequences(@quizcard)[0].to_s
    assert_equal '{9=>90, 8=>80, 7=>70, 6=>60, 5=>50, 4=>40, 3=>30, 2=>20, 1=>10, 0=>0}' ,model_sequences(@quizcard2)[0].to_s
  end

  test "get linear function" do
    model_sequences(@quizcard)
    assert_equal 65, @quizcard.gradients
    assert_equal 35, @quizcard.intercepts

    p = model_sequences(@quizcard2)
    assert_equal '{9=>90, 8=>80, 7=>70, 6=>60, 5=>50, 4=>40, 3=>30, 2=>20}', p[1].to_s
    assert_equal [[9, 90], [8, 80], [7, 70], [6, 60]], p[2]
    assert_equal [[5, 50], [4, 40], [3, 30], [2, 20]], p[3]
    assert_equal 35, p[4]
    assert_equal 75, p[5]
    assert_equal 4, p[6]
    assert_equal 8, p[7]
    assert_equal 10, @quizcard2.gradients
    assert_equal -5, @quizcard2.intercepts
  end

  test 'calc waitday when right answer' do
    model_sequences(@quizcard)
    assert_equal 165, @quizcard.calc_waitday(true)
    model_sequences(@quizcard2)
    assert_equal 100, @quizcard2.calc_waitday(true)
  end

  test 'calc waitday when wrong answer' do
    model_sequences(@quizcard)
    assert_equal 35, @quizcard.calc_waitday(false)
    model_sequences(@quizcard2)
    assert_equal 80, @quizcard2.calc_waitday(false)
  end

  test 'revise beta' do
    assert_equal 1.0, @quizcard.revise_beta(true)
  end

  test 'real wait day' do
    model_sequences(@quizcard3)
    assert_equal 183, @quizcard3.real_wait_day
  end

  test 'next_sequence' do
    assert_difference 'Waitday.count', 1 do
      model_sequences(@quizcard)
      wait_day = @quizcard.calc_waitday(true)
      @quizcard.next_sequence(wait_day)
    end
  end
end
