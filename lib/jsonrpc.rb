require 'net/http'
require 'addressable/uri'
require 'json'

require File.expand_path(File.join(File.dirname(__FILE__), 'jsonrpc', 'version'))
require File.expand_path(File.join(File.dirname(__FILE__), 'jsonrpc', 'exceptions'))

module JsonRPC

  class Client

    def initialize(url)
      @address    = Addressable::URI.parse(url)
      @id         = 0
    end

    def request(method, params)
      @id += 1
      result = {}
      params ||= {}
      h = {"Content-Type" => "application/json"}
      Net::HTTP.start(@address.host, @address.port) do |connection|
        path = @address.path + (@address.query ? "?#{@address.query}" : "")
        body = {:method => method.to_s, :params => params, :id => @id}
        result = JSON.parse(connection.post(path, body.to_json, h).body)
      end
      if error = result["error"]
        raise JsonRPCError, error["message"]
      end
      result
    end

  end

end
