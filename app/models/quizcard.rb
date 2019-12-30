class Quizcard < ApplicationRecord
  require 'csv'
  belongs_to :user
  has_many :waitdays, dependent: :destroy
  default_scope -> { order(appearing_at: :desc) }

  def csv_read
    # q = Quizcard.new
    # q.csv_read
    4.times do |num|
      csv_data = CSV.read("db/xlsx_csv/#{num}.csv")

      p csv_data

      # csv_data.each do |data|
      #   puts data
      # end

      csv_data.each do |data|
        f = data[0]
        fail_seq = nil
        fail_seq = f.split(" ") unless f.nil?
        description = data[1]
        # p "data[2]-#{data[2]}"
        # csv がmmddyyyyなのでddmmyyyyに変換
        registered_at = nil
        if !data[2].nil?
          date_a = data[2].split("/")
          date_a[0], date_a[1] = date_a[1], date_a[0]
          registered_at = date_a.join("/")
        end
        # p "registered_at-#{registered_at}"
        name = data[3]
        connotation = data[4]
        pronunciation = data[5]
        origin = data[6]
        User.first.quizcards.create(fail_seq: fail_seq,
                            description: description,
                            registered_at: registered_at,
                            name: name,
                            connotation: connotation,
                            pronunciation: pronunciation,
                            origin: origin,
                            appearing_at: Time.zone.today)
      end
    end
  end

  def get_growth_rate
    # q = Quizcard.new
    # q.get_growth_rate
    wseq = Waitday.group(:wait_sequence).where(quizcard_id: User.first.quizcards.select("id")).count
    # p wseq
    growth_rate = {}
    32.times do |num|
      before = wseq[num.to_s]
      after = wseq[(num + 1).to_s]
      before ||= 0
      after ||= 0
      rate = 0.0
      # p before, after, rate
      rate =  after.to_f / before.to_f if before > 0
      growth_rate["#{num + 1}- #{after}/#{before}"] = "#{rate.round(2)}"
    end
    growth_rate
  end
end
