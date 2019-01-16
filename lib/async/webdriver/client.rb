require "async/queue"

module Async
  module Webdriver
    class Client
      def initialize(endpoint:, desired_capabilities: {})
        @connection = Connection.new endpoint: endpoint
        @desired_capabilities = desired_capabilities
      end

      def session
        SessionCreator.new connection: @connection, desired_capabilities: @desired_capabilities
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
