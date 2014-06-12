require 'data_helper'

describe Evercam::EvercamError do
   describe 'object creation' do
      it 'accepts just a message parameter' do
         exception = Evercam::EvercamError.new("This is the message.")
         expect(exception.message).to eq("This is the message.")
         expect(exception.code).to eq("unknown_error")
         expect(exception.status).to be_nil
         expect(exception.context).to eq([])
      end

      it 'accepts message and code parameters' do
         exception = Evercam::EvercamError.new("This is the message.", "test_code")
         expect(exception.message).to eq("This is the message.")
         expect(exception.code).to eq("test_code")
         expect(exception.status).to be_nil
         expect(exception.context).to eq([])
      end

      it 'accepts message, code and status parameters' do
         exception = Evercam::EvercamError.new("This is the message.", "test_code", 400)
         expect(exception.message).to eq("This is the message.")
         expect(exception.code).to eq("test_code")
         expect(exception.status).to eq(400)
         expect(exception.context).to eq([])
      end

      it 'accepts message, code, status and context parameters' do
         exception = Evercam::EvercamError.new("This is the message.", "test_code", 400, "one", 2, "THREE")
         expect(exception.message).to eq("This is the message.")
         expect(exception.code).to eq("test_code")
         expect(exception.status).to eq(400)
         expect(exception.context).to eq(["one", 2, "THREE"])
      end
   end
end