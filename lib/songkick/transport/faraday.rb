require 'faraday'

module Songkick
  module Transport
    class Faraday < Base

      # options:
      #   :middlewares => array of middleware args for `builder.use` eg. `[ [FaradayMiddleware::ParseJson, { :content_type => /\bjson\b/ }], ... ]`
      def initialize(host, options = {})
        @host = host
        @faraday_adapter = options[:adapter] || ::Faraday.default_adapter
        @middlewares = options[:middlewares] || []
        @timeout = options[:timeout] || DEFAULT_TIMEOUT
        @user_agent = options[:user_agent]
        @user_error_codes = options[:user_error_codes] || DEFAULT_USER_ERROR_CODES

        Thread.current[:transport_faraday] = options[:connection] if options[:connection]
      end

      def self.clear_thread_connection
        Thread.current[:transport_faraday] = nil
      end

      def connection
        Thread.current[:transport_faraday] ||= ::Faraday.new(@host) do |builder|
          @middlewares.each { |middleware_args| builder.use *middleware_args }
          builder.adapter @faraday_adapter
        end
      end

      def endpoint
        @host
      end

      def execute_request(req)
        faraday_response = connection.run_request(req.verb.to_sym, req.url, nil, req.headers) do |faraday_request|
          faraday_request.body = req.body if req.use_body?
          faraday_request.options[:timeout] = req.timeout || @timeout
        end

        process(req, faraday_response.status, faraday_response.headers, faraday_response.body)

      rescue ::Faraday::Error::ConnectionFailed
        logger.warn "Could not connect to host: #{@host}"
        raise Transport::ConnectionFailedError, req

      rescue ::Faraday::Error => error
        logger.warn error.message
        raise Transport::UpstreamError, req

      end

    end
  end
end
