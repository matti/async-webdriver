require "async/queue"

module Async
  module Webdriver
    class Client
      def initialize(endpoint:)
        @connection = Connection.new endpoint: endpoint
      end

      def session
        SessionCreator.new connection: @connection
      end

      def status
        @connection.call method: :get, path: "status"
      end

      def sessions
        value = @connection.call method: :get, path: "sessions"
        list = []
        for json in value do
          list << Session.new(json: json, connection: @connection)
        end
        list
      end

    end
  end
end
