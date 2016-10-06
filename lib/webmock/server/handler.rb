require "webmock"
require "rack"

module WebMock
  module Server
    class Handler

      def call(env)
        uri = stub_uri
        uri.path = env['PATH_INFO']
        uri.query = env['QUERY_STRING']

        internal_request = case env['REQUEST_METHOD']
                             when 'GET'
                               Net::HTTP::Get.new uri.to_s
                             when 'POST'
                               Net::HTTP::Post.new uri.to_s
                             when 'DELETE'
                               Net::HTTP::Delete.new uri.to_s
                             when 'PATCH'
                               Net::HTTP::Patch.new uri.to_s
                             else
                               raise "unhandled http method: #{env['REQUEST_METHOD']}"
                           end

        clear_default_headers(internal_request)
        add_headers(env, internal_request)

        internal_request.body = env['rack.input'].gets if env['rack.input']
        internal_request['CONTENT_TYPE'] = env['CONTENT_TYPE']

        response = Net::HTTP.new(uri.host, uri.port).request(internal_request)

        headers = Hash[response.to_hash.map { |k, v| [k, v[0]] }]
        [response.code, headers, [response.body]]
      end

      private

      def stub_uri
        URI.parse STUB_URI
      end

      def clear_default_headers(internal_request)
        default_headers = []
        internal_request.each_header { |key, _| default_headers << key }
        default_headers.each { |header| internal_request.delete(header) }
      end

      def add_headers(env, internal_request)
        env.select { |k, v| k.start_with? 'HTTP_' }
          .map { |key, val| [key.sub(/^HTTP_/, ''), val] }
          .each { |key, val| internal_request[key] = val }
      end
    end
  end
end
