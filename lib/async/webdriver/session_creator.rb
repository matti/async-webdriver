require "async/queue"

module Async
  module Webdriver
    class SessionCreator
      def initialize(connection:, desired_capabilities: {})
        @connection = connection
        @desired_capabilities = desired_capabilities
      end

      def create!
        value = @connection.call(
          method: "post",
          path: "session",
          body: { desiredCapabilities: @desired_capabilities }
        )

        Session.new json: value, connection: @connection
      end
    end
  end
end
