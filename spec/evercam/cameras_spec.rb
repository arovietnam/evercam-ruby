require 'data_helper'

describe 'Evercam::API Cameras Methods' do
   let(:api) {
      Evercam::API.new(api_id: '123456', api_key: '1a2b3c4d5e6a7b8c9d0e')
   }

   describe '#test_camera' do
      it 'returns a hash when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&cam_password=password&cam_username=admin&external_url=http://89.101.200.163:8105&jpg_url=/onvif/snapshot").
            to_return(:status => 200, :body => '{"success": "ok", "data": "blah"}', :headers => {})

         data = api.test_camera('http://89.101.200.163:8105', '/onvif/snapshot', 'admin', 'password')
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'raises an exception whenever the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&cam_password=password&cam_username=admin&external_url=http://89.101.200.163:8105&jpg_url=/onvif/snapshot").
            to_return(:status => 403, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.test_camera('http://89.101.200.163:8105',
                                 '/onvif/snapshot',
                                 'admin',
                                 'password')}.to raise_error(Evercam::EvercamError,
                                                             "Evercam API call returned an error. Message: Unauthorized")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_camera' do
      it 'returns a hash when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"cameras": [{}]}', :headers => {})

         data = api.get_camera('test_camera')
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 403, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.get_camera('test_camera')}.to raise_error(Evercam::EvercamError,
                                                               "Evercam API call returned an error. Message: Unauthorized")
      end

      it 'raises an exception if the API call does not return any cameras' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_camera('test_camera')}.to raise_error(Evercam::EvercamError,
                                                               "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#update_camera' do
      it 'returns a reference to the API object when the API call returns success' do
         stub_request(:patch, "https://api.evercam.io/v1/cameras/test_camera.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&cam_password=different&name=blah_camera").
            to_return(:status => 200, :body => "", :headers => {})

         data = api.update_camera('test_camera', name: 'blah_camera', cam_password: 'different')
         expect(data).not_to be_nil
         expect(data).to eq(api)
      end

      it 'does not make an API call if no values are specified' do
         data = api.update_camera('test_camera')
         expect(data).not_to be_nil
         expect(data).to eq(api)
      end

      it 'raises an exception if the API call returns an error' do
         stub_request(:patch, "https://api.evercam.io/v1/cameras/test_camera.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&cam_password=different&name=blah_camera").
            to_return(:status => 403, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.update_camera('test_camera',
                                   name: 'blah_camera',
                                   cam_password: 'different')}.to raise_error(Evercam::EvercamError,
                                                                              "Evercam API call returned an error. Message: Unauthorized")
      end
   end

   #----------------------------------------------------------------------------

   describe '#delete_camera' do
      it 'returns a reference to the API object when the API call returns success' do
         stub_request(:delete, "https://api.evercam.io/v1/cameras/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => "", :headers => {})

         data = api.delete_camera('test_camera')
         expect(data).not_to be_nil
         expect(data).to eq(api)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:delete, "https://api.evercam.io/v1/cameras/test_camera.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 403, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.delete_camera('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                  "Evercam API call returned an error. Message: Unauthorized")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_cameras' do
      it 'returns an array if the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&ids=test_camera1,test_camera2").
            to_return(:status => 200, :body => '{"cameras": [{}, {}]}', :headers => {})

         data = api.get_cameras('test_camera1', 'test_camera2')
         expect(data).not_to be_nil
         expect(data.class).to eq(Array)
         expect(data.size).to eq(2)
      end

      it 'raises an exception if the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&ids=test_camera1,test_camera2").
            to_return(:status => 403, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.get_cameras('test_camera1', 'test_camera2')}.to raise_error(Evercam::EvercamError,
                                                                                 "Evercam API call returned an error. Message: Unauthorized")
      end

      it 'raises an exception if the API call does not return any cameras' do
         stub_request(:get, "https://api.evercam.io/v1.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&ids=test_camera1,test_camera2").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_cameras('test_camera1', 'test_camera2')}.to raise_error(Evercam::EvercamError,
                                                                                 "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#create_cameras' do
      it 'returns a hash if the API call returns success' do
         stub_request(:post, "https://api.evercam.io/v1/cameras.json").
            with(:body => {"api_id"=>"123456", "api_key"=>"1a2b3c4d5e6a7b8c9d0e", "id"=>"test_camera_1", "is_public"=>"false", "name"=>"Test Camera 1"},
                 :headers => {'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.0'}).
            to_return(:status => 200, :body => '{"cameras": [{}]}', :headers => {})

         data = api.create_camera("test_camera_1", "Test Camera 1", false)
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'raises an exception if the API call returns an error' do
         stub_request(:post, "https://api.evercam.io/v1/cameras.json").
            with(:body => {"api_id"=>"123456", "api_key"=>"1a2b3c4d5e6a7b8c9d0e", "id"=>"test_camera_1", "is_public"=>"false", "name"=>"Test Camera 1"},
                 :headers => {'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.0'}).
            to_return(:status => 200, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.create_camera("test_camera_1", "Test Camera 1", false)}.to raise_error(Evercam::EvercamError,
                                                                                            "Evercam API call returned an error. Message: Unauthorized")
      end

      it 'raises an exception if the API call does not include any camera data' do
         stub_request(:post, "https://api.evercam.io/v1/cameras.json").
            with(:body => {"api_id"=>"123456", "api_key"=>"1a2b3c4d5e6a7b8c9d0e", "id"=>"test_camera_1", "is_public"=>"false", "name"=>"Test Camera 1"},
                 :headers => {'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.0'}).
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.create_camera("test_camera_1", "Test Camera 1", false)}.to raise_error(Evercam::EvercamError,
                                                                                            "Invalid response received from server.")
      end

      it 'raises an exception if the API call does not include any cameras' do
         stub_request(:post, "https://api.evercam.io/v1/cameras.json").
            with(:body => {"api_id"=>"123456", "api_key"=>"1a2b3c4d5e6a7b8c9d0e", "id"=>"test_camera_1", "is_public"=>"false", "name"=>"Test Camera 1"},
                 :headers => {'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.0'}).
            to_return(:status => 200, :body => '{"cameras": []}', :headers => {})

         expect {api.create_camera("test_camera_1", "Test Camera 1", false)}.to raise_error(Evercam::EvercamError,
                                                                                            "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#change_camera_owner' do
      it 'returns a hash if the API call returns success' do
         stub_request(:put, "https://api.evercam.io/v1/cameras/test_camera.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&user_id=test_user").
            to_return(:status => 200, :body => '{"cameras": [{}]}', :headers => {})

         data = api.change_camera_owner('test_camera', 'test_user')
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'raises an exception if the API call returns an error' do
         stub_request(:put, "https://api.evercam.io/v1/cameras/test_camera.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&user_id=test_user").
            to_return(:status => 400, :body => '{"message": "Failed"}', :headers => {})

         expect {api.change_camera_owner('test_camera', 'test_user')}.to raise_error(Evercam::EvercamError,
                                                                                     "Evercam API call returned an error. Message: Failed")
      end

      it 'raises an exception of the API call response contains no data' do
         stub_request(:put, "https://api.evercam.io/v1/cameras/test_camera.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&user_id=test_user").
            to_return(:status => 200, :body => '{"cameras": []}', :headers => {})

         expect {api.change_camera_owner('test_camera', 'test_user')}.to raise_error(Evercam::EvercamError,
                                                                                     "Invalid response received from server.")
      end
   end
end