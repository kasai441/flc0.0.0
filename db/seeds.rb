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
20.times do |n|
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
