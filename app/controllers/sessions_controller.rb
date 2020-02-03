class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in(@user)
        params[:session][:remember_me]=='1'?remember(@user):forget(@user)
        rediret_back_or root_url
      else
        flash[:warning] = "ユーザーが認証されていません"
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Eメールとパスワードの組み合わせが違います！"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
