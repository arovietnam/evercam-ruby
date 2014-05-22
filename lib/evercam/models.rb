# Copyright © 2014, Evercam.

module Evercam
   module Models
      # This method fetches a list of all models support within Evercam.
      def get_all_models
         data = handle_response(call("/models"))
         if !data.include?("vendors")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["vendors"]
      end

      # This method fetches a list of models for a specified vendor.
      #
      # ==== Parameters
      # vendor::  The unique identifier for the vendor to fetch the list of
      #           models for.
      def get_vendor_models(vendor)
         data = handle_response(call("/models/#{vendor}"))
         if !data.include?("vendors") || data["vendors"].empty?
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["vendors"].first
      end

      # This method fetches details for a specific model for a given vendor.
      #
      # ==== Parameters
      # vendor::  The unique identifier for the vendor who owns the model.
      # model::   The unique identifier for the model to fetch.
      def get_vendor_model(vendor, model)
         data = handle_response(call("/models/#{vendor}/#{model}"))
         if !data.include?("models") || data["models"].empty?
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["models"].first
      end
   end
end
