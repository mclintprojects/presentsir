class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
    
    def pusher_channel_name
        "present-sir"
    end
end
