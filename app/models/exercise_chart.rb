class ExerciseChart < LazyHighCharts::HighChart
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(*exercise_arrays)
    super()
    set_options
    exercise_arrays.each do |exercises|
      add_series(exercises)
    end
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
        url: url_helpers.exercise_path(e)
      }
    end
  end

  def milliseconds(date)
    date_time = DateTime.new(date.year, date.month, date.day)
    date_time.to_i * 1000
  end
end
