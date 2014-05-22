require 'data_helper'

describe 'Evercam::API Models Methods' do
   let(:api) {
      Evercam::API.new(api_id: '123456', api_key: '1a2b3c4d5e6a7b8c9d0e')
   }

   describe '#get_all_models' do
      it 'returns an array when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/models.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"vendors": []}', :headers => {})

         data = api.get_all_models
         expect(data).not_to be_nil
         expect(data.class).to eq(Array)
      end

      it 'raises an exception when the API call returns error' do
         stub_request(:get, "https://api.evercam.io/v1/models.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 400, :body => '{"message": "Crash bang wallop!"}', :headers => {})

         expect {api.get_all_models}.to raise_error(Evercam::EvercamError,
                                                    "Evercam API call returned an error. Message: Crash bang wallop!")
      end

      it 'raises an exception when the API call response contains no data' do
         stub_request(:get, "https://api.evercam.io/v1/models.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_all_models}.to raise_error(Evercam::EvercamError,
                                                    "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_vendor_models' do
      it 'returns a hash when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/models/test_vendor.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"vendors": [{}]}', :headers => {})

         data = api.get_vendor_models('test_vendor')
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/models/test_vendor.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"message": "Crash bang wallop!"}', :headers => {})

         expect {api.get_vendor_models('test_vendor')}.to raise_error(Evercam::EvercamError,
                                                                      "Evercam API call returned an error. Message: Crash bang wallop!")
      end

      it 'raises an exception when the API call response contains no data' do
         stub_request(:get, "https://api.evercam.io/v1/models/test_vendor.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"vendors": []}', :headers => {})

         expect {api.get_vendor_models('test_vendor')}.to raise_error(Evercam::EvercamError,
                                                                      "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_vendor_model' do
      it 'returns a hash when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/models/test_vendor/test_model.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"models": [{}]}', :headers => {})

         data = api.get_vendor_model('test_vendor', 'test_model')
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/models/test_vendor/test_model.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"message": "Crash bang wallop!"}', :headers => {})

         expect {api.get_vendor_model('test_vendor', 'test_model')}.to raise_error(Evercam::EvercamError,
                                                                                   "Evercam API call returned an error. Message: Crash bang wallop!")
      end

      it 'raises an exception when the API call response contains no data' do
         stub_request(:get, "https://api.evercam.io/v1/models/test_vendor/test_model.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"models": []}', :headers => {})

         expect {api.get_vendor_model('test_vendor', 'test_model')}.to raise_error(Evercam::EvercamError,
                                                                                   "Invalid response received from server.")
      end
   end
end