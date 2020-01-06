class QuizcardsController < ApplicationController
  def temp_practice
    @user = User.find(cookies[:temp_user_id])
    if (ids = JSON.parse(cookies[:quizcards_today_ids])).any?
      @quizcards_today = ids
      @quizcard = Quizcard.find(ids.first)
    else
      redirect_to root_url
    end
  end

  def practice
    if logged_in?
      @user = current_user
    else
      @user = User.find_by(email: "example@railstutorial.org")
    end

    if @user.quizcards.any?
      @quizcards_today = @user.quizcards.where('appearing_at > ?', 1.day.ago)
      if @quizcards_today
        @quizcard = @quizcards_today.first
      else
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end

  def temp_judge
    redirect_to root_url and return if params[:quizcard].nil?
    @quizcard = Quizcard.find(params[:quizcard][:card_id])
    @answer = params[:quizcard][:name]
    if @quizcard.name == @answer
      flash.now[:success] = "正解"
      @quizcards_today = JSON.parse(cookies[:quizcards_today_ids])
      @quizcards_today.delete(@quizcard.id)
      cookies[:quizcards_today_ids] = JSON.generate(@quizcards_today)
      @quizcards_right = []
      @quizcards_right << @quizcard.id
      cookies[:quizcards_right_ids] = JSON.generate(@quizcards_right)
    else
      flash.now[:danger] = "不正解"
    end

  end

  def judge
    redirect_to root_url and return if params[:quizcard].nil?
    @quizcard = Quizcard.find(params[:quizcard][:card_id])
    @answer = params[:quizcard][:name]
    if @quizcard.name == @answer
      flash.now[:success] = "正解"
      # 解答時間　quizcarad wait_seconds
      # record_wait_seconds 現在時刻　ー　開始時間hiddenparams[:starttime]
      # record_waitdays 現在時刻　ー　last_appeard_at
      # calc_waidays beta * model_wait(wait_sequence)
      # waitdays更新　wait_sequence++. wait_day, appering_at
      # quizcard更新　wait_seconds, last_appeard_at, appearing_at
      @quizcard.update_attribute(:appearing_at, 1.month.ago)
    else
      flash.now[:danger] = "不正解"
    end
  end

end
