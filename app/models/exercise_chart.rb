class ExerciseChart < LazyHighCharts::HighChart
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(*users)
    super()
    @multi_user = users.size > 1
    set_options
    users.each_with_index do |user, idx|
      add_series(user.sit_ups, idx)
      add_series(user.push_ups, idx)
    end
  end

  private

  def set_options
    data(dateFormat: 'YYYY-mm-dd')
    plotOptions(series: { point: { events: {} } })
    xAxis(type: 'datetime')
  end

  def add_series(exercises, user_idx)
    return if exercises.empty?
    series(type: @multi_user ? 'line' : 'column',
           name: label_name(exercises.first),
           data: exercise_data(exercises),
           dashStyle: dash_style(exercises.first),
           color: color(exercises.first, user_idx),
           allowPointSelect: true)
  end

  def label_name(exercise)
    base = exercise.type.pluralize.titleize
    return base unless @multi_user
    "#{base} (#{exercise.user.login})"
  end

  def dash_style(exercise)
    exercise.type == 'PushUp' ? 'Solid' : 'ShortDash'
  end

  def color(exercise, user_idx)
    color_idx = if @multi_user
                  user_idx.remainder(ApplicationRecord::COLORS.size)
                else
                  exercise.type == 'PushUp' ? 0 : 1
                end
    ApplicationRecord::COLORS[color_idx]
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
    date_time = date.to_datetime
    date_time.to_i * 1000
  end
end
