# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @_current_user ||=
      if session[:current_user_id].present?
        User.where(id: session[:current_user_id]).first
      else
        nil
      end
  end

  def require_signed_in
    unless current_user
      redirect_to users_url
    end
  end
end
