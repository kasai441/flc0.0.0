require 'csv'

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

30.times do |number|
  csv_data = CSV.read("db/xlsx_csv/#{number}.csv")

  csv_data.each do |data|
    fail_seq = data[0]
    description = data[1]
    registered_at = data[2]
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

users = User.order(:created_at).take(6)

10.times do |number|
  description = Faker::Lorem.sentence(10)
  name = description[0] + "#{number}"
  users.each { |user| user.quizcards.create!(description: description, name: name, appearing_at: Time.zone.today) }
end
