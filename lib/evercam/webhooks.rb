# Copyright © 2014, Evercam.

module Evercam
  module Webhooks

    # This method fetches details for all webhooks that belong to specific camera.
    #
    # ==== Parameters
    # camera_id::  The unique identifier of the camera to be queried for webhooks.
    def get_webhooks(camera_id)
      data = handle_response(call("/webhooks?id=#{camera_id}")) unless camera_id.nil?
      if !data.include?("webhooks")
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["webhooks"]
    end

    # This method attempts to retrieve the details for a specific webhook.
    #
    # ==== Parameters
    # webhook_id::  The unique identifier for the webhook to query.
    def get_webhook(webhook_id)
      data = handle_response(call("/webhooks/#{webhook_id}"))
      if !data.include?("webhooks") || data["webhooks"].size == 0
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["webhooks"][0]
    end

    # This method attempts to update the details associated with a camera.
    #
    # ==== Parameters
    # webhook_id::  The unique identifier of the camera to be updated.
    # url::         The url which will receive webhook data.
    def update_webhook(webhook_id, url)
      handle_response(call("/webhooks/#{webhook_id}", :patch, url)) unless url.nil?
      self
    end

    # Delete a webhook from the system.
    #
    # ==== Parameters
    # webhook_id::  The unique identifier of the webhook.
    def delete_webhook(webhook_id)
      # handle_response(call("/webhooks/#{webhook_id}", :delete))
      # self

      data = handle_response(call("/webhooks/#{webhook_id}", :delete))
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
    def create_webhook(id, url, user_id)
      parameters = {id: id,
                    url: url,
                    user_id: user_id}

      data = handle_response(call("/webhooks", :post, parameters))
      if !data.include?("webhooks") || data["webhooks"].size == 0
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["webhooks"][0]
    end
  end
end
