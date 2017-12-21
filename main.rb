#!/usr/bin/env ruby
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# vim: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby

# Run this main program
require './parsedata'
require './newscategorizer'

if ARGV[0].nil? || !ARGV[0].include?('csv')
  puts 'Error: no csv file given in the command line'
  exit(1)
end

wordfrequency = Parsedata.readcsvtohash(ARGV[0])
NewsCategorizer.interactive wordfrequency
