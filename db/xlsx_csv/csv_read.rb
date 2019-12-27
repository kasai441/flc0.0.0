require 'csv'

csv_data = CSV.read('db/xlsx_csv/10.csv')

# p csv_data

# csv_data.each do |data|
#   puts data
# end

csv_data.each do |data|
  f = data[0]
  fail_seq = nil
  fail_seq = f.split(" ") unless f.nil?
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

