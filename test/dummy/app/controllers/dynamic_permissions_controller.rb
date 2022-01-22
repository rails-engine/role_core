# frozen_string_literal: true

class DynamicPermissionsController < ApplicationController
  before_action :set_dynamic_permission, only: %i[edit update destroy]

  # GET /dynamic_permissions
  def index
    @dynamic_permissions = DynamicPermission.all
  end

  # GET /dynamic_permissions/new
  def new
    @dynamic_permission = DynamicPermission.new
  end

  # GET /dynamic_permissions/1/edit
  def edit
  end

  # POST /dynamic_permissions
  def create
    @dynamic_permission = DynamicPermission.new(dynamic_permission_params)

    if @dynamic_permission.save
      redirect_to dynamic_permissions_url, notice: "Dynamic permission was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dynamic_permissions/1
  def update
    if @dynamic_permission.update(dynamic_permission_params)
      redirect_to dynamic_permissions_url, notice: "Dynamic permission was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /dynamic_permissions/1
  def destroy
    @dynamic_permission.destroy
    redirect_to dynamic_permissions_url, notice: "Dynamic permission was successfully destroyed."
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_dynamic_permission
      @dynamic_permission = DynamicPermission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dynamic_permission_params
      params.require(:dynamic_permission).permit(:name, :key, :default)
    end
end
