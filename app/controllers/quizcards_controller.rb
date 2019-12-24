class QuizcardsController < ApplicationController
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

  def judge
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
