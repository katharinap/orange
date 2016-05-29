class WeightChart < LazyHighCharts::HighChart
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(user)
    super()
    set_options
    add_series(user.user_stats.order(:date))
  end

  private

  def set_options
    data(dateFormat: 'YYYY-mm-dd')
    plotOptions(series: { point: { events: {} } })
    xAxis(type: 'datetime')
  end

  def add_series(user_stats)
    return if user_stats.empty?
    series(type: 'line',
           name: 'Weight',
           data: weight_data(user_stats),
           allowPointSelect: true)
  end

  def weight_data(user_stats)
    user_stats.map do |s|
      {
        x: milliseconds(s.date),
        y: s.weight.to_f,
        url: url_helpers.edit_weight_path(s)
      }
    end
  end

  def milliseconds(date)
    date_time = date.to_datetime
    date_time.to_i * 1000
  end
end
