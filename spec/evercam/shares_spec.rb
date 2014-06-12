require 'data_helper'

describe 'Evercam::API Logs Methods' do
   let(:api) {
      Evercam::API.new(api_id: '123456', api_key: '1a2b3c4d5e6a7b8c9d0e')
   }

   describe '#get_camera_share' do
      it 'returns a hash when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/shares.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&camera_id=test_camera&user_id=test_user").
            to_return(:status => 200, :body => '{"shares": [{}]}', :headers => {})

         data = api.get_camera_share('test_camera', 'test_user')
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'it raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/shares.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&camera_id=test_camera&user_id=test_user").
            to_return(:status => 400, :body => '{"message": "Failed"}', :headers => {})

         expect {api.get_camera_share('test_camera', 'test_user')}.to raise_error(Evercam::EvercamError,
                                                                           "Failed")
      end

      it 'it raises an exception when the API call response contains no data' do
         stub_request(:get, "https://api.evercam.io/v1/shares.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&camera_id=test_camera&user_id=test_user").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_camera_share('test_camera', 'test_user')}.to raise_error(Evercam::EvercamError,
                                                                           "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_camera_shares' do
      it 'returns an array when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/shares/cameras/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"shares": []}', :headers => {})

         data = api.get_camera_shares('test_camera')
         expect(data).not_to be_nil
         expect(data.class).to eq(Array)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/shares/cameras/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 400, :body => '{"message": "Failed"}', :headers => {})

         expect {api.get_camera_shares('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                      "Failed")
      end

      it 'raises an exception when the API call response contains no data' do
         stub_request(:get, "https://api.evercam.io/v1/shares/cameras/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_camera_shares('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                      "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#share_camera' do
      it 'returns hash when the API call returns success and contains a share' do
         stub_request(:post, "https://api.evercam.io/v1/shares/cameras/test_camera.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&email=jbloggs%40nowhere.com&rights=list%2Csnapshot").
            to_return(:status => 200, :body => '{"shares": [{}]}', :headers => {})

         data = api.share_camera('test_camera', 'jbloggs@nowhere.com', "list,snapshot")
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
         expect(data.include?("type")).to eq(true)
         expect(data["type"]).to eq("share")
      end

      it 'returns hash when the API call returns success and contains a share request' do
         stub_request(:post, "https://api.evercam.io/v1/shares/cameras/test_camera.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&email=jbloggs%40nowhere.com&rights=list%2Csnapshot").
            to_return(:status => 200, :body => '{"share_requests": [{}]}', :headers => {})

         data = api.share_camera('test_camera', 'jbloggs@nowhere.com', "list,snapshot")
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
         expect(data.include?("type")).to eq(true)
         expect(data["type"]).to eq("share_request")
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:post, "https://api.evercam.io/v1/shares/cameras/test_camera.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&email=jbloggs%40nowhere.com&rights=list%2Csnapshot").
            to_return(:status => 400, :body => '{"message": "Failed"}', :headers => {})

         expect {api.share_camera('test_camera', 'jbloggs@nowhere.com', "list,snapshot")}.to raise_error(Evercam::EvercamError,
                                                                                                         "Failed")
      end

      it 'raises an exception when the API call response contains no data' do
         stub_request(:post, "https://api.evercam.io/v1/shares/cameras/test_camera.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&email=jbloggs%40nowhere.com&rights=list%2Csnapshot").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.share_camera('test_camera', 'jbloggs@nowhere.com', "list,snapshot")}.to raise_error(Evercam::EvercamError,
                                                                                                         "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#delete_camera_share' do
      it 'returns a reference to the API object when the API call returns success' do
         stub_request(:delete, "https://api.evercam.io/v1/shares/cameras/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&share_id=200").
            to_return(:status => 200, :body => "", :headers => {})

         data = api.delete_camera_share('test_camera', 200)
         expect(data).not_to be_nil
         expect(data).to eq(api)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:delete, "https://api.evercam.io/v1/shares/cameras/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&share_id=200").
            to_return(:status => 400, :body => '{"message": "Failed"}', :headers => {})

         expect {api.delete_camera_share('test_camera', 200)}.to raise_error(Evercam::EvercamError,
                                                                             "Failed")
      end
   end

   #----------------------------------------------------------------------------

   describe '#update_camera_share' do
      it 'returns a reference to the API object when the API call returns success' do
         stub_request(:patch, "https://api.evercam.io/v1/shares/cameras/200.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&rights=list%2Cview%2Cedit").
            to_return(:status => 200, :body => "", :headers => {})

         data = api.update_camera_share(200, ["list", "view", "edit"])
         expect(data).not_to be_nil
         expect(data).to eq(api)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:patch, "https://api.evercam.io/v1/shares/cameras/200.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&rights=list%2Cview%2Cedit").
            to_return(:status => 400, :body => '{"message": "Failed"}', :headers => {})

         expect {api.update_camera_share(200, "list,view,edit")}.to raise_error(Evercam::EvercamError,
                                                                                "Failed")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_user_camera_shares' do
      it 'returns an array when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/shares/users/test_user.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"shares": []}', :headers => {})

         data = api.get_user_camera_shares('test_user')
         expect(data).not_to be_nil
         expect(data.class).to eq(Array)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/shares/users/test_user.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 400, :body => '{"message": "Failed"}', :headers => {})

         expect {api.get_user_camera_shares('test_user')}.to raise_error(Evercam::EvercamError,
                                                                         "Failed")
      end

      it 'raises an exception when the API call response contains no data' do
         stub_request(:get, "https://api.evercam.io/v1/shares/users/test_user.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_user_camera_shares('test_user')}.to raise_error(Evercam::EvercamError,
                                                                         "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_camera_share_requests' do
      it 'returns an array when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/shares/requests/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"share_requests": []}', :headers => {})

         data = api.get_camera_share_requests('test_camera')
         expect(data).not_to be_nil
         expect(data.class).to eq(Array)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/shares/requests/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 400, :body => '{"message": "Failed"}', :headers => {})

         expect {api.get_camera_share_requests('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                              "Failed")
      end

      it 'raises an exception when the API call response contains no data' do
         stub_request(:get, "https://api.evercam.io/v1/shares/requests/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_camera_share_requests('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                              "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#cancel_camera_share_request' do
      it 'returns a reference to the API object when the API call returns success' do
         stub_request(:delete, "https://api.evercam.io/v1/shares/requests/test_request_id.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&email=blah@blah.de.blah").
            to_return(:status => 200, :body => "", :headers => {})

         data = api.cancel_camera_share_request('test_request_id', 'blah@blah.de.blah')
         expect(data).not_to be_nil
         expect(data).to eq(api)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:delete, "https://api.evercam.io/v1/shares/requests/test_request_id.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&email=blah@blah.de.blah").
            to_return(:status => 200, :body => '{"message": "Failed"}', :headers => {})

         expect {api.cancel_camera_share_request('test_request_id', 'blah@blah.de.blah')}.to raise_error(Evercam::EvercamError,
                                                                                                         "Failed")
      end
   end

   #----------------------------------------------------------------------------

   describe '#update_camera_share_request' do
      it 'returns a reference to the API object when the API call returns success' do
         stub_request(:patch, "https://api.evercam.io/v1/shares/requests/test_request_id.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&rights=list%2Cview%2Cedit").
            to_return(:status => 200, :body => "", :headers => {})

         data = api.update_camera_share_request('test_request_id', ["list", "view", "edit"])
         expect(data).not_to be_nil
         expect(data).to eq(api)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:patch, "https://api.evercam.io/v1/shares/requests/test_request_id.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&rights=list%2Cview%2Cedit").
            to_return(:status => 400, :body => '{"message": "Failed"}', :headers => {})

         expect {api.update_camera_share_request('test_request_id', "list,view,edit")}.to raise_error(Evercam::EvercamError,
                                                                                                      "Failed")
      end
   end
end