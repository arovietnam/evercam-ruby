# Copyright © 2014, Evercam.

module Evercam
   class NullLogger < Logger
      def initialize(*args)
         super(*args)
      end

      def add(*args, &block)
      end
   end
end