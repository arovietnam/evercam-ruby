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
      #           Hash are :firstname, :lastname, :username, :country and :email.
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

      # This method creates a new user within the Evercam system.
      #
      # ==== Parameters
      # first_name::  The first name for the new user.
      # last_name::   The last name for the new user.
      # user_name::   The unique system user name for the new user.
      # email::       The email address for the new user.
      # password::    The new users password.
      # country::     The country for the new user.
      # key::         A share request key to be processed during the process
      #               of creating the new user account. Defaults to nil.
      def create_user(first_name, last_name, user_name, email, password, country, key=nil)
         parameters = {firstname: first_name,
                       lastname: last_name,
                       username: user_name,
                       country: country,
                       email: email,
                       password: password}
         parameters[:share_request_key] = key if !key.nil?
         data = handle_response(call("/users", :post, parameters))
         if !data.include?('users') || data['users'].empty?
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data['users'].first
      end
   end
end