class QuizcardsController < ApplicationController
  def judge
    if params[:quizcard][:right_name] == (params[:quizcard][:name])
      session[:success] = "正解"
      session[:box_mode] = "1" #0: practice 1:right 2:fault
      # 解答時間　quizcarad wait_seconds
      # record_wait_seconds 現在時刻　ー　開始時間hiddenparams[:starttime]
      # record_waitdays 現在時刻　ー　last_appeard_at
      # calc_waidays beta * model_wait(wait_sequence)
      # waitdays更新　wait_sequence++. wait_day, appering_at
      # quizcard更新　wait_seconds, last_appeard_at, appearing_at
      redirect_to root_url
    else
      session[:danger] = "不正解"
      session[:box_mode] = "2"
    end
  end
end
