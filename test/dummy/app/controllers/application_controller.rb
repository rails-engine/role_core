# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  private

    def current_user
      if session[:current_user_id].present?
        @_current_user ||=
          User.where(id: session[:current_user_id]).first
      end
    end

    def require_signed_in
      redirect_to users_url unless current_user
    end
end
