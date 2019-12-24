class HomePageController < ApplicationController
  def index
    # session[:box_mode] ||= '0'
    if logged_in?
      @user = current_user
      @quizcards_today = @user.quizcards.where('appearing_at > ?', 1.day.ago) if @user.quizcards.any?
      @quizcards = @user.quizcards.paginate(page: params[:page])
      @quizcard = @quizcards_today.first if @quizcards_today
      render 'show'
    else
      @user = User.find_by(email: "example@railstutorial.org")
      cookies[:temp_user_id] = @user.id
      if cookies[:quizcards_today_ids]
         ids = JSON.parse(cookies[:quizcards_today_ids])
         @quizcards_today = ids.map { |id| Quizcard.find(id) }
      else
        @quizcards_today = @user.quizcards.where('appearing_at > ?', 1.day.ago) if @user.quizcards.any?
        cookies[:quizcards_today_ids] = JSON.generate(@quizcards_today.map { |quizcard| quizcard.id })
      end
      @quizcards = @user.quizcards.paginate(page: params[:page])
      @quizcard = @quizcards_today.first if @quizcards_today
      cookies[:quizcard_id] = @quizcard.id
      render 'index'
    end
  end
end
