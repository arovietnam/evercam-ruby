# Copyright © 2014, Evercam.

module Evercam
  module Webhooks

    # This method fetches details for all webhooks that belong to specific camera.
    #
    # ==== Parameters
    # id::         The unique identifier of the webhook.
    # camera_id::  The unique identifier of the camera to be queried for webhooks.
    def get_webhooks(camera_id, id = nil)
      parameters = {camera_id: camera_id}
      parameters[:id] = id if id
      data = handle_response(call("/cameras/#{camera_id}/webhooks", :get, parameters)) unless camera_id.nil?
      if !data.include?("webhooks")
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["webhooks"]
    end

    # This method attempts to update the details associated with a camera.
    #
    # ==== Parameters
    # webhook_id::  The unique identifier of the camera to be updated.
    # url::         The url which will receive webhook data.
    def update_webhook(webhook_id, url)
      handle_response(call("/cameras/#{camera_id}/webhooks/#{webhook_id}", :patch, url)) unless url.nil?
      self
    end

    # Delete a webhook from the system.
    #
    # ==== Parameters
    # webhook_id::  The unique identifier of the webhook.
    def delete_webhook(camera_id, webhook_id)
      data = handle_response(call("/cameras/#{camera_id}/webhooks/#{webhook_id}", :delete))
      if !data.include?("webhooks") || data["webhooks"].size == 0
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["webhooks"][0]
    end

    # This method creates a new webhook.
    #
    # ==== Parameters
    # id::          The unique identifier of the camera.
    # url::         The url which will receive webhook data.
    # user_id::     The Evercam user name of the webhook owner.
    def create_webhook(camera_id, url, user_id)
      parameters = {camera_id: camera_id,
        url: url,
        user_id: user_id}

      data = handle_response(call("/cameras/#{camera_id}/webhooks", :post, parameters))
      if !data.include?("webhooks") || data["webhooks"].size == 0
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["webhooks"][0]
    end
  end
end
