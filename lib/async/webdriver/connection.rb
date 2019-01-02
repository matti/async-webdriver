require "async"
require "async/queue"
require "async/http/internet"
require "json"

module Async
  module Webdriver
    class Connection
      def initialize(endpoint:)
        @url = endpoint
        @internet = Async::HTTP::Internet.new
      end

      def call(method:, path:nil, headers:[], body:nil)
        body_array = case body
        when Hash
          [body.to_json]
        end

        path_or_url = if path
          "#{@url}/#{path}"
        else
          @url
        end

        task = Async.run do |t|
          r = @internet.call method, path_or_url, headers, body_array

          body = begin
            JSON.parse r.read
          rescue JSON::ParserError => ex
            p ex
            exit 1
          end

          @internet.close

          status = body.dig "status"
          if status == 0
            # POST /session has different response structure than other calls
            if method == "post" && path == "session"
              {
                "id" => body.dig("sessionId"),
                "capabilities" => body.dig("value")
              }
            else # everything else works like this
              body.dig "value"
            end
          else
            p body
            raise "Error: #{status} - #{body.dig("value", "message")}"
          end
        end

        task.wait
      end
    end
  end
end
