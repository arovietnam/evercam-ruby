# Copyright © 2016, Evercam.

module Evercam
  module Snapmails
    # This method attempts to retrieve the all snapmails for a specific user.
    #
    # ==== Parameters
    # camera_id::  The unique identifier for the camera to query.
    def get_archives()
      data = handle_response(call("/snapmails", :get))
      if !data.include?("snapmails")
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["snapmails"]
    end
  end
end