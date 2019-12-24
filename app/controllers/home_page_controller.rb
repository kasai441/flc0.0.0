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
      @quizcards_today = @user.quizcards.where('appearing_at > ?', 1.day.ago) if @user.quizcards.any?
      @quizcards = @user.quizcards.paginate(page: params[:page])
      @quizcard = @quizcards_today.first if @quizcards_today
      render 'index'
    end
  end
end
