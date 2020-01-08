require 'csv'

# 代表ユーザー
@user = User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             # admin:     true,
             activated: true,
             activated_at: Time.zone.now)

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
@quizcard = @user.quizcards.create(description: "プログラミングの勉強で最初に出力するお決まりの文句は？（全小文字、ローマ字のみ）",
                      name: "helloworld",
                      appearing_at: Time.zone.today)
@quizcard.waitdays.create(wait_sequence: 0, wait_day: 1)

# 代表ユーザーの実サンプルカード
get_num = 32
get_num.times do |number|
  csv_data = CSV.read("db/xlsx_csv/#{number}.csv")

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
                        appearing_at: Time.zone.today)
    wait_sequence = number + 6
    quizcard.waitdays.create(wait_sequence: wait_sequence)
  end
end

# 実サンプルカードのシーケンスの待機日計算
wseq = Waitday.group(:wait_sequence).where(quizcard_id: User.first.quizcards.select("id")).count
(get_num + 6).times do |number|
  wait_day = wseq[number]
  wait_day = 1 if wait_day.nil?
  Waitday.where(wait_sequence: number).update_all(wait_day: wait_day)
end

# 上位サンプルユーザーのためのサンプルカード

users = User.order(:created_at).take(6)

10.times do |number|
  description = Faker::Lorem.sentence(10)
  name = description[0] + "#{number}"
  users.each do|user|
    quizcard = user.quizcards.create!(description: description, name: name, appearing_at: Time.zone.today)
    quizcard.waitdays.create(wait_sequence: 0, wait_day: 1)
  end
end
