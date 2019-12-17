class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_reset_digest
      UserMailer.password_reset(@user).deliver_now
      flash[:info] = "パスワード再発行の承認メールを送信しました"
      redirect_to root_url
    else
      flash[:danger] = "該当パスワードはありません"
      render 'new'
    end
  end

  def edit
    if @user.authenticated?(:reset, params[:id])
      log_in @user
    else
      flash[:danger] = "再発行に失敗しました"
      redirect_to root_url
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "パスワードが更新されました"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
       @user = User.find_by(email: params[:email])
     end

     # 有効なユーザーかどうか確認する
     def valid_user
       unless (@user && @user.activated? &&
               @user.authenticated?(:reset, params[:id]))
         redirect_to root_url
       end
     end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワード再発行が期限切れです"
        redirect_to new_password_reset_url
      end
    end
end
