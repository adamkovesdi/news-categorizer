# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# vim: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby

require './parsedata'
include Parsedata

def countprobabilities(headline, wordhash)
  # convert headline to cleaned array of words
  headline = tokenizeclean(headline)
  retval = Hash.new(0)
  wordhash.each do |category,wordlist|
    probability = 0
    headline.each do |sourceword|
      probability += wordlist[sourceword]
    end
    retval[category] = probability
  end
  return retval
end

if ARGV[0] == nil || !ARGV[0].include?("csv")
  puts "Error: no csv file given in the command line"
  exit(1)
end

wordfrequency = readcsvtohash(ARGV[0])

puts "Brain initialization complete"
puts "Let me try to categorize your sentence (type quit or Ctrl+D to exit)"
loop do
  print "> "
  input = $stdin.gets
  break if input == nil || input.chomp == "quit"
  next if input.chomp == ''
  prob = countprobabilities(input, wordfrequency)
  print "Highest probability: "
  print prob.max_by{|k,v| v}[0]
  print " " + prob.to_s
  puts
end
