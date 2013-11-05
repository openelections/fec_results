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

    def primary_election_results(*args)
      send("primary_election_results_#{year}", *args)
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
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        next if candidate['LAST NAME,  FIRST'].blank?
        c = {:year => 2012}
        c[:chamber] = "P"
        c[:state] = candidate['STATE ABBREVIATION']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['LAST NAME,  FIRST'] == 'Obama, Barack' ? true : false
        c[:fec_id] = candidate['FEC ID']
        c[:candidate_first] = candidate['LAST NAME,  FIRST']
        c[:candidate_last] = candidate['LAST NAME,  FIRST']
        c[:candidate_suffix] = candidate['LAST NAME,  FIRST'].split(', ').last if candidate['LAST NAME,  FIRST'].split(', ').size > 2
        c[:candidate_name] = candidate['LAST NAME,  FIRST']
        c[:general_votes] = candidate['GENERAL RESULTS'].to_i
        c[:general_pct] = candidate['GENERAL %'].to_f*100.0
        c[:general_winner] = candidate['WINNER INDICATOR'] == "W" ? true : false
        results << c
      end
      Result.create_from_results(results)
    end

    def general_election_results_2008(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2008 PRES GENERAL RESULTS')
      rows = t.entries
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        next if candidate['LAST NAME,  FIRST'].blank?
        c = {:year => year}
        c[:chamber] = "P"
        c[:date] = Date.parse(candidate['GENERAL ELECTION DATE'])
        c[:state] = candidate['STATE ABBREVIATION']
        c[:party] = candidate['PARTY']
        c[:incumbent] = false
        c[:fec_id] = candidate['FEC ID']
        c[:candidate_first] = candidate['FIRST NAME']
        c[:candidate_last] = candidate['LAST NAME']
        c[:candidate_suffix] = candidate['LAST NAME,  FIRST'].split(', ').last if candidate['LAST NAME,  FIRST'].split(', ').size > 2
        c[:candidate_name] = candidate['LAST NAME,  FIRST']
        c[:general_votes] = candidate['GENERAL RESULTS'].to_i
        c[:general_pct] = candidate['GENERAL %'].to_f*100.0
        c[:general_winner] = nil
        results << c
      end
      Result.create_from_results(results)
    end
    
    def primary_election_results_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2012 Pres Primary Results')
      rows = t.entries
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        next if candidate['LAST NAME,  FIRST'].blank?
        c = {:year => 2012}
        c[:date] = Date.parse(candidate['PRIMARY DATE'])
        c[:chamber] = "P"
        c[:state] = candidate['STATE ABBREVIATION']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['LAST NAME,  FIRST'] == 'Obama, Barack' ? true : false
        c[:fec_id] = candidate['FEC ID']
        c[:candidate_first] = candidate['LAST NAME,  FIRST']
        c[:candidate_last] = candidate['LAST NAME,  FIRST']
        c[:candidate_suffix] = candidate['LAST NAME,  FIRST'].split(', ').last
        c[:candidate_name] = candidate['LAST NAME,  FIRST']
        c[:primary_votes] = candidate['PRIMARY RESULTS'].to_i
        c[:general_pct] = candidate['PRIMARY %'].to_f*100.0
        results << c
      end
      Result.create_from_results(results)
    end


  end
 end