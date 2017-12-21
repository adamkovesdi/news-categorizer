# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# vim: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby

# Input interpreter and probability calculator
module NewsCategorizer
  def self.countprobabilities(headline, wordhash)
    # convert headline to cleaned array of words
    headline = Parsedata.tokenizeclean(headline)
    retval = Hash.new(0)
    wordhash.each do |category, wordlist|
      probability = 0
      headline.each do |sourceword|
        probability += wordlist[sourceword]
      end
      retval[category] = probability
    end
    retval
  end

  def self.readline
    print '> '
    $stdin.gets
  end

  def self.interactive(wordfrequency)
    puts 'Brain initialization complete'
    puts 'Let me try to categorize your sentence (type quit or Ctrl+D to exit)'
    loop do
      input = readline
      break if input.nil? || input.chomp == 'quit'
      next if input.chomp == ''
      prob = countprobabilities(input, wordfrequency)
      print 'Highest probability: ' +  prob.max_by { |_k, v| v }[0].to_s
      puts ' probability dump: ' + prob.to_s
    end
  end
end
