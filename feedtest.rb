#!/usr/bin/env/ruby
require 'rss'

feed_urls = [ "http://feeds.bbci.co.uk/news/business/rss.xml", "http://feeds.bbci.co.uk/news/politics/rss.xml", "http://feeds.bbci.co.uk/sport/football/rss.xml?edition=int" ]


feed = RSS::Parser.parse(feed_urls[0])
feed.items.each do |item|
	puts "#{item.pubDate}|#{item.title}|#{item.description}"

end

