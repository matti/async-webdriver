module Async
  module Webdriver
    class Execute
      def initialize(connection:)
        @execute_connection = ConnectionPath.new "execute", connection: connection
      end

      def sync(script, args=[])
        #TODO: args?
        body = {
          script: script,
          args: args
        }

        @execute_connection.call method: "post", path: "sync", body: body
      end

      def async(script, args=[])
        #TODO: args?
        body = {
          script: script,
          args: args
        }

        @execute_connection.call method: "post", path: "async", body: body
      end
    end
  end
end
