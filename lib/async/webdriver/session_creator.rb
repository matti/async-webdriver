require "async/queue"

module Async
  module Webdriver
    class SessionCreator
      def initialize(connection:)
        @connection = connection
      end

      def create!
        value = @connection.call method: "post", path: "session", body: {
          desiredCapabilities: {}
        }

        Session.new json: value, connection: @connection
      end
    end
  end
end
