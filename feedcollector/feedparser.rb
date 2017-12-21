# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# vim: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby

# RSS feed parser functions
module Feedparser
  require 'rss'
  require 'date'

  def self.parsefeed(url)
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

  def self.newerthan(entries, time)
    entries.select { |entry| entry['date'] > time }
  end

  def self.newestdate(entries)
    entries.max_by { |i| i['date'] }['date']
  end
end
