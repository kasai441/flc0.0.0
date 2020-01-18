class QuizcardsController < ApplicationController
  def temp_practice
    @user = User.find(cookies[:temp_user_id])
    if (ids = JSON.parse(cookies[:quizcards_today_ids])).any?
      @quizcards_today = ids
      @quizcard = Quizcard.find(ids.first)
      @begin_answer = Time.zone.now
    else
      redirect_to root_url
    end
  end

  def temp_judge
    redirect_to root_url and return if params[:quizcard].nil?
    @quizcard = Quizcard.find(params[:quizcard][:card_id])
    @answer = params[:quizcard][:name]
    begin_answer = params[:quizcard][:begin_answer]
    @answer_time = answer_time(@quizcard, begin_answer) if begin_answer

    if @quizcard.name == @answer
      flash.now[:success] = "正解"
      @quizcards_today = JSON.parse(cookies[:quizcards_today_ids])
      @quizcards_today.delete(@quizcard.id)
      cookies[:quizcards_today_ids] = JSON.generate(@quizcards_today)
      @quizcards_right = []
      @quizcards_right << @quizcard.id
      cookies[:quizcards_right_ids] = JSON.generate(@quizcards_right)
    else
      flash.now[:danger] = "不正解"
    end

  end

  def practice
    if logged_in?
      @user = current_user
    else
      @user = User.find_by(email: "example@railstutorial.org")
    end

    if @user.quizcards.any?
      @quizcards_today = @user.quizcards.where('appearing_at > ?', Time.zone.today).where('appearing_at <= ?', Time.zone.today + 1)
      if @quizcards_today
        @quizcard = @quizcards_today.first
        @begin_answer = Time.zone.now
      else
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end

  def judge
    redirect_to root_url and return if params[:quizcard].nil?
    @quizcard = Quizcard.find(params[:quizcard][:card_id])
    @answer = params[:quizcard][:name]
    begin_answer = params[:quizcard][:begin_answer]
    @answer_time = answer_time(@quizcard, begin_answer) if begin_answer
    model_sequences(@quizcard)
    if @quizcard.name == @answer
      flash.now[:success] = "正解"
      next_waitday(@quizcard, true)
      assort_today_cards(@quizcard, true)
    else
      flash.now[:danger] = "不正解"
      next_waitday(@quizcard, false)
      assort_today_cards(@quizcard, false)
    end
  end

  def show
    if logged_in?
      # ログインの場合、current_userを取得する
      @user = current_user
      # カードを持っている場合、今日のカードを絞り込む
      if @user.quizcards.any?
        @quizcards_today = @user.quizcards.where('appearing_at > ?', Time.zone.today).where('appearing_at <= ?', Time.zone.today + 1).paginate(page: params[:page], per_page: 8) 
      end
    end
    # cookie情報を取得
    if (ids = cookies[:quizcards_right_ids])
      @quizcards_right = get_cards_by_id(ids).paginate(page: params[:page], per_page: 8) 
    end
    if (ids = cookies[:quizcards_wrong_ids])
      @quizcards_wrong = get_cards_by_id(ids).paginate(page: params[:page], per_page: 8) 
    end
  end
end
