require 'csv'
module WaitdaysHelper
  def basic_sequences
    basic_s = []

    get_num = 32
    get_num.times do |number|
      csv_data = CSV.read("db/xlsx_csv/#{number}.csv")

      count = 0
      csv_data.each do |data|
        next if data[3].nil?
        count += 1
      end

      basic_s[number] = [number, count]
    end
    # debugger
    basic_s
  end

  def get_linear_function(seq)
    # 移動平均を２つとる　wait_dayが「傾き」以上〜半分　と　半分〜最後
    cut_seq = seq.map { |key, val| [key, val] if val > get_gradients }.compact.to_h
    if cut_seq.size >= 2
      first = cut_seq.to_a[0..(cut_seq.size / 2 - 1)]
      second =  cut_seq.to_a[(cut_seq.size / 2)..cut_seq.size]
      y1 = second.inject(0) { |result, e| result + e[1] }.to_f / second.size.to_f
      y2 = first.inject(0) { |result, e| result + e[1] }.to_f / first.size.to_f
      x2 = cut_seq.size.to_f / 4.0 + seq.size - cut_seq.size
      x1 = cut_seq.size.to_f * 3.0 / 4.0 + seq.size - cut_seq.size
      gradients = (y2 - y1) / (x2 - x1)
      intercepts = y1 - gradients * x1
      [seq, cut_seq, first, second, y1, y2, x1, x2, gradients, intercepts]
    end
  end

  def get_xy(raw)
    linear = get_linear_function(raw)
    y1, y2, x1, x2 = linear[4], linear[5], linear[6], linear[7]
    linear_f = []
    linear_f[x1] = y1
    linear_f[x2] = y2
    linear_f
  end

  def get_x(linear)
    x = []
    linear.each_with_index do |val, i|
      x << i.to_f - 0.5 unless val.nil?
    end
    x
  end

  def get_linear_line(raw)
    linear = get_linear_function(raw)
    gradients = linear[-2]
    intercepts = linear[-1]
    linear_line = []
    raw.size.times do |num|
      linear_line[num] = gradients * num + intercepts
    end
    linear_line
    # debugger
  end

  def get_intercept(raw)
    linear = get_linear_function(raw)
    x_intercept = linear[0].size - linear[1].size #+ 0.5
    center_p = x_intercept + linear[2].size #+ 0.5
    last_p = center_p + linear[3].size #+ 0.5
    intercept_line = []
    intercept_line[x_intercept] = 0
    intercept_line[center_p] = 0
    intercept_line[last_p] = 0
    intercept_line
  end

  def to_nest(raw)
    nest = []
    raw.size.times do |i|
      nest[i] = [i, raw[i]]
    end
    nest
    # debugger
  end

  private
    def get_gradients
      10
    end
end
