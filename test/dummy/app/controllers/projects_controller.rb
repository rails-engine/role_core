# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :require_signed_in
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/new
  def new
    @project = Project.new
    authorize! :create, @project
  end

  # GET /projects/1/edit
  def edit
    authorize! :update, @project
  end

  # POST /projects
  def create
    @project = Project.new(project_params).tap { |project| project.user = current_user }
    authorize! :create, @project

    if @project.save
      redirect_to projects_url, notice: "Project was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    authorize! :update, @project

    if @project.update(project_params)
      redirect_to projects_url, notice: "Project was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    authorize! :destroy, @project

    @project.destroy
    redirect_to projects_url, notice: "Project was successfully destroyed."
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:title, :is_public)
    end
end
