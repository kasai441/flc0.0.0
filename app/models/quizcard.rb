class Quizcard < ApplicationRecord
  require 'csv'
  belongs_to :user
  has_many :waitdays, dependent: :destroy
  default_scope -> { order(appearing_at: :desc) }
  attr_accessor :gradients, :beta

  def update_answer_time(time)
    later_ave = self.answer_time
    if later_ave
      # 平均を計算
      sequence_size = get_wait_seq_day[0] + 1
      ave = (later_ave * sequence_size + time) / (sequence_size + 1)
    else
      ave = time
    end
    update_attribute(:answer_time, ave)
    time
  end

  def get_model_sequences
    user = User.find_by(id: self.user_id)
    seq = Waitday.group(:wait_sequence).where(quizcard_id: user.quizcards.select("id")).average(:wait_day)
    seq.map { |key,val| [key,val.to_i] }.to_h
  end

  def get_linear_function(seq)
    # 移動平均を２つとる　wait_dayが「傾き」以上〜半分　と　半分〜最後
    cut_seq = seq.map { |key, val| [key, val] if val > get_gradients }.compact.to_h
    if cut_seq.size >= 2
      first = cut_seq.to_a[0..(cut_seq.size / 2 - 1)]
      second =  cut_seq.to_a[(cut_seq.size / 2)..cut_seq.size]
      y1 = second.inject(0) { |result, e| result + e[1] } / second.size
      y2 = first.inject(0) { |result, e| result + e[1] } / first.size
      x1 = (cut_seq.size / 4 + seq.size - cut_seq.size).to_i
      x2 = (cut_seq.size * 3 / 4 + seq.size - cut_seq.size).to_i
      self.gradients = (y2 - y1) / (x2 - x1)
      [seq, cut_seq, first, second, y1, y2, x1, x2, gradients]
    end
  end

  def calc_beta
    beta = 1.0
    model_sequences = get_model_sequences
    wait_seq = get_wait_seq_day[0]
    wait_day = get_wait_seq_day[1].to_f
    # 単語ごとの待機期間　／　単語全体平均の待機期間
    if model_sequences[wait_seq] > 0
      beta = wait_day / model_sequences[wait_seq].to_f
    end
    self.beta = prize_beta(beta)
  end

  def prize_beta(beta)
    # 連続正解期間に応じた成長値
    wait_seqs = Waitday.where(quizcard_id: self.id)
    # ソート
    wait_seqs = wait_seqs.map { |e| [e.wait_sequence, e.wait_day] }.sort
    if (s = wait_seqs.size) >= 2
      (s - 1).times do |n|
        before = wait_seqs[s - 1 - n - 1][1]
        after = wait_seqs[s - 1 - n][1]
        # p [before, after]
        beta += 0.1 if after > before
      end
    end
    beta.round(2)
  end

  def real_wait_day
    overdate = (Date.today - self.appearing_at.to_date).to_i
    real_waitday = get_wait_seq_day[1] + overdate
    get_wait_seq_day[2].update_real_wait_day(real_waitday)
    real_waitday
  end

  def calc_waitday(result)
    if get_wait_seq_day[0] >= get_gradients
      if result
        waitday = self.beta * (get_wait_seq_day[1] + get_gradients)
      else
        waitday = self.beta * (get_wait_seq_day[1] - get_gradients)
      end
    else
      if get_wait_seq_day[0] > 0
        if result
          waitday = self.beta * get_wait_seq_day[1] * 2
        else
          waitday = self.beta * get_wait_seq_day[1] / 2
        end
      else
        waitday = 1
      end
    end

    if waitday.to_i <= 0
      waitday = 1
    end
    waitday.to_i
  end

  def next_sequence(wait_day)
    self.waitdays.create(wait_sequence: get_wait_seq_day[0] + 1, wait_day: wait_day)
  end

  def update_appearing(wait_day)
    appearing_at = Date.today + wait_day
    update_attribute(:appearing_at, appearing_at)
  end

  private
    def get_gradients
      if self.gradients.nil?
        self.gradients = 10
      end
      self.gradients
    end

    def get_wait_seq_day
      sequence = self.waitdays.maximum(:wait_sequence)
      waitday_obj = self.waitdays.find_by(wait_sequence: sequence)
      waitday = waitday_obj.wait_day
      [sequence, waitday, waitday_obj]
    end
end
