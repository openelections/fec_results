# FecResults

FecResults is a Ruby library that provides access to federal election results as published by the Federal Election Commission. Although it is primarily a campaign finance disclosure agency, the FEC also compiles election results on its site. This library provides ways to access summary and contest-specific information about elections for the U.S. House of Representatives, the U.S. Senate and President from 2000-2012. This data represents regularly-scheduled primary and general elections, plus special elections held on the date of general elections. It does not include special elections held outside the regularly scheduled election calendar. The results are race-wide only; they do not contain any geographic breakdowns such as county.

Please be aware that there can be typos in some of the FEC results files, mainly in the FEC candidate IDs.

## Installation

Add this line to your application's Gemfile:

    gem 'fec_results'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fec_results

## Usage

FecResults can be used to retrieve both summary and contest-specific election results. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
