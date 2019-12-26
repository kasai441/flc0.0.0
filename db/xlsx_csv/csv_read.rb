require 'csv'

csv_data = CSV.read('db/xlsx_csv/0.csv')
csv_data.each do |data|
  puts data
end
