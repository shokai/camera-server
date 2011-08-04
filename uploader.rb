#!/usr/bin/env ruby
require 'rubygems'
require 'ArgsParser'
require 'FileUtils'
require 'net/http'
require 'uri'

parser = ArgsParser.parser
parser.bind(:loop, :l, 'do loop')
parser.bind(:file, :f, 'upload file')
parser.bind(:interval, :i, 'uplaod interval (sec)', 5)
parser.bind(:url, :u, 'upload url', 'http://localhost:8785/test')
parser.bind(:help, :h, 'show help')
first, params = parser.parse(ARGV)

p params

if !parser.has_param(:file) or parser.has_option(:help)
  puts parser.help
  exit
end

f = params[:file]
unless File.exists? f
  STDERR.puts 'upload file not exists'
  exit 1
end

last_mtime = 0
loop do
  begin
    now_mtime = File.mtime(f).to_i
    if now_mtime != last_mtime
      last_mtime = now_mtime
      url = URI.parse(params[:url])
      data = File.open(f).read
      Net::HTTP::start(url.host, url.port){|http|
        res = http.post(url.path, data)
        puts res.body
        STDERR.puts 'file size error' if res.body.to_i != data.size
        puts "[#{last_mtime}] #{params[:url]}"
      }
    end
  rescue => e
    STDERR.puts e
    url = nil
  end
  break unless params[:loop]
  sleep params[:interval].to_f
end

