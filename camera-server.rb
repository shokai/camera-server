#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'

port = 8080
port = ARGV.first.to_i if ARGV.size > 0
@@img = 'no image'

class Handler < EM::Connection
  include EM::HttpServer

  def process_http_request
    res = EM::DelegatedHttpResponse.new(self)
    puts "[http] #{@http_request_method} #{@http_path_info}"
    puts " #{@http_post_content.size} bytes" if @http_post_content
    begin
      if @http_request_method == 'GET'
        res.content = @@img
        res.status = 200
      elsif @http_request_method == 'POST'
        @@img = @http_post_content
        res.content = @@img.size.to_s
        res.status = 200
      end
    rescue => e
      STDERR.puts e
      res.status = 500
    end
    res.send_response
  end
end

EM::run do
  EM::start_server('0.0.0.0', port, Handler)
  puts 'starting server..'
  puts " => port #{port}"
end
