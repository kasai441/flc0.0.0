require 'csv'

# 代表ユーザー
@user = User.create!(name:  "Example User",
             email: "user@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             # admin:     true,
             activated: true,
             activated_at: Time.zone.now,
             total_time: 3600 * 150,
             practice_days: 150,
             total_practices: 60 * 150)

# サンプルユーザー
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

# 代表ユーザーの代表カード
@quizcard = @user.quizcards.create(description: "プログラミングの勉強で最初に出力するお決まりの文句は？",
                      name: "helloworld",
                      appearing_at: Time.zone.today)
@quizcard.waitdays.create(wait_sequence: 0, wait_day: 1)
# 代表ユーザーの１−５のシーケンスを持つカードを作る
@quizcard = @user.quizcards.create(description: "ワンとなく動物は？",
                      name: "dog",
                      appearing_at: Time.zone.today)
@quizcard.waitdays.create(wait_sequence: 1, wait_day: 1)
@quizcard = @user.quizcards.create(description: "ニャアとなく動物は？",
                      name: "cat",
                      appearing_at: Time.zone.today)
@quizcard.waitdays.create(wait_sequence: 2, wait_day: 1)
@quizcard = @user.quizcards.create(description: "ブウとなく動物は？",
                      name: "pig",
                      appearing_at: Time.zone.today)
@quizcard.waitdays.create(wait_sequence: 3, wait_day: 1)
@quizcard = @user.quizcards.create(description: "モウとなく動物は？",
                      name: "cow",
                      appearing_at: Time.zone.today)
@quizcard.waitdays.create(wait_sequence: 4, wait_day: 1)
@quizcard = @user.quizcards.create(description: "今何問目？",
                      name: "six",
                      appearing_at: Time.zone.today)
@quizcard.waitdays.create(wait_sequence: 5, wait_day: 1)

# 代表ユーザーの実サンプルカード
get_num = 10
get_num.times do |number|
  csv_data = CSV.read("db/xlsx_csv/#{number}.csv")

  count = 0
  csv_data.each do |data|
    next if data[3].nil?
    fail_seq = data[0]
    description = data[1]
    # csv がmmddyyyyなのでddmmyyyyに変換
    registered_at = nil
    if !data[2].nil?
      date_a = data[2].split("/")
      date_a[0], date_a[1] = date_a[1], date_a[0]
      registered_at = date_a.join("/")
    end
    name = data[3]
    connotation = data[4]
    pronunciation = data[5]
    origin = data[6]
    quizcard = User.first.quizcards.create(fail_seq: fail_seq,
                        description: description,
                        registered_at: registered_at,
                        name: name,
                        connotation: connotation,
                        pronunciation: pronunciation,
                        origin: origin,
                        appearing_at: Time.zone.today + count,
                        answer_time: 60)
    wait_sequence = number + 6
    (wait_sequence + 1).times do |n|
      quizcard.waitdays.create(wait_sequence: wait_sequence - 1 * n)
    end
    count += 1
  end
end

# 実サンプルカードのシーケンスの待機日計算
wseq = Waitday.group(:wait_sequence).where(quizcard_id: User.first.quizcards.select("id")).count
wseq.size.times do |n|
  wseq[n] -= wseq[n + 1] if n < wseq.size - 1
end
(get_num + 6).times do |number|
  wait_day = wseq[number]
  wait_day = 1 if wait_day.nil? or wait_day < 1
  Waitday.where(wait_sequence: number).where(quizcard_id: User.first.quizcards.select("id")).update_all(wait_day: wait_day)
end

# 上位サンプルユーザーのためのサンプルカード

# users = User.order(:created_at).take(6)

# 10.times do |number|
#   description = Faker::Lorem.sentence(10)
#   name = description[0] + "#{number}"
#   users.each do|user|
#     quizcard = user.quizcards.create!(description: description, name: name, appearing_at: Time.zone.today)
#     quizcard.waitdays.create(wait_sequence: 0, wait_day: 1)
#   end
# end
