# Copyright © 2014, Evercam.

module Evercam
   module Logs
      # This method fetches activity log details for a specified camera from
      # the system.
      #
      # ==== Parameters
      # camera_id::  The unique identifier of the camera to fetch the logs for.
      # options::    A Hash of additional parameters for the request. Currently
      #              recognised keys for this request are :from, :to, :limit,
      #              :page, :types and :objects.
      def get_logs(camera_id, options={})
         parameters = {}
         parameters[:from] = options[:from].to_i if options.include?(:from)
         parameters[:to] = options[:to].to_i if options.include?(:to)
         parameters[:limit] = options[:limit] if options.include?(:limit)
         parameters[:page] = options[:page] if options.include?(:page)
         if options.include?(:types)
            values = options[:types]
            if values.kind_of?(Array)
               parameters[:types] = options[:types].join(",")
            else
               parameters[:types] = options[:types]
            end
         end
         parameters[:objects] = (options[:objects] == true) if options.include?(:objects)
         data = handle_response(call("/cameras/#{camera_id}/logs", :get, parameters))
         if !data.include?("logs")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["logs"]
      end
   end
end