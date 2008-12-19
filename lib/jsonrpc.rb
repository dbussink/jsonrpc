gem 'addressable', '~>2.0.0'
gem 'json'

require 'net/http'
require 'addressable/uri'
require 'json'

require File.expand_path(File.join(File.dirname(__FILE__), 'jsonrpc', 'version'))
require File.expand_path(File.join(File.dirname(__FILE__), 'jsonrpc', 'exceptions'))

module JsonRPC

  class Client

    def initialize(url)
      @address    = Addressable::URI.parse(url)
    end

    def request(method, params)
      result = {}
      Net::HTTP.start(@address.host, @address.port) do |connection|
        result = JSON.parse(connection.post(@address.path, {:method => method.to_s, :params => params}.to_json).body)
      end
      if error = result["error"]
        raise JsonRPCError, error["message"]
      end
      result
    end

  end

end