# frozen_string_literal: true

require 'test_helper'

class QuizcardsJudgeTest < ActionDispatch::IntegrationTest
  def setup
    @user1 = users(:michael)
    @quizcard1 = @user1.quizcards.first
    @waitday1 = @quizcard1.waitdays.first
  end

  test 'judge with login' do
    get root_path
    log_in_as @user1
    get root_path
    get practice_path
    post judge_path, params: { quizcard: { card_id: @quizcard1.id,
                                           name: @quizcard1.name,
                                           begin_answer: Time.zone.now } }
    assert_template 'quizcards/judge'
  end

  test 'right answer' do
    get root_path
    get practice_path
    post judge_path, params: { quizcard: { card_id: @quizcard1.id,
                                           name: @quizcard1.name } }
    assert_select 'div.alert', '正解'
  end

  test 'wrong answer' do
    get root_path
    get practice_path
    post judge_path, params: { quizcard: { card_id: @quizcard1.id,
                                           name: ' ' } }
    assert_select 'div.alert', '不正解'
  end

  test 'display answer time' do
    get root_path
    get practice_path
    post judge_path, params: { quizcard: { card_id: @quizcard1.id,
                                           name: @quizcard1.name } }
    assert_match(/解答時間： #{@answer_time} 秒/, response.body)
  end

  test 'waitdays recording when right answer' do
    # beta: 80%, sequence: 10,
    # assert_equal assigns(:quizcard).beta 0.8
    # assert_equal assigns(:quizcard).waytdays.sequence 10
    # assert_equal assigns(:quizcard).waytdays.wait_day 48
  end
end
