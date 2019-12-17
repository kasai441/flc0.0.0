class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      log_in(@user)
      rediret_back_or root_url
    else
      flash.now[:danger] = "Eメールとパスワードの組み合わせが違います！"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
