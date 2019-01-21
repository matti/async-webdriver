require "async"
require "async/queue"
require "async/http/internet"
require "json"
require "base64"

module Async
  module Webdriver
    class Connection
      def initialize(endpoint:)
        @url = endpoint
        @internet = Async::HTTP::Internet.new
      end

      def call(method:, path:nil, headers:[], body:nil)
        task = begin
          Async::Task.current.async { async_call(method: method, path: path, headers: headers, body: body) }
        rescue RuntimeError => e
          raise unless e.message == "No async task available!"

          Async.run { async_call(method: method, path: path, headers: headers, body: body) }
        end

        task.wait
      end

      private

      def headers_with_basic_auth(headers)
        return headers if !@url.include?('@') || headers.any? { |h| h.start_with?('Authorization') }

        credentials = Base64.urlsafe_encode64(@url.split('@').first.gsub(/\w+:\/\//, ''), padding: false)

        headers.concat(["Authorization: Basic #{credentials}"])
      end

      def async_call(method:, path:, headers:, body:nil)
        body_array = case body
        when Hash
          [body.to_json]
        end

        path_or_url = if path
          "#{@url}/#{path}"
        else
          @url
        end

        r = @internet.call method.upcase, path_or_url, headers_with_basic_auth(headers), body_array

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
    end
  end
end
