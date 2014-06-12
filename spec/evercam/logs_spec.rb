require 'data_helper'

describe 'Evercam::API Logs Methods' do
   let(:api) {
      Evercam::API.new(api_id: '123456', api_key: '1a2b3c4d5e6a7b8c9d0e')
   }

   describe '#get_logs' do
      it 'returns an hash when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/logs.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"logs": [], "pages": 10}', :headers => {})

         data = api.get_logs('test_camera')
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
         expect(data.include?(:logs)).to eq(true)
         expect(data.include?(:pages)).to eq(true)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/logs.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 400, :body => '{"message": "Its Broken"}', :headers => {})

         expect {api.get_logs('test_camera')}.to raise_error(Evercam::EvercamError,
                                                             "Its Broken")
      end

      it 'raises an exception when the API call does not contain data' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/logs.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_logs('test_camera')}.to raise_error(Evercam::EvercamError,
                                                             "Invalid response received from server.")
      end
   end
end