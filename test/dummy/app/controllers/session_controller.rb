# frozen_string_literal: true

class SessionController < ApplicationController
  def sign_in_as
    session[:current_user_id] = params[:id]
    redirect_to projects_url
  end

  def sign_out
    session[:current_user_id] = nil
    redirect_to users_url
  end
end
