# Copyright © 2014, Evercam.

module Evercam
   module Apps
      def get_apps(camera_id)
         data = handle_response(call("/cameras/#{camera_id}/apps", :get))
         if !data.include?("apps")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["apps"].first
      end
   end
end
