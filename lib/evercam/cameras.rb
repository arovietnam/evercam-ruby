# Copyright © 2014, Evercam.

module Evercam
  module Cameras
    # Test whether a given set of camera parameters are correct.
    #
    # ==== Parameters
    # external_url::  The external URL of the camera to be tested.
    # jpg_url::       The JPEG URL of the camera to be tested.
    # user_name::     The camera user name to be used in the test.
    # password::      The camera password to be used in the test.
    def test_camera(external_url, jpg_url, user_name, password)
      parameters = {external_url: external_url,
                    jpg_url: jpg_url,
                    cam_username: user_name,
                    cam_password: password}
      handle_response(call("/cameras/test", :get, parameters))
    end

    # This method attempts to retrieve the details for a specific camera.
    #
    # ==== Parameters
    # camera_id::  The unique identifier for the camera to query.
    # thumbnail::  A boolean to indicate if thumbnail should be included in
    #          the fetch. Defaults to false.
    def get_camera(camera_id, thumbnail=false)
      data = handle_response(call("/cameras/#{camera_id}", :get, thumbnail: thumbnail))
      if !data.include?("cameras") || data["cameras"].size == 0
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["cameras"][0]
    end

    # This method attempts to update the details associated with a camera.
    #
    # ==== Parameters
    # camera_id::  The unique identifier of the camera to be updated.
    # values::     A Hash of the values to be set. Keys recognosed in this
    #              parameter include :name, :is_public, :external_host,
    #              :internal_host, :external_http_port, :internal_http_port,
    #              :external_rtsp_port, :internal_rtsp_port, :jpg_url,
    #              :cam_username and :cam_password - all other parameters
    #              will be ignored.
    def update_camera(camera_id, values={})
      handle_response(call("/cameras/#{camera_id}", :patch, values)) if !values.empty?
      self
    end

    # Delete a camera from the system.
    #
    # ==== Parameters
    # camera_id::  The unique identifier of the camera to be deleted.
    def delete_camera(camera_id)
      handle_response(call("/cameras/#{camera_id}", :delete))
      self
    end

    # This method fetches details for a set of cameras based on their unique
    # identifiers.
    #
    # ==== Parameters
    # camera_ids::  A collection of 1 or more camera ids for the cameras to
    #               fetch details for.
    def get_cameras(*camera_ids)
      data = handle_response(call("", :get, {ids: camera_ids.join(",")})) if !camera_ids.empty?
      if !data.include?("cameras")
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["cameras"]
    end

    # This method creates a new camera in the system.
    #
    # ==== Parameters
    # camera_id::  The unique identifier to be assigned to the new camera.
    # name::       The name for the new camera.
    # is_public::  A boolean to indicate whether the new camera is public.
    # values::     A Hash of additional settings for the camera. The following
    #              keys are recognised :external_host, internal_host,
    #              :external_http_port, :internal_http_port,
    #              :external_rtsp_port, :internal_rtsp_port, :jpg_url,
    #              :cam_username and :cam_password.
    def create_camera(camera_id, name, is_public, values={})
      parameters = {id: camera_id,
                    name: name,
                    is_public: is_public}.merge(values)
      data = handle_response(call("/cameras", :post, parameters))
      if !data.include?("cameras") || data["cameras"].size == 0
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["cameras"][0]
    end

    # This method changes the owner of a camera. You must be the owner of the
    # camera to call this method and all artifacts relating to the camera
    # transfer ownership when the camera does.
    #
    # ==== Parameters
    # camera_id::  The unique identifier of the camera to be transferred.
    # user_id:     The Evercam user name or email address of the new owner for
    #              the camera.
    def change_camera_owner(camera_id, user_id)
      data = handle_response(call("/cameras/#{camera_id}", :put, {user_id: user_id}))
      if !data.include?("cameras") || data["cameras"].empty?
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["cameras"].first
    end
  end
end