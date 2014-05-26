require 'data_helper'

describe 'Evercam::API Snapshots Methods' do
   let(:api) {
      Evercam::API.new(api_id: '123456', api_key: '1a2b3c4d5e6a7b8c9d0e')
   }

   describe '#get_snapshot' do
      it 'returns a string if the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/live.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"data": ""}', :headers => {})

         data = api.get_live_image('test_camera')
         expect(data).not_to be_nil
         expect(data.class).to eq(String)
      end

      it 'raises an exception if the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/live.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 404, :body => '{"message": "Not Found"}', :headers => {})

         expect {api.get_live_image('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                 "Evercam API call returned an error. Message: Not Found")
      end

      it 'raises an exception if the API call result does not include expected data' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/live.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_live_image('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                 "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_snapshots' do
      it 'returns an array if the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"snapshots": []}', :headers => {})

         data = api.get_snapshots('test_camera')
         expect(data).not_to be_nil
         expect(data.class).to eq(Array)
      end

      it 'raises an exception if the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 404, :body => '{"message": "Not Found"}', :headers => {})

         expect {api.get_snapshots('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                  "Evercam API call returned an error. Message: Not Found")
      end

      it 'raises an exception if the API response does not include snapshot data' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_snapshots('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                  "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#store_snapshot' do
      it 'it returns a hash when the API call returns success' do
         stub_request(:post, "https://api.evercam.io/v1/cameras/test_camera/snapshots.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&notes=This%20is%20a%20comment.").
            to_return(:status => 200, :body => '{"snapshots": [{"created_at": 1400671445}]}', :headers => {})

         data = api.store_snapshot('test_camera', 'This is a comment.')
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'it raises an exception when the API call returns an error' do
         stub_request(:post, "https://api.evercam.io/v1/cameras/test_camera/snapshots.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 404, :body => '{"message": "Not Found"}', :headers => {})

         expect {api.store_snapshot('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                   "Evercam API call returned an error. Message: Not Found")
      end

      it 'it raises an exception when the API call response does not include snapshot details' do
         stub_request(:post, "https://api.evercam.io/v1/cameras/test_camera/snapshots.json").
            with(:body => "api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"snapshots": []}', :headers => {})

         expect {api.store_snapshot('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                   "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_latest_snapshot' do
      it 'it returns a hash when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/latest.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"snapshots": [{"created_at": 1400671445}]}', :headers => {})


         data = api.get_latest_snapshot('test_camera')
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'it raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/latest.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 404, :body => '{"message": "Not Found"}', :headers => {})

         expect {api.get_latest_snapshot('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                        "Evercam API call returned an error. Message: Not Found")
      end

      it 'it raises an exception when the API call response does not include snapshot details' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/latest.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_latest_snapshot('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                        "Invalid response received from server.")
      end

      it 'returns nil when the API call response indicates that there is no snapshot available' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/latest.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"snapshots": []}', :headers => {})

         expect(api.get_latest_snapshot('test_camera')).to be_nil
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_snapshots_in_date_range' do
      let(:from) {
         Time.now - 86400
      }
      let(:to) {
         Time.now
      }

      it 'it returns an array when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/range.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&from=#{from.to_i}&limit=100&to=#{to.to_i}&with_data=false").
            to_return(:status => 200, :body => '{"snapshots": []}', :headers => {})

         data = api.get_snapshots_in_date_range('test_camera', from, to)
         expect(data).not_to be_nil
         expect(data.class).to be(Array)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/range.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&from=#{from.to_i}&limit=100&to=#{to.to_i}&with_data=false").
            to_return(:status => 404, :body => '{"message": "Not Found"}', :headers => {})

         expect {api.get_snapshots_in_date_range('test_camera', from, to)}.to raise_error(Evercam::EvercamError,
                                                                                          "Evercam API call returned an error. Message: Not Found")
      end

      it 'raises an exception when the API response does not include snapshot details' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/range.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&from=#{from.to_i}&limit=100&to=#{to.to_i}&with_data=false").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_snapshots_in_date_range('test_camera', from, to)}.to raise_error(Evercam::EvercamError,
                                                                                          "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_snapshots_dates' do
      it 'returns an array of time objects when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/2012/4/days.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"days":[10,15,20]}', :headers => {})

         data = api.get_snapshot_dates('test_camera', 4, 2012)
         expect(data).not_to be_nil
         expect(data.class).to eq(Array)
         expect(data.size).not_to eq(0)
         expect(data[0].class).to eq(Time)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/2012/4/days.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 404, :body => '{"message": "Not Found"}', :headers => {})

         expect {api.get_snapshot_dates('test_camera', 4, 2012)}.to raise_error(Evercam::EvercamError,
                                                                                "Evercam API call returned an error. Message: Not Found")
      end

      it 'raises an exception when the API call response does not include date data' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/2012/4/days.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_snapshot_dates('test_camera', 4, 2012)}.to raise_error(Evercam::EvercamError,
                                                                                "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_snapshots_by_hour' do
      let(:date) {
         Time.local(2012, 1, 1)
      }

      it 'returns an array of time objects when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/2012/1/1/hours.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{"hours": [2,13,19]}', :headers => {})

         data = api.get_snapshots_by_hour('test_camera', date)
         expect(data).not_to be_nil
         expect(data.class).to eq(Array)
         expect(data.size).not_to eq(0)
         expect(data.first.class).to eq(Time)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/2012/1/1/hours.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 404, :body => '{"message": "Not Found"}', :headers => {})

         expect {api.get_snapshots_by_hour('test_camera', date)}.to raise_error(Evercam::EvercamError,
                                                                                "Evercam API call returned an error. Message: Not Found")
      end

      it 'raises an exception when the API call response does not include data' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/2012/1/1/hours.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => '{}', :headers => {})

         expect {api.get_snapshots_by_hour('test_camera', date)}.to raise_error(Evercam::EvercamError,
                                                                                "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_snapshots_by_hour' do
      let(:timestamp) {
         Time.local(2014, 3, 22, 18)
      }

      it 'returns a hash when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/1395511200.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&with_data=false").
            to_return(:status => 200, :body => '{"snapshots": [{"created_at": 1400671445}]}', :headers => {})

         data = api.get_snapshot_at('test_camera', timestamp)
         expect(data).not_to be_nil
         expect(data.class).to eq(Hash)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/1395511200.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&with_data=false").
            to_return(:status => 404, :body => '{"message": "Not Found"}', :headers => {})

         expect {api.get_snapshot_at('test_camera', timestamp)}.to raise_error(Evercam::EvercamError,
                                                                               "Evercam API call returned an error. Message: Not Found")
      end

      it 'raises an exception when the API call returns no data' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshots/1395511200.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e&with_data=false").
            to_return(:status => 200, :body => '{"snapshots": []}', :headers => {})

         expect {api.get_snapshot_at('test_camera', timestamp)}.to raise_error(Evercam::EvercamError,
                                                                               "Invalid response received from server.")
      end
   end

   #----------------------------------------------------------------------------

   describe '#delete_snapshot' do
      let(:timestamp) {
         Time.local(2014, 3, 22, 18)
      }

      it 'returns a reference to the API object when the API call returns success' do
         stub_request(:delete, "https://api.evercam.io/v1/cameras/test_camera/snapshots/1395511200.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => "", :headers => {})

         data = api.delete_snapshot('test_camera', timestamp)
         expect(data).not_to be_nil
         expect(data).to eq(api)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:delete, "https://api.evercam.io/v1/cameras/test_camera/snapshots/1395511200.json?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 404, :body => '{"message": "Not Found"}', :headers => {})

         expect {api.delete_snapshot('test_camera', timestamp)}.to raise_error(Evercam::EvercamError,
                                                                               "Evercam API call returned an error. Message: Not Found")
      end
   end

   #----------------------------------------------------------------------------

   describe '#get_snapshot' do
      it 'returns a string when the API call returns success' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshot.jpg?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 200, :body => "ABCDEFGH", :headers => {})

         data = api.get_snapshot('test_camera')
         expect(data).not_to be_nil
         expect(data.class).to eq(String)
      end

      it 'raises an exception when the API call returns an error' do
         stub_request(:get, "https://api.evercam.io/v1/cameras/test_camera/snapshot.jpg?api_id=123456&api_key=1a2b3c4d5e6a7b8c9d0e").
            to_return(:status => 404, :body => '{"message": "Not Found"}', :headers => {})

         expect {api.get_snapshot('test_camera')}.to raise_error(Evercam::EvercamError,
                                                                 "Evercam API call returned an error. Message: Not Found")
      end
   end
end