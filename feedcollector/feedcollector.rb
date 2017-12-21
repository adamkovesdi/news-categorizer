#!/usr/bin/env ruby
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# vim: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby

# Feed collector application
require 'rss'
require 'date'
require './feedparser'

SLEEPTIME = 900
URLFILE = 'feedurl.txt'.freeze
LASTDATEFILE = 'lastdate.txt'.freeze
OUTPUTFILE = 'output.txt'.freeze
CATEGORIES = %w[business education entertainment_arts football health politics science_environment technology].freeze

feeds = CATEGORIES.map { |d| 'data/' + d + "/#{URLFILE}" }
lastdates = CATEGORIES.map { |d| 'data/' + d + "/#{LASTDATEFILE}" }
outputfiles = CATEGORIES.map { |d| 'data/' + d + "/#{OUTPUTFILE}" }

loop do
  feeds.each_with_index do |url, index|
    t = IO.read(File.join(File.dirname(__FILE__), url)).chomp
    print "Parsing feed category #{CATEGORIES[index]} ... "
    count = 0
    entries = Feedparser.parsefeed(t)
    if File.file?(lastdates[index])
      lastupdate = Time.rfc2822(IO.read(File.join(File.dirname(__FILE__), lastdates[index])).chomp)
    else
      lastupdate = Time.new(1979, 1, 1)
    end
    f = File
    if File.file?(outputfiles[index])
      f = File.open(outputfiles[index], 'a')
    else
      f = File.open(outputfiles[index], 'w')
    end
    entries.each do |e|
      if e['date'] > lastupdate
        f.puts(e.values[1..-1].join('|'))
        count += 1
      end
    end
    f.close
    # Update last date files
    f = File.open(lastdates[index], 'w')
    f.puts(Feedparser.newestdate(entries))
    f.close
    puts count
  end
  puts "#{Time.now} Sleeping for #{SLEEPTIME}"
  sleep(SLEEPTIME)
end
