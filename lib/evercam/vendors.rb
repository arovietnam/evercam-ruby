# Copyright © 2014, Evercam.

module Evercam
   module Vendors
      # This method returns a list of all vendors in Evercam.
      def get_all_vendors
         data = handle_response(call("/vendors"))
         if !data.include?("vendors")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["vendors"]
      end

      # This method returns a list of vendors that match a specified MAC
      # address prefix.
      #
      # ==== Parameters
      # mac_prefix::  The MAC address prefix to use in the vendor search.
      def get_vendors_by_mac(mac_prefix)
         data = handle_response(call("/vendors/#{mac_prefix}"))
         if !data.include?("vendors")
            message = "Invalid response received from server."
            @logger.error message
            raise EvercamError.new(message)
         end
         data["vendors"]
      end
   end
end
