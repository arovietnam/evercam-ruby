# Copyright © 2016, Evercam.

module Evercam
  module Snapmails
    # This method attempts to retrieve the all snapmails for a specific user.
    #
    # ==== Parameters
    # camera_id::  The unique identifier for the camera to query.
    def get_snapmails()
      data = handle_response(call("/snapmails", :get))
      if !data.include?("snapmails")
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["snapmails"]
    end

    # This method attempts to retrieve the snapmail for a specific snapmail-id.
    #
    # ==== Parameters
    # id::  The unique identifier for the snapmail to query.
    def get_snapmail(id)
      data = handle_response(call("/snapmails/#{id}", :get))
      if !data.include?("snapmails") || data["snapmails"].size == 0
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["snapmails"][0]
    end

    # This method creates a new snapmail in the system.
    #
    # ==== Parameters
    # subject::  Snapmail Subject.
    # camera_exids:: Camera exids you want to create snapmail for.
    # recipients:: Recipients address seperated by ','.
    # notify_days:: Notify Days (Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday).
    # notify_time:: Snapmail notify time like: 10:00.
    # values::   Optional values like: timezone, is_public, is_paused.
    def create_snapmail(subject, camera_exids, recipients, notify_days, notify_time, values={})
      parameters = {subject: subject, camera_exids: camera_exids,
                    recipients: recipients, notify_days: notify_days, notify_time: notify_time}.merge(values)
      data = handle_response(call("/snapmails", :post, parameters))
      if !data.include?("snapmails") || data["snapmails"].size == 0
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["snapmails"][0]
    end

    # This method update existing snapmail in the system.
    #
    # ==== Optional Parameters
    # id::  Snapmail exid.
    # values::   Optional values like: subject, camera_exids, recipients, notify_days, notify_time, timezone, is_public, is_paused.
    def update_snapmail(id, values={})
      handle_response(call("/snapmails/#{id}", :patch, values)) if !values.empty?
      self
    end

    # Delete a snapmail from the system.
    #
    # ==== Parameters
    # id::  The unique identifier of the snapmail to be deleted.
    def delete_snapmail(id)
      handle_response(call("/snapmails/#{id}", :delete))
      self
    end

    # This method unsubscribe user from snapmail.
    #
    # ==== Optional Parameters
    # id::  Snapmail exid.
    # values::   Optional values like: subject, camera_exids, recipients, notify_days, notify_time, timezone, is_public, is_paused.
    def unsubscribe_snapmail(id, email)
      handle_response(call("/snapmails/#{id}/unsubscribe/#{email}", :patch))
      self
    end
  end
end
