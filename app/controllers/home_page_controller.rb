class HomePageController < ApplicationController
  def index
    if logged_in?
      # ログインの場合、current_userを取得する
      @user = current_user
      # 一覧のためのユーザー所属カード全取得
      @quizcards = @user.quizcards.paginate(page: params[:page])
      # カードを持っている場合、今日のカードを絞り込む
      @quizcards_today = @user.quizcards.where('appearing_at > ?', Time.zone.today).where('appearing_at <= ?', Time.zone.today + 1) if @user.quizcards.any?
      # 今日のカードがあった場合、最初のカードを取得する
      @quizcard = @quizcards_today.first if @quizcards_today
      render 'show'
    else
      # ログインしていない場合、一時利用ユーザーを取得する
      @user = User.find_by(email: "example@railstutorial.org")
      # 一覧のためのユーザー所属カード全取得
      @quizcards = @user.quizcards.paginate(page: params[:page])
      
      #＃＃＃＃＃＃＃＃＃＃＃＃＃全ユーザーのモデルシークエンスを平均してデータベース更新
      
      #＃＃＃＃＃＃＃＃＃＃＃＃
      
      # クッキーにユーザーIDを記憶
      cookies[:temp_user_id] = @user.id
      # 今日のクッキーが保存されているか確認（ログイン時はクッキーを利用しないのでクッキー情報は必ず一時利用ユーザー）
      if cookies[:quizcards_today_ids]
        # クッキーに保存されている今日のクッキーを取得
         ids = JSON.parse(cookies[:quizcards_today_ids])
         @quizcards_today = ids.map { |id| Quizcard.find(id) }
      else
        # クッキーにない場合はデータベースから新たに取得
        @quizcards_today = @user.quizcards.take(500) if @user.quizcards.any?
        cookies[:quizcards_today_ids] = JSON.generate(@quizcards_today.map { |quizcard| quizcard.id })
      end
      @quizcard = @quizcards_today.first if @quizcards_today
      cookies[:quizcard_id] = @quizcard.id if @quizcard
      render 'temp_show'
    end
  end
end
