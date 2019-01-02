module Async
  module Webdriver
    class Session
      def initialize(json:, connection:)
        @capabilities = json.fetch "capabilities"
        @id = json.fetch "id"

        @session_connection = ConnectionPath.new "session/#{@id}", connection: connection
        @execute = Execute.new connection: @session_connection
      end

      attr_reader :id, :execute


      def elements
        body = {
          using: "css selector",
          value: "html"
        }

        session_id, value = @session_connection.call method: "post", path: "elements", body: body
        list = []
        for e in value do
          list << Element.new(json: e, connection: @session_connection)
        end
        list
      end

      def delete!
        response = @session_connection.call method: "delete"
      end

      def navigate!(url)
        body = {
          url: url
        }

        @session_connection.call method: "post", path: "url", body: body
        self
      end

      def back!
        @session_connection.call method: "post", path: "back"
        self
      end

      def forward!
        @session_connection.call method: "post", path: "forward"
        self
      end

      def refresh!
        @session_connection.call method: "post", path: "refresh"
        self
      end

      def url
        @session_connection.call method: "get", path: "url"
      end

      def title
        @session_connection.call method: "get", path: "title"
      end

      def source
        @session_connection.call method: "get", path: "source"
      end
    end
  end
end
