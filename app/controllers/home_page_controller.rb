class HomePageController < ApplicationController
  def index
    session[:box_mode] ||= '0'
    if logged_in?
      @user = current_user
      @quizcard = @user.quizcards.first if @user.quizcards.any?
      @quizcards = @user.quizcards.paginate(page: params[:page])
      render 'show'
    else
      @user = User.first
      @quizcard = @user.quizcards.first if @user.quizcards.any?
      @quizcards = @user.quizcards.paginate(page: params[:page])
      render 'index'
    end
  end
end
