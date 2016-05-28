class ExerciseChart < LazyHighCharts::HighChart
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(user)
    super()
    set_options
    add_series(user.sit_ups.order(:date))
    add_series(user.push_ups.order(:date))
  end

  private

  def set_options
    data(dateFormat: 'YYYY-mm-dd')
    plotOptions(series: { point: { events: {} } })
    xAxis(type: 'datetime')
  end

  def add_series(exercises)
    return if exercises.empty?
    series(type: 'column',
           name: label_name(exercises.first),
           data: exercise_data(exercises),
           allowPointSelect: true)
  end

  def label_name(exercise)
    exercise.type.pluralize.titleize
  end

  def exercise_data(exercises)
    exercises.map do |e|
      {
        x: milliseconds(e.date),
        y: e.repetitions,
        url: url_helpers.edit_exercise_path(e)
      }
    end
  end

  def milliseconds(date)
    date_time = DateTime.new(date.year, date.month, date.day)
    date_time.to_i * 1000
  end
end
