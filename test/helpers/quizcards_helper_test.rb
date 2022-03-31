# frozen_string_literal: true

require 'test_helper'

class QuizcardsHelperTest < ActionView::TestCase
  def setup
    @user = users(:michael)
    @quizcard = @user.quizcards.first
    @user2 = users(:malory)
    @quizcard2 = @user2.quizcards.first
    @quizcard3 = quizcards(:q_five)
  end

  test 'answer time rightly calculated' do
    assert_equal 3, answer_time(@quizcard, 3.seconds.ago)
  end

  test 'get model sequences' do
    assert_equal '{1=>100, 0=>35}', model_sequences(@quizcard)[0].to_s
    assert_equal '{9=>45, 8=>40, 7=>35, 6=>30, 5=>25, 4=>20, 3=>15, 2=>10, 1=>5, 0=>0}',
                 model_sequences(@quizcard2)[0].to_s
  end

  test 'get linear function' do
    model_sequences(@quizcard)
    assert_equal 65, @quizcard.gradients

    p = model_sequences(@quizcard2)
    assert_equal '{9=>45, 8=>40, 7=>35, 6=>30, 5=>25, 4=>20, 3=>15}', p[1].to_s
    assert_equal [[9, 45], [8, 40], [7, 35]], p[2]
    assert_equal [[6, 30], [5, 25], [4, 20], [3, 15]], p[3]
    assert_equal 22, p[4]
    assert_equal 40, p[5]
    assert_equal 4, p[6]
    assert_equal 8, p[7]
    assert_equal 4, @quizcard2.gradients
  end

  test 'calc beta' do
    assert_equal 1.10, @quizcard.calc_beta
    assert_equal 1.90, @quizcard2.calc_beta
  end

  test 'real wait day' do
    model_sequences(@quizcard3)
    assert_equal 183, @quizcard3.real_wait_day
  end

  test 'calc waitday when right answer' do
    model_sequences(@quizcard)
    @quizcard.calc_beta
    assert_equal 1, @quizcard.calc_waitday(true)
    model_sequences(@quizcard2)
    @quizcard2.calc_beta
    assert_equal 93, @quizcard2.calc_waitday(true)
  end

  test 'calc waitday when wrong answer' do
    model_sequences(@quizcard)
    @quizcard.calc_beta
    assert_equal 55, @quizcard.calc_waitday(false)
    model_sequences(@quizcard2)
    @quizcard2.calc_beta
    assert_equal 77, @quizcard2.calc_waitday(false)
  end

  test 'next_sequence' do
    assert_difference 'Waitday.count', 1 do
      model_sequences(@quizcard)
      @quizcard.calc_beta
      wait_day = @quizcard.calc_waitday(true)
      @quizcard.next_sequence(wait_day)
    end
  end

  test 'update_appearing' do
    model_sequences(@quizcard)
    @quizcard.calc_beta
    wait_day = @quizcard.calc_waitday(true)
    assert @quizcard.update_appearing(wait_day)
  end

  test 'set total time for the first time' do
    assert_equal 3, set_total_time(User.first.id, 3)
  end

  test 'set total time for twice' do
    set_total_time(User.first.id, 3)
    assert_equal 6, set_total_time(User.first.id, 3)
  end

  test 'total_practices' do
    @user.set_total_time(0)
    assert_equal 1, @user.total_practices
  end
end
