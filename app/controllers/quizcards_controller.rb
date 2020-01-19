class QuizcardsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def practice
    if logged_in?
      @user = current_user
      if @user.quizcards.any?
        @quizcards_today = @user.quizcards.where('appearing_at > ?', Time.zone.today).where('appearing_at <= ?', Time.zone.today + 1)
        if !@quizcards_today.empty?
          @quizcard = @quizcards_today.first
          @begin_answer = Time.zone.now
        else
          redirect_to root_url
        end
      else
        redirect_to root_url
      end
    else
      @user = User.find(cookies[:temp_user_id])
      if (ids = JSON.parse(cookies[:quizcards_today_ids])).any?
        @quizcards_today = ids
        @quizcard = Quizcard.find(ids.first)
        @begin_answer = Time.zone.now
      else
        redirect_to root_url
      end
    end
  end

  def judge
    if logged_in?
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
    else
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

  def new
    @quizcard = Quizcard.new
  end

  def create
    @user = current_user
    @quizcard = @user.quizcards.new(quizcard_params)
    @quizcard.appearing_at = Time.zone.today
    if @quizcard.save
      @quizcard.waitdays.create(wait_sequence: 0, wait_day: 1)
      flash[:success] = "新しい単語を追加しました"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    @quizcard.destroy
    flash[:success] = "単語を削除しました"
    redirect_to request.referrer || root_url
  end

  private
    def quizcard_params
      params.require(:quizcard).permit(:name, :description, :connotation, :pronunciation, :origin)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end

    def correct_user
      @quizcard = current_user.quizcards.find_by(id: params[:id])
      redirect_to root_url if @quizcard.nil?
    end
end
