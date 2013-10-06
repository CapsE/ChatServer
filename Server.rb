require 'rubygems'      
require 'em-websocket'
require 'sinatra/base'
require 'thin'

EventMachine.run do     
  class App < Sinatra::Base
      set :bind, '0.0.0.0'
      
      get '/' do
          erb :index
      end
  end
  
  $connections = []

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws| 
      # Websocket code here
      ws.onopen {
          ws.send "connected!!!!"
          $connections << ws
      }

      ws.onmessage { |msg|
          puts "got message #{msg}"
          $connections.each do |con|
            con.send msg
          end
      }

      ws.onclose   {
          ws.send "WebSocket closed"
      }

  end


  App.run!({:port => 4567})
end