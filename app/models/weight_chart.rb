class WeightChart < LazyHighCharts::HighChart
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(*users)
    super()
    @multi_user = users.size > 1
    set_options
    users.each_with_index do |user, idx|
      add_series(user.user_stats, idx)
    end
  end

  private

  def set_options
    data(dateFormat: 'YYYY-mm-dd')
    plotOptions(series: { point: { events: {} } })
    xAxis(type: 'datetime')
  end

  def add_series(user_stats, user_idx)
    return if user_stats.empty?
    series(type: 'line',
           name: label_name(user_stats.first),
           data: weight_data(user_stats),
           color: color(user_idx),
           allowPointSelect: true)
  end

  def label_name(user_stat)
    @multi_user ? user_stat.user.login : 'Weight'
  end

  def weight_data(user_stats)
    user_stats.order(:date).map do |s|
      {
        x: milliseconds(s.date),
        y: s.weight.to_f,
        url: url_helpers.edit_weight_path(s)
      }
    end
  end

  def color(user_idx)
    color_idx = user_idx.remainder(ApplicationRecord::COLORS.size)
    ApplicationRecord::COLORS[color_idx]
  end

  def milliseconds(date)
    date_time = date.to_datetime
    date_time.to_i * 1000
  end
end
