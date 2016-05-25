module ExercisesHelper
  def exercise_modal_id(exercise, title = nil)
    base = exercise.persisted? ? "exercise-#{exercise.id}" : title
    "modal-#{base.to_s.parameterize}"
  end
end
