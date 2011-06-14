#!/usr/bin/env ruby
require 'rubygems'
require 'ArgsParser'
require 'FileUtils'
require 'net/http'
require 'uri'

parser = ArgsParser.parser
parser.bind(:loop, :l, 'do loop')
parser.bind(:file, :f, 'upload file')
parser.bind(:interval, :i, 'uplaod interval : default 5 (sec)')
parser.bind(:url, :u, 'upload url : default http://localhost:8080/')
parser.bind(:help, :h, 'show help')
first, params = parser.parse(ARGV)


if !parser.has_param(:file) or parser.has_option(:help)
  puts parser.help
  exit
end

{
  :interval => 5,
  :url => 'http://localhost:8080/'
}.each{|k,v|
  params[k] = v unless params[k]
}

p params

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
      tmp_file = File.dirname(__FILE__)+'/tmp'
      FileUtils.cp(f, tmp_file)
      url = URI.parse(params[:url])
      data = File.open(tmp_file).read
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

