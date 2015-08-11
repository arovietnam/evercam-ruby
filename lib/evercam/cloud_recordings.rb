# Copyright © 2014, Evercam.

module Evercam
  module CloudRecording
    def get_cloud_recordings(camera_id)
      data = handle_response(call("/cameras/#{camera_id}/apps/cloud-recording", :get))
      if !data.include?("cloud_recordings")
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["cloud_recordings"].first
    end
  end
end
