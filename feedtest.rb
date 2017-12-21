#!/usr/bin/env ruby
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# vim: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby
require 'rss'
require 'date'

feed_url = 'http://feeds.bbci.co.uk/news/business/rss.xml'

def parsefeed(url)
  # returns a hash of feed elements
  retval = []
  feed = RSS::Parser.parse(url)
  feed.items.each do |item|
    # puts "#{item.pubDate}|#{item.title}|#{item.description}"
    entry = {}
    entry['date'] = item.pubDate
    entry['title'] = item.title
    entry['description'] = item.description
    retval.push(entry)
  end
  retval
end

def newerthan(entries, time)
  entries.select { |entry| entry['date'] > time }
end

def newestdate(entries)
  entries.max_by { |i| i['date'] }['date']
end

records = parsefeed(feed_url)
puts newerthan(records, Time.new(2017, 12, 18))
puts '---------'
puts newestdate(records)
