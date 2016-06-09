class ExercisesController < ApplicationController
  before_action :set_exercise, except: %i(index new create)

  def index
    @multi_user = !params[:user_id]
    if @multi_user
      @chart = ExerciseChart.new(*User.relevant)
    else
      @user = User.find(params[:user_id])
      @chart = ExerciseChart.new(@user)
    end
  end

  def edit
    @permitted = @exercise.user == current_user
    respond_to do |format|
      format.js
    end
  end

  def new
    @exercise = Exercise.new(type: params[:type],
                             user: current_user,
                             date: today)
    @permitted = true
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def update
    if @exercise.update(exercise_params)
      flash[:notice] = 'Exercise successfully updated.'
      redirect_to exercises_path
    else
      render :edit
    end
  end

  def create
    @exercise = Exercise.new(exercise_params)
    if @exercise.save
      flash[:notice] = 'Exercise successfully created.'
    else
      flash[:error] = 'Failed to create exercise.'
    end
    redirect_to exercises_path
  end

  def destroy
    @exercise.destroy
    flash[:notice] = 'Exercise successfully deleted.'
    redirect_to exercises_path
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
