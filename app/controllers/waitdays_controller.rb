# frozen_string_literal: true

class WaitdaysController < ApplicationController
  def chart
    wseq = Waitday.group(:wait_sequence).where(quizcard_id: User.first.quizcards.select('id')).count

    wait_total = []
    wseq.size.times do |num|
      wait_total << wseq[num]
    end

    wseq.size.times do |n|
      wseq[n] -= wseq[n + 1] if n < wseq.size - 1
    end

    wait_cards = []
    wseq.size.times do |num|
      wait_cards << wseq[num]
    end

    wait_rate = {}
    wseq.size.times do |num|
      seq = num
      wait = wseq[num]
      seq ||= 0
      wait ||= 0
      rate = 0.0
      rate = wait.to_f / seq if seq.positive?
      wait_rate[num + 1] = rate.round(2)
    end

    seq = wait_rate.size.times
    @wait = []
    seq.each do |s|
      @wait << wait_rate[s + 1]
    end

    basic_s = [[], []]
    raw_basic_s = basic_sequences
    raw_basic_s.each do |e|
      basic_s[0] << e[0]
      basic_s[1] << e[1]
    end

    # w_linear = get_xy(to_nest(wait_cards))
    basic_linear = get_xy(raw_basic_s)
    # w_intercept = get_intercept(to_nest(wait_cards))
    basic_intercept = get_intercept(raw_basic_s)
    # w_linear_line = get_linear_line(to_nest(wait_cards))
    basic_linear_line = get_linear_line(raw_basic_s)

    @chart00 = LazyHighCharts::HighChart.new('graph') do |c|
      c.title(text: 'wait total')
      c.xAxis(categories: seq)
      c.series(name: 'total', data: wait_total)
    end

    # @chart0 = LazyHighCharts::HighChart.new("graph") do |c|
    #   c.title(text: "実データ（概算）")
    #   # c.chart(type: 'area', zoomType: 'x')
    #   c.xAxis(categories: seq, plotBands: [{
    #         from: get_x(w_intercept)[0],
    #         to: get_x(w_intercept)[1],
    #         color: 'rgba(68, 210, 150, .2)'
    #         },{
    #           from: get_x(w_intercept)[1],
    #           to: get_x(w_intercept)[2],
    #           color: 'rgba(68, 170, 213, .2)'
    #         }])
    #   c.series(name: "単語数", data: wait_cards)
    #   c.series(name: "関数", data: w_linear_line, marker: { enabled: false }, lineWidth: 2, lineColor: '#999')
    #   c.series(name: "前半平均座標(x1, y1)及び後半平均座標(x2, y2)", data: w_linear, marker: { radius: 6, fillColor: '#88aadd' })
    #   # c.series(name: "計算の範囲", data: w_intercept)
    # end

    @chart = LazyHighCharts::HighChart.new('graph') do |c|
      c.title(text: 'wait rate')
      c.xAxis(categories: seq)
      c.series(name: 'waitrate', data: @wait)
    end

    @chart_basic = LazyHighCharts::HighChart.new('graph') do |c|
      c.title(text: '基本関数')
      c.xAxis(categories: basic_s[0], plotBands: [{
                from: get_x(basic_intercept)[0],
                to: get_x(basic_intercept)[1],
                color: 'rgba(68, 210, 150, .2)'
              }, {
                from: get_x(basic_intercept)[1],
                to: get_x(basic_intercept)[2],
                color: 'rgba(68, 170, 213, .2)'
              }])
      c.series(name: '単語数', data: basic_s[1])
      c.series(name: '関数', data: basic_linear_line, marker: { enabled: false }, lineWidth: 2, lineColor: '#999')
      c.series(name: '前半平均座標(x1, y1)及び後半平均座標(x2, y2)', data: basic_linear, marker: { radius: 6, fillColor: '#88aadd' })
      # c.series(name: "計算の範囲", data: basic_intercept)
    end
    # y = a * x + b
    # 213 = a * 31 + b
    # b = 213 - a * 31
    # 59 = a * 16 + b
    # b = 59 - a * 16
    # 213 - 59 = a * 31 - a * 16
    # 154 = a * 15
    # a = 154 / 15
    # b = -97

    # result = 0.00
    # 36500.times do |n|
    #   result += 1.00 / n.to_f / 10.00 if n > 0
    # end
    # result

    # result = 10.00
    # count = 0
    # 36500.times do |n|
    #   next if result > 36500
    #   result += n
    #   count += 1
    # end
    # count
  end
end
