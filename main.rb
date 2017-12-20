# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# vim: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby

require './parsedata'
include Parsedata

wordfrequency = readcsvtohash '/home/adamkov/Desktop/uci-news-aggregator.csv'

puts "Let me categorize your sentence (type quit or Ctrl+D to exit)"
input = ''
loop do
  print "> "
  input = $stdin.gets
  break if input == nil || input.chomp == "quit"
  puts tokenizeclean(input)
end
