class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_user_id, :authenticate_user

  def authenticate_user
    return session.delete(:current_user) unless current_user_id
    if !session[:current_user] || session[:current_user]['id'] != current_user_id
      @current_user = session[:current_user] = User.from_hull_user(current_user_id)
    else
      @current_user = session[:current_user]
    end
    if @current_user
      @github_user  = @current_user['identities'].select { |i| i['provider'] == 'github' }.first
    end
  end

  def current_user_id
    @current_user_id ||= Hull.authenticate_user(request.env)
    Rails.logger.info "Current User: #{@current_user_id}"
    @current_user_id
  end

end
