# Copyright © 2014, Evercam.

module Evercam
   # This is the base error class for exceptions generated within the Evercam
   # library.
   class EvercamError < StandardError
      # Constructor for the EvercamError class.
      #
      # ==== Parameters
      # message::   A String containing the error message for the exception.
      # code::      The error code associated with the exception if one is
      #             available. Defaults to nil.
      # status::    The HTTP status code associated with the exception if one
      #             is available. Defaults to nil.
      # *context::  A collection of contextual data associated with the
      #             exception.
      def initialize(message, code=nil, status=nil, *context)
         super(message)
         @code    = code
         @status  = status
         @context = context
      end

      attr_reader :status, :context

      def code
         (@code || "unknown_error")
      end
   end
end