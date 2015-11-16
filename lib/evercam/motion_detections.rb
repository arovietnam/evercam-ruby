# Copyright © 2014, Evercam.

module Evercam
  module MotionDetection
    def get_motion_detections(camera_id)
      data = handle_response(call("/cameras/#{camera_id}/apps/motion-detection", :get))
      if !data.include?("motion_detections")
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["motion_detections"].first
    end
  end
end
