module ExercisesHelper
  def exercise_modal_title(exercise)
    pre = exercise.persisted? ? 'Edit' : 'Create'
    "#{pre} #{@exercise.type.titleize} Entry"
  end
end
