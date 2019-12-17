class AccountActivationsController < ApplicationController
  def edit
    @user = User.find_by(email: params[:email])
    token = params[:id]
    if @user && @user.authenticated?(:activation, token)
      @user.activate
      log_in @user
      flash[:success] = "ようこそFlashcardsへ！"
      redirect_to root_url
    else
      flash[:danger] = "有効化に失敗しました"
      redirect_to root_url
    end
  end
end
