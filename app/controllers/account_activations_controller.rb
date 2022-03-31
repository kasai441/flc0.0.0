# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    @user = User.find_by(email: params[:email])
    token = params[:id]
    if @user&.authenticated?(:activation, token)
      @user.activate
      log_in @user
      flash[:success] = 'ようこそFlashcardsへ！'
    else
      flash[:danger] = '有効化に失敗しました'
    end
    redirect_to root_url
  end
end
