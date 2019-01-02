require "selenium-webdriver"
module Async
  module Webdriver
    class Element
      def initialize(json:, connection:)
        @id = json.fetch "ELEMENT"
        @element_connection = ConnectionPath.new "element/#{@id}", connection: connection
      end

      def tag_name
        @element_connection.call method: "get", path: "name"
        value
      end

      def text
        @element_connection.call method: "get", path: "text"
      end
    end
  end
end
