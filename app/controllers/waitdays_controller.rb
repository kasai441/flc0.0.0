class WaitdaysController < ApplicationController
  def chart
    wseq = Waitday.group(:wait_sequence).where(quizcard_id: User.first.quizcards.select("id")).count
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
      rate =  wait.to_f / seq.to_f if seq > 0
      wait_rate[num + 1] = rate.round(2)
    end

    seq = wait_rate.size.times
    @wait = []
    seq.each do |s|
      @wait << wait_rate[s+1]
    end

    @chart0 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "wait cards")
      c.xAxis(categories: seq)
      c.series(name: "cards", data: wait_cards)
    end

    @chart = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "wait rate")
      c.xAxis(categories: seq)
      c.series(name: "waitrate", data: @wait)
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
