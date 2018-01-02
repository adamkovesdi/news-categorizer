#!/usr/bin/env ruby
#
# Feed collector application by Adam Kovesdi (c) 2017
require 'rss'
require 'date'
require 'logger'
require './feedparser'

SLEEPTIME = 1800
URLFILE = 'feedurl.txt'.freeze
LASTDATEFILE = 'lastdate.txt'.freeze
OUTPUTFILE = 'output.txt'.freeze
CATEGORIES = Dir.entries('data').reject { |e| e[0] == '.' }
OUTPUTLOG = Logger.new('feedcollector.log')
# OUTPUTLOG = Logger.new(STDOUT)

def log(text)
  OUTPUTLOG.info(text)
end

def error(text)
  OUTPUTLOG.error(text)
end

def fatal(text)
  OUTPUTLOG.fatal(text)
end

def getfeedurl(feed)
  urlfile = 'data/' + feed + "/#{URLFILE}"
  IO.read(File.join(File.dirname(__FILE__), urlfile)).chomp
end

def lastdatefile(feed)
  'data/' + feed + "/#{LASTDATEFILE}"
end

def outputfile(feed)
  'data/' + feed + "/#{OUTPUTFILE}"
end

def updatelastdatefile(feed, updatedate)
  # updates last update file with the given date/time
  filename = lastdatefile(feed)
  f = File.open(filename, 'w')
  f.puts(updatedate)
  f.close
end

def getlastupdate(feed)
  # returns time object of last update
  lastupdate = Time.new(1979, 1, 1)
  datefile = lastdatefile(feed)
  if File.file?(datefile)
    datestring = IO.read(File.join(File.dirname(__FILE__), datefile)).chomp
    lastupdate = Time.rfc2822(datestring)
  end
  lastupdate
end

def writenewer(file, entries, lastupdate)
  count = 0
  entries.each do |e|
    if e['date'] > lastupdate
      file.puts(e.values[0..-1].join('|'))
      count += 1
    end
  end
  count
end

def dofeed(feed)
  entries = Feedparser.parsefeed(getfeedurl(feed))
  lastupdate = getlastupdate(feed)
  f = File.open(outputfile(feed), 'a')
  count = writenewer(f, entries, lastupdate)
  f.close
  lastupdate = Feedparser.newestdate(entries)
  updatelastdatefile(feed, lastupdate)
  count
end

def doallfeeds
  out = 'Parsing'
  CATEGORIES.each do |feed|
    out += " #{feed[0..1]} "
    count = dofeed(feed)
    out += count.to_s
  end
  log(out)
end

def cyclic_feedparse
  log('Starting feed collection')
  loop do
    doallfeeds
    sleep(SLEEPTIME)
  end
end

def interactive
  cyclic_feedparse
rescue Interrupt
  fatal('Stopping on interrupt')
  exit(0)
end

def daemon
  $stdin.reopen('/dev/null')
  $stdout.reopen('/tmp/feedcollectorout.txt', 'a')
  $stderr.reopen('/tmp/feedcollectorout.txt', 'a')
  begin
    cyclic_feedparse
  rescue SignalException
    fatal('Stopping on signal')
    exit(0)
  end
end

def daemonize
  pid = fork do
    daemon
  end
  puts "Feedcollector daemon pid is #{pid}"
  Process.detach pid
end

daemonize
