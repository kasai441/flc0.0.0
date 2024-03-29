# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[show edit update]
  before_action :is_current_user, only: %i[show edit update destroy]

  def show
    @user = User.find(params[:id])
    @quizcards = @user.quizcards.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = 'ユーザー有効化のためのメールを送信しました'
      redirect_to root_url
      # flash[:success] = "ユーザーが登録されました！"
      # redirect_to @user
      # render 'show' showアクションにデバッガーを仕掛けても素通りするのでviewを直接通っているっぽい
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報が更新されました'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy; end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'ログインしてください'
      redirect_to login_url
    end
  end

  def is_current_user
    redirect_to root_url unless current_user?(User.find(params[:id]))
  end
end
