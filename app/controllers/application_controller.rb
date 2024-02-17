class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: Rails.application.credentials.dig(:login, :username), password: Rails.application.credentials.dig(:login, :password), except: :up

  def up
  end
end
