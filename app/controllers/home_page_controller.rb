class HomePageController < ApplicationController
  def index
    # session[:box_mode] ||= '0'
    if logged_in?
      @user = current_user
      @quizcards_today = @user.quizcards.where('appearing_at > ?', 1.day.ago) if @user.quizcards.any?
      @quizcards = @user.quizcards.paginate(page: params[:page])
      @quizcard = @quizcards_today.first if @quizcards_today.any?
      render 'show'
    else
      @user = User.first
      @quizcards_today = @user.quizcards.where('appearing_at > ?', 1.day.ago) if @user.quizcards.any?
      @quizcards = @user.quizcards.paginate(page: params[:page])
      @quizcard = @quizcards_today.first if @quizcards_today.any?
      render 'index'
    end
  end
end
