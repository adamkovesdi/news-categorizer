#!/usr/bin/env ruby
#
# Feed collector application by Adam Kovesdi (c) 2017
require 'rss'
require 'date'
require './feedparser'

SLEEPTIME = 900
URLFILE = 'feedurl.txt'.freeze
LASTDATEFILE = 'lastdate.txt'.freeze
OUTPUTFILE = 'output.txt'.freeze
CATEGORIES = Dir.entries('data').reject { |e| e[0] == '.' }

def debug_printfeeds(fileinfo = false)
  CATEGORIES.each do |feed|
    print feed
    print ' : '
    puts getfeedurl feed
    next unless fileinfo
    puts 'data/' + feed + "/#{URLFILE}"
    puts lastdatefile feed
    puts outputfile feed
  end
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

def dofeed(feed)
  count = 0
  entries = Feedparser.parsefeed(getfeedurl(feed))
  lastupdate = getlastupdate(feed)
  File.open(outputfile(feed), 'a') do |f|
    entries.each do |e|
      if e['date'] > lastupdate
        f.puts(e.values[0..-1].join('|'))
        count += 1
      end
    end
  end
  lastupdate = Feedparser.newestdate(entries)
  updatelastdatefile(feed, lastupdate)
  count
end

def doallfeeds
  CATEGORIES.each do |feed|
    print "Parsing feed #{feed} ... "
    count = dofeed(feed)
    puts "#{count}"
  end
end

doallfeeds

# loop do
# puts "#{Time.now} Sleeping for #{SLEEPTIME}"
# sleep(SLEEPTIME)
# end