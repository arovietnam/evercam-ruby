# Copyright © 2014, Evercam.

module Evercam
  module Archives
    # This method attempts to retrieve the archives for a specific camera.
    #
    # ==== Parameters
    # camera_id::  The unique identifier for the camera to query.
    def get_archives(camera_id)
      data = handle_response(call("/cameras/#{camera_id}/archives", :get))
      if !data.include?("archives")
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["archives"]
    end

    # This method attempts to retrieve the archive for a specific camera and archive-id.
    #
    # ==== Parameters
    # camera_id::  The unique identifier for the camera to query.
    # archive_id::  The unique identifier for the archive to query.
    def get_archive(camera_id, archive_id)
      data = handle_response(call("/cameras/#{camera_id}/archives/#{archive_id}", :get))
      if !data.include?("archives") || data["archives"].size == 0
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["archives"][0]
    end

    # Delete a archive from the system.
    #
    # ==== Parameters
    # camera_id::  The unique identifier of the camera to be deleted.
    # archive_id::  The unique identifier for the archive to delete.
    def delete_archive(camera_id, archive_id)
      handle_response(call("/cameras/#{camera_id}/archives/#{archive_id}", :delete))
      self
    end

    # This method creates a new camera in the system.
    #
    # ==== Parameters
    # camera_id::  The unique identifier of the camera.
    # title::       The name for the new Archive.
    # from_date::    Archive start date.
    # to_date::      Archive end date.
    # requested_by:: The unique identifier of the user who requested archive.
    # embed_time::   Add DateTime overlay on archive.
    # public::       To make archive available publically or not.
    def create_archive(camera_id, title, from_date, to_date, requested_by, embed_time=nil, public=nil)
      parameters = {title: title, from_date: from_date,
                    to_date: to_date, requested_by: requested_by}
      parameters[:embed_time] = embed_time if !embed_time.nil?
      parameters[:public] = public if !public.nil?
      data = handle_response(call("/cameras#{camera_id}/archives", :post, parameters))
      if !data.include?("archives") || data["archives"].size == 0
        message = "Invalid response received from server."
        @logger.error message
        raise EvercamError.new(message)
      end
      data["archives"][0]
    end

    # This method creates a new camera in the system.
    #
    # ==== Parameters
    # camera_id::  The unique identifier of the camera.
    # title::       The name for the new Archive.
    # from_date::    Archive start date.
    # to_date::      Archive end date.
    # requested_by:: The unique identifier of the user who requested archive.
    # embed_time::   Add DateTime overlay on archive.
    # public::       To make archive available publically or not.
    def update_archive(camera_id, archive_id, values={})
      handle_response(call("/cameras#{camera_id}/archives/#{archive_id}", :patch, values)) if !values.empty?
      self
    end
  end
end