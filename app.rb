require 'sinatra'
require "sinatra/json"
require 'thin'
require 'haml'
require 'mongoid'
require "digest/sha1"
require 'sass'

require_relative './app/guitar_chords_gen/lib/mode_new.rb'

require './app/params.rb'
require './app/models/search.rb'
require './app/models/mongo_user.rb'
require './app/models/mongoid_chord.rb'
require './app/chords.rb'

use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'

Mongoid.load!("./mongoid.yml")

configure do
  set :haml, { :format => :html5 }
  set :server, 'thin'
end

        
