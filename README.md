# Evercam

This gem provides a wrapper around the Evercam REST API.

## Installation

Add this line to your application's Gemfile:

    gem 'evercam'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install evercam

## Usage

To use the library in your code the first step is to include the library into
your sources with the line...

    require 'evercam'

With the library included you next need to create an instance of the API class.
This requires that you provide your Evercam API id and key and the following
code...

    api = Evercam::API.new(api_id: '1234567', api_key: '1a2b3c4d5e6a7b8c9d0e')

Once you have an instance of the API class you can make calls to Evercam through
it such as the following...

    cameras = api.get_user_cameras('my_user_name')

### Logging

To add a logger to the Evercam API object you can do this during the creation
of the object as follows...

   api = Evercam::API.new(api_id: '1234567', api_key: '1a2b3c4d5e6a7b8c9d0e', logger: Logger.new(STDOUT))
