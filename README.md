
# Machine Learning news headline categorizer in Ruby

In this primitive machine learning experiment a Ruby program is categorizing news article headlines into one of the following categories:

- Business
- Science and technology
- Entertainment
- Health

Aggregated historical news headline datasets are used to initially train the 'brain' of the machine.

These datasets are being parsed into dictionaries containing wordlists separated into the categories above. Each word has a frequency value associated to it. This value describes how many times this word appeared in headlines of the category.

Wordlists are adjusted to exclude [stop words](https://en.wikipedia.org/wiki/Stop_words).

The algorithm cleans, tokenizes the given input then looks up the highest probability based on the sum of word frequency in each category.


## Usage

1. First download the uci-news-aggregator.csv dataset (102.9MB) from [here](http://archive.ics.uci.edu/ml/datasets/News+Aggregator)
2. Adjust 'brain size' by changing DEBUGLIMIT [parsedata.rb](parsedata.rb) or set DEBUG = 0 to completely disable limits
3. Run program:

```
$ ruby main.rb /path/to/uci-news-aggregator.csv

Processing uci-news-aggregator.csv
Finished processing uci-news-aggregator.csv
Records processed: 20000

[...]

Brain initialization complete
Let me try to categorize your sentence (type quit or Ctrl+D to exit)
> Doctors found an effective drug for Alzheimers
Highest probability: m {"b"=>7, "t"=>27, "e"=>78, "m"=>338}
> 
```
4. Enter news headlines on standard input to evaluate

## Further steps of development

- Training facility
- Web aggregation
- Human supervised brain training

## Links, References

- [Dataset from UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/News+Aggregator)
- [Wikipedia entry for Stop words](https://en.wikipedia.org/wiki/Stop_words)
