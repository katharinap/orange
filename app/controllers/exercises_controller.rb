class ExercisesController < ApplicationController
  before_action :set_exercise, except: %i(index new create)

  def index
    @user = User.find(params[:user_id])
    @chart = ExerciseChart.new(@user)
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def new
    @exercise = Exercise.new(type: params[:type],
                             user: current_user,
                             date: Date.current)
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def update
    if @exercise.update(exercise_params)
      redirect_to user_exercises_path(current_user,
                                      notice: 'Exercise was updated.')
    else
      render :edit
    end
  end

  def create
    @exercise = Exercise.new(exercise_params)
    if @exercise.save
      redirect_to user_exercises_path(current_user,
                                      notice: 'Exercise was created.')
    else
      redirect_to user_exercises_path(current_user,
                                      error: 'Failed to create exercise.')
    end
  end

  def destroy
    @exercise.destroy
    redirect_to user_exercises_path(current_user,
                                    notice: 'Exercise was deleted.')
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

  def exercise_params
    params.require(:exercise)
          .permit(:date, :repetitions, :duration, :type, :user_id)
  end
end
