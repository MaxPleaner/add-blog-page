class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_instance_variables
  def set_instance_variables
    @sites = []
  end
end
