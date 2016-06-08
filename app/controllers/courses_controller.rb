class CoursesController < ApplicationController
  before_action :set_course, except: %i(index new create)

  def index
    @course_names = Course::KNOWN.keys
    @multi_user = !params[:user_id]
    respond_to do |format|
      format.html
      format.json do
        users = @multi_user ? User.relevant : [User.find(params[:user_id])]
        render json: Course.calendar_data(*users).to_json
      end
    end
  end

  def edit
    @permitted = @course.user == current_user
    respond_to do |format|
      format.js
    end
  end

  def new
    @course = Course.new(user: current_user,
                         date: today,
                         name: params[:name])
    @permitted = true
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def update
    if @course.update(course_params)
      flash[:notice] = 'Course successfully updated.'
      redirect_to user_courses_path(current_user)
    else
      render :edit
    end
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      flash[:notice] = 'Course successfully created.'
    else
      flash[:error] = 'Failed to create course.'
    end
    redirect_to user_courses_path(current_user)
  end

  def destroy
    @course.destroy
    flash[:notice] = 'Course successfully deleted.'
    redirect_to user_courses_path(current_user)
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:date, :name, :user_id)
  end
end
