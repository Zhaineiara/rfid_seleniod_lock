class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    root_path  # Redirect to root which is admin/dashboard#index
  end

  def redirect_professor
    # Redirect /professor to appropriate location based on context
    redirect_to '/admin/professor'
  end
end
