# Copyright © 2014, Evercam.

module Evercam
   module Shares
      # Fetches details for the camera share for a specific camera and user.
      #
      # ==== Parameters
      # camera_id::  The unique identifier of the camera that was shared.
      # user_id::    Either the user name or email address of the user that the
      #              camera was shared with.
      def get_camera_share(camera_id, user_id)
         data = handle_response(call("/shares", :get, camera_id: camera_id, user_id: user_id))
         if !data.include?("shares")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["shares"].first
      end

      # This method fetches a list of shares for a specified camera.
      #
      # ==== Parameters
      # camera_id::  The unique identifier of the camera to produce the list of
      #              shares for.
      def get_camera_shares(camera_id)
         data = handle_response(call("/shares/cameras/#{camera_id}"))
         if !data.include?("shares")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["shares"]
      end

      # This method shares an existing camera with an email address. If the
      # email address ties to an Evercam user account then a share is created
      # for the account. If this is not the case then an email is dispatched
      # to invite the user to come join Evercam and make use of the camera
      # shared with them.
      #
      # ==== Parameters
      # camera_id::  The unique identifier for the camera being shared.
      # email::      The email address of the individual to share the camera
      #              with.
      # rights::     Either a String indicating the rights to be granted
      #              to the user as a comma separated list or an Array of
      #              Strings containing the name of the rights to be granted
      #              with the share.
      # options::    A Hash of addition parameters to the request. Currently
      #              recognised keys within this Hash are :grantor, :message
      #              and :notify.
      def share_camera(camera_id, email, rights, options={})
         parameters = {email: email}
         parameters[:rights] = (rights.kind_of?(String) ? rights : rights.join(","))
         parameters[:grantor] = options[:grantor] if options.include?(:grantor)
         parameters[:message] = options[:message] if options.include?(:message)
         parameters[:notify] = (options[:notify] == true) if options.include?(:notify)
         data = handle_response(call("/shares/cameras/#{camera_id}", :post, parameters))

         output = nil
         if data.include?("shares")
            if !data["shares"].empty?
               output = data["shares"].first
               output["type"] = "share"
            end
         elsif data.include?("share_requests")
            if !data["share_requests"].empty?
               output = data["share_requests"].first
               output["type"] = "share_request"
            end
         end

         if output.nil?
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         output
      end

      # This method deletes an existing camera share.
      #
      # ==== Parameters
      # camera_id::  The unique identifier for the camera that was shared.
      # share_id::   The unique identifier of the share that is being deleted.
      def delete_camera_share(camera_id, share_id)
         handle_response(call("/shares/cameras/#{camera_id}", :delete, share_id: share_id))
         self
      end

      # This method updates the settings on a camera share, altering the right
      # available to the user that the camera was shared with.
      #
      # ==== Parameters
      # share_id::  The unique identifier of the camera share to be updated.
      # rights::    Either an array of right name strings or a single string
      #             consisting of a comma separated array of right names.
      def update_camera_share(share_id, rights)
         parameters = {rights: (rights.kind_of?(String) ? rights : rights.join(","))}
         handle_response(call("/shares/cameras/#{share_id}", :patch, parameters))
         self
      end

      # Fetches a list of the camera shares currently available to a specified
      # user.
      #
      # ==== Parameters
      # user_id::  The unique identifier of the user to fetch the list of shares
      #            for.
      def get_user_camera_shares(user_id)
         data = handle_response(call("/shares/users/#{user_id}"))
         if !data.include?("shares")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["shares"]
      end

      # This method fetches a list of share requests pending on a specified
      # camera.
      #
      # ==== Parameters
      # camera_id::  The unique identifier for the camera to fetch the list
      #              of pending share requests for.
      # status::     The status of the camera share requests to be retrieved.
      #              This should be either 'PENDING', 'USED' or 'CANCELLED'.
      #              Defaults to nil to indicate no particular status is
      #              being requested.
      def get_camera_share_requests(camera_id, status=nil)
         parameters = {}
         parameters[:status] = status if !status.nil?
         data = handle_response(call("/shares/requests/#{camera_id}", :get, parameters))
         if !data.include?("share_requests")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["share_requests"]
      end

      # This method is used to cancel a pending camera share request.
      #
      # ==== Parameters
      # request_id::  The unique identifier of the share request to be
      #               cancelled.
      # email::       The email address associated with the share request
      #               being cancelled.
      def cancel_camera_share_request(request_id, email)
         handle_response(call("/shares/requests/#{request_id}", :delete, email: email))
         self
      end

      # This method updates the rights to be granted when a pending camera share
      # request is accepted.
      #
      # ==== Parameters
      # request_id::  The unique identifier of the share request to be
      #               updated.
      # rights::      Either an array of right name strings or a string
      #               containing a comma separated list of right names.
      def update_camera_share_request(request_id, rights)
         parameters = {rights: (rights.kind_of?(String) ? rights : rights.join(","))}
         handle_response(call("/shares/requests/#{request_id}", :patch, parameters))
         self
      end
   end
end
