# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :require_signed_in
  before_action :set_project
  before_action :set_task, only: %i[show edit update destroy]

  # GET /tasks
  def index
    authorize! :read, @project
    @tasks = @project.tasks.all
  end

  # GET /tasks/new
  def new
    @task = @project.tasks.build
    authorize! :create, @task
  end

  # GET /tasks/1/edit
  def edit
    authorize! :update, @task
  end

  # POST /tasks
  def create
    @task = @project.tasks.build(task_params).tap { |task| task.user = current_user }
    authorize! :create, @task

    if @task.save
      redirect_to project_tasks_url(@project), notice: "Task was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    authorize! :update, @task

    if @task.update(task_params)
      redirect_to project_tasks_url(@project), notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    authorize! :destroy, @task

    @task.destroy
    redirect_to project_tasks_url(@project), notice: "Task was successfully destroyed."
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_task
      @task = @project.tasks.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def task_params
      params.require(:task).permit(:title)
    end
end
