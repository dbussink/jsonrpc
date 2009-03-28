require 'net/http'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'jsonrpc'))

# Mock around Net::HTTP so we don't need a real connection.
# We just verify whether the correct data is posted and return
# know test data

class Net::HTTP < Net::Protocol
  def connect
  end
end

class Net::HTTPResponse
  def body=(content)
    @body = content
    @read = true
  end
end

class Net::HTTP < Net::Protocol

  def self.raw_response_data
    @raw_response_data
  end

  def self.raw_response_data=(data)
    @raw_response_data = data
  end

  def self.raw_post_body=(body)
    @raw_post_body = body
  end

  def self.raw_post_body
    @raw_post_body
  end

  def self.raw_post_path=(path)
    @raw_post_path = path
  end

  def self.raw_post_path
    @raw_post_path
  end

  def post(path, body, headers = [])
    res = Net::HTTPSuccess.new('1.2', '200', 'OK')
    self.class.raw_post_path = path
    self.class.raw_post_body = body
    res.body = self.class.raw_response_data
    res
  end
end

describe JsonRPC::Client do

  before do
    @jsonrpc = JsonRPC::Client.new("http://localhost:4444/api")
  end

  it { @jsonrpc.should respond_to(:request) }

  describe 'when it is successful' do

    before do
      @jsonrpc = JsonRPC::Client.new("http://localhost:4444/api")
      Net::HTTP.raw_response_data = '{"result":200,"message":"what a great success!"}'
      @result = @jsonrpc.request("test_method", {:param1 => "value1", :param2 => "value2" })
    end

    it 'should receive the correct call at the http level' do
      JSON.parse(Net::HTTP.raw_post_body).should == JSON.parse('{"params":{"param1":"value1","param2":"value2"},"method":"test_method"}')
    end

    it 'should correctly parse the response from the server' do
      @result.should == {"result" => 200, "message" => "what a great success!"}
    end
    
  end

  describe 'when it is not successful' do

    before do
      @jsonrpc = JsonRPC::Client.new("http://localhost:4444/api")
      Net::HTTP.raw_response_data = '{"result":null,"error":{"message":"something is wrong!"}}'
    end

    it 'should raise an exception when a call went wrong' do
      lambda { @jsonrpc.request("test_method", {:param1 => "value1", :param2 => "value2" }) }.should raise_error(JsonRPC::JsonRPCError)
    end

  end

end
