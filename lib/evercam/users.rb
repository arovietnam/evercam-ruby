# Copyright © 2014, Evercam.

module Evercam
   module Users
      # Fetch details for a specified user.
      #
      # ==== Parameters
      # user::    The Evercam user name or email address of the user to fetch
      #           the list of cameras for.
      def get_user(user)
         data = handle_response(call("/users/#{user}"))
         if !data.include?("users") || data["users"].size == 0
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["users"][0]
      end

      # Fetches a list of user cameras for a specified user.
      #
      # ==== Parameters
      # user::    The Evercam user name or email address of the user to fetch
      #           the list of cameras for.
      # shared::  A boolean to indicate if shared cameras should be included in
      #          the fetch. Defaults to false.
      def get_user_cameras(user, shared=false)
         data = handle_response(call("/users/#{user}/cameras", :get, include_shared: shared))
         if !data.include?("cameras")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["cameras"]
      end

      # Updates the details for a user.
      #
      # ==== Parameters
      # user::    The Evercam user name or email address of the user to be
      #           updated.
      # values::  A Hash of the values to be updated. Recognized keys in this
      #           Hash are :forename, :lastname, :username, :country and :email.
      def update_user(user, values={})
         handle_response(call("/users/#{user}", :patch, values)) if !values.empty?
         self
      end

      # This method deletes a user account and all details associated with it.
      #
      # ==== Parameters
      # user::    The Evercam user name or email address of the user to be
      #           deleted.
      def delete_user(user)
         handle_response(call("/users/#{user}", :delete))
         self
      end
   end
end