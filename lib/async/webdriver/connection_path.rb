require "async"
require "async/queue"
require "async/http/internet"
require "json"

module Async
  module Webdriver
    class ConnectionPath
      def initialize(prefix, connection:)
        @connection = connection
        @prefix = prefix
      end

      def call(method:, path:nil, headers:[], body:nil)
        connection_path = if path
          "#{@prefix}/#{path}"
        else
          "#{@prefix}"
        end

        @connection.call method: method, path: connection_path, headers: headers, body: body
      end
    end
  end
end
