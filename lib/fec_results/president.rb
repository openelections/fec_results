module FecResults
  class President

    attr_reader :year, :url

    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
      @url = FecResults::PRESIDENT_URLS[year.to_s]
    end

    def popular_vote_summary(*args)
      send("popular_vote_summary_#{year}", *args)
    end

    def state_electoral_and_popular_vote_summary(*args)
      send("state_electoral_and_popular_vote_summary_#{year}", *args)
    end

    def general_election_results(*args)
      send("general_election_results_#{year}", *args)
    end

    def popular_vote_summary_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 1. 2012 Pres Popular Vote', :skip => 3)
      t.entries.each do |row|
        break if row['Candidate (Party Label)'] == 'Total:'
        results << OpenStruct.new(:candidate => row['Candidate (Party Label)'], :popular_votes => row['Popular Vote Total'].to_i, :popular_vote_percent => row['Percent of Popular Vote'].to_f)
      end
      results
    end

    def state_electoral_and_popular_vote_summary_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 2. Electoral &  Pop Vote', :skip => 4, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        results << OpenStruct.new(:state => row[0], :democratic_electoral_votes => row[1].to_i, :republican_electoral_votes => row[2].to_i, :democratic_popular_votes => row[3].to_i, :republican_popular_votes => row[4].to_i, :other_popular_votes => row[5].to_i, :total_votes => row[6].to_i)
      end
      results
    end

    def general_election_results_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2012 Pres General Results')
      rows = t.entries
      rows = rows.select{|r| r['D'] == options[:chamber]} if options[:chamber]
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        c = {:year => 2012}
        next if candidate['LAST NAME,  FIRST'].blank?
        # find the office_type
        c[:chamber] = "P"
        c[:state] = candidate['STATE ABBREVIATION']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['LAST NAME,  FIRST'] == 'Obama, Barack' ? true : false
        c[:fec_id] = candidate['FEC ID']
        c[:candidate_first] = candidate['LAST NAME,  FIRST']
        c[:candidate_last] = candidate['LAST NAME,  FIRST']
        c[:candidate_suffix] = candidate['LAST NAME,  FIRST'].split(', ').last
        c[:candidate_name] = candidate['LAST NAME,  FIRST']

        c = update_vote_tallies(c, candidate, 'PRIMARY VOTES', 'PRIMARY %', 'RUNOFF VOTES', 'RUNOFF %', 'GENERAL VOTES ', 'GENERAL %')
        c = update_general_runoff(c, candidate, 'GE RUNOFF ELECTION VOTES (LA)', 'GE RUNOFF ELECTION % (LA)') if c[:state] == 'LA'
        c = update_combined_totals(c, candidate, 'COMBINED GE PARTY TOTALS (CT, NY, SC)', 'COMBINED % (CT, NY, SC)') if ['CT', 'NY', 'SC'].include?(c[:state])

        c[:general_winner] = candidate['GE WINNER INDICATOR'] == "W" ? true : false unless c[:general_pct].nil?

        results << c
      end
      Result.create_from_results(results)
    end


  end
 end