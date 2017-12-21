#!/usr/bin/env/ruby
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# vim: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby


require './parsedata'
require './newscategorizer'
include Parsedata
include NewsCategorizer

if ARGV[0] == nil || !ARGV[0].include?("csv")
  puts "Error: no csv file given in the command line"
  exit(1)
end

wordfrequency = readcsvtohash(ARGV[0])
interactive wordfrequency
