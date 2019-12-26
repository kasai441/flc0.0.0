@user = User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             # admin:     true,
             activated: true,
             activated_at: Time.zone.now)

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

@user.quizcards.create(description: "プログラミングの勉強で最初に出力するお決まりの文句は？（全小文字、ローマ字のみ）",
                      name: "helloworld",
                      appearing_at: Time.zone.today)

users = User.order(:created_at).take(6)
10.times do
  description = Faker::Lorem.sentence(10)
  users.each { |user| user.quizcards.create!(description: description, name: description[0], appearing_at: Time.zone.today) }
end
