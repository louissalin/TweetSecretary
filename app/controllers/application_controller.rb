require 'action_controller/metal/renderers'
require 'action_controller/metal/responder'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
end

ActionController::Renderers.add(:v1_json) do |obj, options|
    self.content_type ||= Mime::Type.lookup('application/vnd.tweetsecretary-v1+json')

    body = '{'
    if options[:error] != nil
        error = options[:error]
        error = error.to_json unless error.respond_to?(:to_str)

        body += '"error":' + error + ','
    end

    content = '"nil"'
    if obj != nil
        content = obj.to_v1.to_json
    end

    body += '"content":' + content
    body += '}'
    
    self.response_body = body 
end
