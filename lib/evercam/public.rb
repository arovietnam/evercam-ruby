# Copyright © 2014, Evercam.

module Evercam
   module Public
      # This method fetches a list of public and discoverable cameras from
      # with Evercam.
      #
      # ==== Parameters
      # critera::  A Hash of search criteria to use for the list returned
      #            by the request. Currently recognised options include
      #            :case_sensitive, :id_starts_with, :id_ends_with,
      #            :id_contains, :offset and :limit.
      def get_public_cameras(criteria={})
         data = handle_response(call("/public/cameras", :get, criteria))
         if !data.include?("cameras")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         {cameras: data["cameras"], pages: data["pages"]}
      end
   end
end