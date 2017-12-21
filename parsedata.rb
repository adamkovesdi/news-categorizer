# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# vim: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby

# CSV data parser to word dictionary
module Parsedata
  require 'csv'
  DEBUG = 1
  DEBUGLIMIT = 20000
  STOPWORDS = %w{a able about across after all almost also am among an and any are as at be because been but by can cannot could dear did do does either else ever every for from get got had has have he her hers him his how however i if in into is it its just least let like likely may me might most must my neither no nor not of off often on only or other our own rather said say says she should since so some than that the their them then there these they this tis to too twas us wants was we were what when where which while who whom why will with would yet you your}

  def self.removepunctuation(text)
    return if text.nil?
    text.gsub(/[^\nA-Za-z0-9 ]/, '')
  end

  def self.tokenizeclean(text)
    text = removepunctuation(text).downcase
    text.split.select { |w| !STOPWORDS.include?(w) }
  end

  def self.readcsvtohash(filename)
    counts = Hash.new(0)
    words = Hash.new
    total = 0
    puts "Processing #{filename}"
    File.open(filename,'r').each_with_index do |line, index|
      # process each line, skip CSV header
      next if index.zero?
      begin
        _id, title, _url, _source, category, _hash, _site, _timestamp = CSV.parse(line)[0]
        if category =~ /[^btem]/ || category.nil?
          # unknown category?! CSV fukup?
          raise ArgumentError
        end
        # increase category count
        counts[category] += 1
        # word count
        tokenizeclean(title).each do |word|
          unless words.include? category
            words[category] = Hash.new(0)
          end
          words[category][word] += 1
        end
        total += 1
      rescue CSV::MalformedCSVError
        puts "Warning: malformed CSV in line #{index}"
      rescue ArgumentError
        puts "Warning: invalid category in line #{index}"
      end

      if (index % 1000).zero?
        print "processed #{index/1000}K records\r"
      end

      break if index >= DEBUGLIMIT if DEBUG == 1
    end
    puts "Finished processing #{filename}"
    puts "Records processed: #{total}"
    if DEBUG == 1
      puts
      print 'Category counts: '
      counts.each { |k, v| print k + ':' + v.to_s + ' ' }
      puts
      print 'Word counts: '
      words.each { |k, v| print k + ':' + v.keys.count.to_s + ' ' }
      puts; puts
      # list most frequent words for each category
      words.each do |category, wordlist|
        puts "Most frequent words for category #{category}"
        print wordlist.max_by(5) { |_w, c| c }
        puts
      end
      puts
    end
    return words
  end
end
