require 'data_helper'

describe 'Evercam::API User Methods' do
   let(:api) {
      Evercam::API.new(api_id: '123456', api_key: '1a2b3c4d5e6a7b8c9d0e')
   }

   describe '#get_user' do
      it 'returns a hash when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/users/test_user.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"users": [{}]}', :headers => {})

         output = api.get_user('test_user')
         expect(output).not_to be_nil
         expect(output.class).to eq(Hash)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/users/test_user.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 403, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.get_user('test_user')}.to raise_error(Evercam::EvercamError,
                                                           "Evercam API call returned an error. Message: Unauthorized")
      end

      it 'raises an exception when the API call does not return any users' do
         stub_request(:get, "https://api.evercam.io/v1/users/test_user.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_user('test_user')}.to raise_error(Evercam::EvercamError,
                                                           "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_user_cameras' do
      it 'returns an array when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/users/test_user/cameras.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&include_shared=true").
            to_return(:status => 200, :body => '{"cameras": [{}, {}]}', :headers => {})

         output = api.get_user_cameras('test_user', true)
         expect(output).not_to be_nil
         expect(output.class).to eq(Array)
         expect(output.size).to eq(2)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/users/test_user/cameras.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&include_shared=false").
            to_return(:status => 403, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.get_user_cameras('test_user')}.to raise_error(Evercam::EvercamError,
                                                                   "Evercam API call returned an error. Message: Unauthorized")
      end
   end

   #----------------------------------------------------------------------------

   describe '#update_user' do
      it 'returns a reference to the API object when the API call returns success' do
         stub_request(:patch, "https://api.evercam.io/v1/users/test_user.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&forename=Blah&lastname=DeBlah").
            to_return(:status => 200, :body => "", :headers => {})

         output = api.update_user('test_user', forename: 'Blah', lastname: 'DeBlah')
         expect(output).to eq(api)
      end

      it 'does not make an API call if no parameters are specified' do
         output = api.update_user('test_user')
         expect(output).to eq(api)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:patch, "https://api.evercam.io/v1/users/test_user.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&forename=Blah&lastname=DeBlah").
            to_return(:status => 200, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.update_user('test_user', forename: 'Blah', lastname: 'DeBlah')}.to raise_error(Evercam::EvercamError,
                                                                                                    "Evercam API call returned an error. Message: Unauthorized")
      end
   end

   #----------------------------------------------------------------------------

   describe '#delete_user' do
      it 'returns a reference to the API object when the API call returns success' do
         stub_request(:delete, "https://api.evercam.io/v1/users/test_user.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => "", :headers => {})

         output = api.delete_user('test_user')
         expect(output).to eq(api)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:delete, "https://api.evercam.io/v1/users/test_user.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 403, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.delete_user('test_user')}.to raise_error(Evercam::EvercamError,
                                                              "Evercam API call returned an error. Message: Unauthorized")
      end
   end

   #----------------------------------------------------------------------------

   describe '#create_user' do
      it 'returns a Hash when the API call returns success' do
         stub_request(:post, "https://api.evercam.io/v1/users.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&country=Ireland&email=test_user%40test.com&forename=Test&lastname=User&password=password&username=test_user").
            to_return(:status => 200, :body => '{"users": [{}]}', :headers => {})

         data = api.create_user('Test', 'User', 'test_user', 'test_user@test.com', 'password', 'Ireland')
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:post, "https://api.evercam.io/v1/users.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&country=Ireland&email=test_user%40test.com&forename=Test&lastname=User&password=password&username=test_user").
            to_return(:status => 403, :body => '{"message": "Unauthorized"}', :headers => {})

         expect {api.create_user('Test',
                                 'User',
                                 'test_user',
                                 'test_user@test.com',
                                 'password',
                                 'Ireland')}.to raise_error(Evercam::EvercamError,
                                                            "Evercam API call returned an error. Message: Unauthorized")
      end

      it 'raises an exception when the API call response contains no data' do
         stub_request(:post, "https://api.evercam.io/v1/users.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&country=Ireland&email=test_user%40test.com&forename=Test&lastname=User&password=password&username=test_user").
            to_return(:status => 200, :body => '{"users": []}', :headers => {})

         expect {api.create_user('Test',
                                 'User',
                                 'test_user',
                                 'test_user@test.com',
                                 'password',
                                 'Ireland')}.to raise_error(Evercam::EvercamError,
                                                            "Invalid response received from server.")
      end
   end
end