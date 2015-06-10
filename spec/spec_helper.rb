require 'rubygems'
require File.expand_path('../../lib/songkick/transport-faraday', __FILE__)

require 'logger'

Songkick::Transport.logger = Logger.new(StringIO.new, :level => :error)
