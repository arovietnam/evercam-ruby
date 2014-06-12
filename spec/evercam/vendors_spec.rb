require 'data_helper'

describe 'Evercam::API Logs Methods' do
   let(:api) {
      Evercam::API.new(api_id: '123456', api_key: '1a2b3c4d5e6a7b8c9d0e')
   }

   describe '#get_all_vendors' do
      it 'returns an array when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/vendors.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"vendors": []}', :headers => {})

         data = api.get_all_vendors
         expect(data).not_to be_nil
         expect(data.class).to eq(Array)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/vendors.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 400, :body => '{"message": "Failed"}', :headers => {})

         expect {api.get_all_vendors}.to raise_error(Evercam::EvercamError,
                                                     "Failed")
      end

      it 'raises an exception when the API call response contains no data' do
         stub_request(:get, "https://api.evercam.io/v1/vendors.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_all_vendors}.to raise_error(Evercam::EvercamError,
                                                     "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_vendors_by_mac' do
      it 'returns an array when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/vendors/38:ad:24.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"vendors": []}', :headers => {})

         data = api.get_vendors_by_mac('38:ad:24')
         expect(data).not_to be_nil
         expect(data.class).to eq(Array)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/vendors/38:ad:24.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"message": "Failed"}', :headers => {})

         expect {api.get_vendors_by_mac('38:ad:24')}.to raise_error(Evercam::EvercamError,
                                                                    "Failed")
      end

      it 'raises an exception when the API call response contains no data' do
         stub_request(:get, "https://api.evercam.io/v1/vendors/38:ad:24.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_vendors_by_mac('38:ad:24')}.to raise_error(Evercam::EvercamError,
                                                                    "Invalid response received from server.")
      end
   end
end
