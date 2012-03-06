require 'action_controller/metal/renderers'
require 'action_controller/metal/responder'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
end


