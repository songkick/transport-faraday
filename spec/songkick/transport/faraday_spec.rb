require 'spec_helper'

module Songkick::Transport
  describe Faraday do
    subject { described_class.new('localhost', :connection => http) }

    let(:http)    { double(::Faraday) }
    let(:request) { Request.new('http://localhost', 'get', '/', {}) }

    after { described_class.clear_thread_connection }

    def self.it_should_raise(exception)
      it "should raise error #{exception}" do
        expect { subject.execute_request(request) }.to raise_error(exception)
      end
    end

    def self.when_request_raises_the_exception(raised_exception, &block)
      describe "when request raises a #{raised_exception}" do
        before do
          allow(http).to receive(:run_request).with(:get, request.url, nil, {}).
            and_raise(raised_exception.new(StandardError.new))
        end

        class_exec(&block)
      end
    end

    describe "handling errors" do
      when_request_raises_the_exception(::Faraday::Error::ConnectionFailed) { it_should_raise(Songkick::Transport::ConnectionFailedError) }
      when_request_raises_the_exception(::Faraday::Error)                   { it_should_raise(Songkick::Transport::UpstreamError)         }
    end
  end
end
