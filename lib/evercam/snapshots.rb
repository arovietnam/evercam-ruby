# Copyright © 2014, Evercam.

module Evercam
   module Snapshots
      # This method fetches a Base64 encoded snapshot from a camera.
      #
      # ==== Parameters
      # camera_id::  The unique identifier for the camera to take the snapshot
      #              from.
      def get_live_image(camera_id)
         data = handle_response(call("/cameras/#{camera_id}/live"))
         if !data.include?("data")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["data"]
      end

      # This method returns details for all snapshots stored for a specified
      # camera.
      #
      # ==== Parameters
      # camera_id::  The unique identifier for the camera to list snapshots
      #              for.
      def get_snapshots(camera_id)
         data = handle_response(call("/cameras/#{camera_id}/snapshots"))
         if !data.include?("snapshots")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["snapshots"].inject([]) do |list, entry|
            entry["created_at"] = Time.at(entry["created_at"])
            list << entry
         end
      end

      # This method grabs a snapshot from a specified camera and stores it using
      # the current timestamp.
      #
      # ==== Parameters
      # camera_id::  The unique identifier for the camera to grab the snapshot
      #              from.
      # comment::    An optional comment to put on the newly created snapshot.
      #              Defaults to nil to indicate no comment.
      def store_snapshot(camera_id, comment=nil)
         parameters = {}
         parameters[:notes] = comment.to_s if !comment.nil?
         data = handle_response(call("/cameras/#{camera_id}/snapshots", :post, parameters))
         if !data.include?("snapshots") || data["snapshots"].size == 0
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["snapshots"].first["created_at"] = Time.at(data["snapshots"].first["created_at"])
         data["snapshots"].first
      end

      # This method fetches the most up-to-date snapshot for a specified camera
      # stored in the system.
      #
      # ==== Parameters
      # camera_id::  The unique identifier to fetch the snapshot for.
      # complete::   A flag to indicate whether the response should include the
      #              image data for the snapshot. Defaults to false.
      def get_latest_snapshot(camera_id, complete=false)
         parameters = {}
         parameters[:with_data] = true if complete == true
         data = handle_response(call("/cameras/#{camera_id}/snapshots/latest", :get, parameters))
         if !data.include?("snapshots") || data["snapshots"].size == 0
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["snapshots"].first["created_at"] = Time.at(data["snapshots"].first["created_at"])
         data["snapshots"].first
      end

      # This method fetches a list of snapshot stored in the system for a
      # specified camera between a stated start and end date.
      #
      # ==== Parameters
      # camera_id::  The unique identifier of the camera to fetch snapshots for.
      # from::       The date/time of the start of the range to fetch snapshots
      #              for.
      # to::         The date/time of the end of the range to fetch snapshots
      #              for.
      # options::    A Hash of the options to be given to the request. Keys
      #              recognised in this Hash are :with_data, :limit and
      #              :page.
      def get_snapshots_in_date_range(camera_id, from, to, options={})
         parameters = {from: from.to_i, to: to.to_i, with_data: (options[:with_data] == true)}
         if options.include?(:limit)
            parameters[:limit] = options[:limit]
         else
            parameters[:limit] = (options[:with_data] ? 10 : 100)
         end
         parameters[:page] = options[:page] if options.include?(:page)
         data = handle_response(call("/cameras/#{camera_id}/snapshots/range", :get, parameters))
         if !data.include?("snapshots")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["snapshots"].inject([]) do |list, entry|
            entry["created_at"] = Time.at(entry["created_at"])
            list << entry
         end
      end

      # This method returns a list of dates for which stored snapshots are
      # available on a specified camera given a specific month and year.
      #
      # ==== Parameters
      # camera_id::  The unique identifier of the camera to perform the check
      #              for.
      # month::      The month of the year, as an integer, to perform the
      #              check for. Defaults to nil to indicate the current
      #              month.
      # year::       The year to perform the check for. Defaults to nil to
      #              indicate the current year.
      def get_snapshot_dates(camera_id, month=nil, year=nil)
         month = (month || Time.now.month)
         year  = (year || Time.now.year)
         data  = handle_response(call("/cameras/#{camera_id}/snapshots/#{year}/#{month}/days"))
         if !data.include?("days")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["days"].inject([]) {|list, entry| list << Time.local(year, month, entry)}
      end

      # This method retrieves a list of Time objects for a specified camera for
      # which their are snapshots stored in the system. The Time objects
      # returned aren't specific snapshot timestamps but are used to indicate
      # the hours during the day for which snapshots are available.
      #
      # ==== Parameters
      # camera_id::  The unique identifier of the camera to fetch the snapshot
      #              details for.
      # date::       The day to perfom this check for. The time part of this
      #              value is not taken into consideration. Defaults to the
      #              current date.
      def get_snapshots_by_hour(camera_id, date=Time.now)
         data = handle_response(call("/cameras/#{camera_id}/snapshots/#{date.year}/#{date.month}/#{date.day}/hours"))
         if !data.include?("hours")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["hours"].inject([]) {|list, entry| list << Time.local(date.year, date.month, date.day, entry)}
      end

      # This method fetches a snapshot for a given timestamp.
      #
      # ==== Parameters
      # camera_id::  The unique identifier for the camera that generated the
      #              snapshot.
      # timestamp::  The timestamp of the snapshot to retrieve.
      # options::    A Hash of optional settings for the request. Keys
      #              recognised in this Hash are :with_data and :range.
      def get_snapshot_at(camera_id, timestamp, options={})
         parameters = {with_data: (options[:with_data] == true)}
         parameters[:range] = options[:range] if options.include?(:range)
         data = handle_response(call("/cameras/#{camera_id}/snapshots/#{timestamp.to_i}",
                                     :get, parameters))
         if !data.include?("snapshots") || data["snapshots"].size == 0
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["snapshots"].first["created_at"] = Time.at(data["snapshots"].first["created_at"])
         data["snapshots"].first
      end

      # This method deletes a snapshot from the system.
      #
      # ==== Parameters
      # camera_id::  The unique identifier of the camera that the snapshot
      #              is stored under.
      # timestamp::  The timestamp of the snapshot to be deleted.
      def delete_snapshot(camera_id, timestamp)
         data = handle_response(call("/cameras/#{camera_id}/snapshots/#{timestamp.to_i}", :delete))
         self
      end

      # This method takes a snapshot from a specified camera and returns
      # it's details. Note that the method, when successful, returns a String
      # containing the raw image data.
      #
      # ==== Parameters
      # camera_id::  The unique identifier for the camera to get the snapshot
      #              from.
      def get_snapshot(camera_id)
         handle_raw(call("/cameras/#{camera_id}/snapshot.jpg"))
      end
   end
end