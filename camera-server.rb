#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'
require 'ArgsParser'
require 'uri'
require 'json'

parser = ArgsParser.parser
parser.bind(:port, :p, 'http port', 8785)
parser.bind(:max_size, :s, 'max image size (byte)', 1000000)
parser.bind(:index, :i, 'index page name', '/index.json')
parser.bind(:help, :h, 'show help')
@@first, @@params = parser.parse(ARGV)

if parser.has_option(:help)
  puts parser.help
  exit
end

@@imgs = Hash.new

class Handler < EM::Connection
  include EM::HttpServer

  def process_http_request
    res = EM::DelegatedHttpResponse.new(self)
    puts "[http] #{@http_request_method} #{@http_path_info}"
    query = Hash[*(@http_query_string.to_s.split('&').map{|i|
                       j = i.split('=')
                       [j[0].to_sym, URI.decode(j[1])]
                     }).flatten] rescue query = {}
    unless query.empty?
      print ' query_str : '
      p query
    end
    puts " post_content : #{@http_post_content.size} bytes" if @http_post_content
    begin
      if @http_path_info == @@params[:index]
        if @http_request_method == 'GET'
          res.content = @@imgs.map{|k,v|
            {:path => k, :size => v.size}
          }.to_json
          res.content = "#{query[:jsoncallback]}(#{res.content});" if query[:jsoncallback].to_s.size > 0
          res.status = 200
        end
      else
        if @http_request_method == 'GET'
          unless @@imgs[@http_path_info]
            res.content = 'not found'
            res.status = 404
          else
            res.content = @@imgs[@http_path_info]
            res.status = 200
          end
        elsif @http_request_method == 'POST'
          if @http_post_content.size > @@params[:max_size].to_i
            res.content = 'error : size over'
            res.status = 400
          else
          @@imgs[@http_path_info] = @http_post_content
            res.content = @http_post_content.size.to_s
            res.status = 200
          end
        end
      end
    rescue => e
      STDERR.puts e
      res.status = 500
    end
    res.send_response
  end
end

EM::run do
  EM::start_server('0.0.0.0', @@params[:port].to_i, Handler)
  puts 'starting server..'
  puts " => port #{@@params[:port].to_i}"
end
