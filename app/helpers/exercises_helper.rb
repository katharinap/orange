module ExercisesHelper
  def exercise_modal_id(exercise, title=nil)
    exercise.persisted? ? "exercise-#{exercise.id}" : title.to_s.parameterize
  end
end  
