# FecResults

FecResults is a Ruby library that provides access to federal election results as published by the Federal Election Commission. Although it is primarily a campaign finance disclosure agency, the FEC also compiles election results on its site. This library provides ways to access summary and contest-specific information about elections for the U.S. House of Representatives, the U.S. Senate and President from 2000-2014. This data represents regularly-scheduled primary and general elections, plus special elections held on the date of general elections. It does not include special elections held outside the regularly scheduled election calendar. The results are race-wide only; they do not contain any geographic breakdowns such as county.

Please be aware that there can be typos in some of the FEC results files, mainly in the FEC candidate IDs.

An accompanying library, [FecResultsGenerator](https://github.com/openelections/fec_results_generator), turns the data retrieved by FecResults into JSON files suitable for creating a static API. You can browse this API from the [docs site](http://openelections.github.io/fec_results/).

## Installation

Add this line to your application's Gemfile:

    gem 'fec_results'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fec_results

## Usage

FecResults can be used to retrieve both summary and contest-specific election results. Every instance of FecResults must include a year passed into the `new` method. For summary totals:

```ruby
require 'fec_results'
s = FecResults::Summary.new(year: 2012)
general_votes = s.general_election_votes
=> [<OpenStruct state="AL", presidential_votes=2074338, senate_votes=nil, house_votes=1933630>, <OpenStruct state="AK", presidential_votes=300495, senate_votes=nil, house_votes=289804>,...]
general_votes.
alabama = general_votes.first
=> <OpenStruct state="AL", presidential_votes=2074338, senate_votes=nil, house_votes=1933630>
alabama.house_votes
=> 1933630
```
For specific congressional results, the file can take awhile to load, so try not to call `results` more than once, but rather save the output locally:

```ruby
c = FecResults::Congress.new(year: 2012)
results = c.results
results.first
=> <FecResults::Result:0x007fb46e297870 @year=2012, @chamber="H", @state="AL", @district="01", @fec_id="H2AL01077", @incumbent=true, @candidate_last="Bonner", @candidate_first="Jo", @candidate_name="Bonner, Jo", @party="R", @primary_votes=48702, @primary_pct=55.54959907839358, @primary_unopposed=false, @runoff_votes=nil, @runoff_pct=nil, @general_votes=196374, @general_pct=97.85624588889553, @general_unopposed=false, @general_runoff_votes=nil, @general_runoff_pct=nil, @general_combined_party_votes=nil, @general_combined_party_pct=nil, @general_winner=true, @notes=nil>
```

To filter either summary or results items by state, pass in the state in a hash:

```ruby
c = FecResults::Congress.new(year: 2012)
results = c.results({state: 'AL'})
results.first
=> <FecResults::Result:0x007fb46e297870 @year=2012, @chamber="H", @state="AL", @district="01", @fec_id="H2AL01077", @incumbent=true, @candidate_last="Bonner", @candidate_first="Jo", @candidate_name="Bonner, Jo", @party="R", @primary_votes=48702, @primary_pct=55.54959907839358, @primary_unopposed=false, @runoff_votes=nil, @runoff_pct=nil, @general_votes=196374, @general_pct=97.85624588889553, @general_unopposed=false, @general_runoff_votes=nil, @general_runoff_pct=nil, @general_combined_party_votes=nil, @general_combined_party_pct=nil, @general_winner=true, @notes=nil>
```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
