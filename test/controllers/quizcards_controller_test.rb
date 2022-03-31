# frozen_string_literal: true

require 'test_helper'

class QuizcardsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @quizcard1 = @user.quizcards.first
  end

  test 'redirect when judge page reloaded' do
    get root_path
    get practice_path
    post judge_path, params: { quizcard: { card_id: @quizcard1.id,
                                           name: @quizcard1.name } }
    assert_template 'quizcards/judge'
    post judge_path, params: {}
    assert_redirected_to root_url
  end

  test '@user variables in temp_practice with user_id cookies' do
  end

  test 'redirect temp_practice without cards' do
  end

  test 'redirect temp_judge without cards' do
  end

  test 'redirect practice without cards' do
  end

  test 'redirect judge without cards' do
  end
end
