module FecResults
  class President

    attr_reader :year, :url

    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
      @url = FecResults::PRESIDENT_URLS[year.to_s]
    end
    
    def to_s
      "#<FecResults::President:#{year.to_s}>"
    end
    
    #### main instance methods called with optional arguments to filter.
    
    def popular_vote_summary(*args)
      send("popular_vote_summary_#{year}", *args)
    end

    def state_electoral_and_popular_vote_summary(*args)
      send("state_electoral_and_popular_vote_summary_#{year}", *args)
    end
    
    def primary_party_summary
      send("primary_party_summary_#{year}")
    end

    def general_election_results(*args)
      send("general_election_results_#{year}", *args)
    end

    def primary_election_results(*args)
      send("primary_election_results_#{year}", *args)
    end
    
    #### cycle-specific methods called by main methods above

    def popular_vote_summary_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 1. 2012 Pres Popular Vote', :skip => 3)
      t.entries.each do |row|
        break if row['Candidate (Party Label)'] == 'Total:'
        results << OpenStruct.new(:candidate => row['Candidate (Party Label)'], :popular_votes => row['Popular Vote Total'].to_i, :popular_vote_percent => row['Percent of Popular Vote'].to_f)
      end
      results
    end

    def popular_vote_summary_2008(options={})
      results = []
      t = RemoteTable.new(FecResults::SUMMARY_URLS[year.to_s], :sheet => 'Table 1. 2008 Pres Popular Vote', :skip => 3)
      t.entries.each do |row|
        break if row['Candidate (Party Label)'] == 'Total:'
        results << OpenStruct.new(:candidate => row['Candidate (Party Label)'], :popular_votes => row['Popular Vote Total'].to_i, :popular_vote_percent => row['Percent of Popular Vote'].to_f)
      end
      results
    end
    
    def popular_vote_summary_2004(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 1. Pres Popular Vote', :skip => 3)
      t.entries.each do |row|
        break if row['Candidate'] == 'Total:'
        results << OpenStruct.new(:candidate => row['Candidate'], :party => row['(Party Label)'], :popular_votes => row['Popular Vote Total'].to_i, :popular_vote_percent => row['Percent of Popular Vote'].to_f)
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

    def state_electoral_and_popular_vote_summary_2008(options={})
      results = []
      t = RemoteTable.new(FecResults::SUMMARY_URLS[year.to_s], :sheet => 'Table 2. Electoral &  Pop Vote', :skip => 4, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        results << OpenStruct.new(:state => row[0], :democratic_electoral_votes => row[1].to_i, :republican_electoral_votes => row[2].to_i, :democratic_popular_votes => row[3].to_i, :republican_popular_votes => row[4].to_i, :other_popular_votes => row[5].to_i, :total_votes => row[6].to_i)
      end
      results
    end

    def state_electoral_and_popular_vote_summary_2004(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 2. Pres Elec & Pop Vote', :skip => 2)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        results << OpenStruct.new(:state => row['STATE'], :democratic_electoral_votes => row['Electoral Vote Kerry (D)'].to_i, :republican_electoral_votes => row['Electoral Vote Bush (R)'].to_i, :democratic_popular_votes => row['Popular Vote Kerry (D)'].to_i, :republican_popular_votes => row['Popular Vote Bush (R)'].to_i, :other_popular_votes => row['Popular Vote All Others'].to_i, :total_votes => row['Popular Vote Total Vote'].to_i)
      end
      results
    end

    def primary_party_summary_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2012 Pres Primary Party Summary', :skip => 1, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total Primary Votes:'
        results << OpenStruct.new(:party => row[0], :total_votes => row[1].to_i)
      end
      results
    end
    
    def primary_party_summary_2008(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2008 Pres Primary Party Summary', :skip => 1, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total Primary Votes:'
        results << OpenStruct.new(:party => row[0], :total_votes => row[1].to_i)
      end
      results
    end
    
    def primary_party_summary_2004(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2004 Pres Primary Party Summary', :skip => 1, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total Primary Votes Cast:'
        results << OpenStruct.new(:party => row[0], :total_votes => row[1].to_i)
      end
      results
    end

    def primary_party_summary_2000(options={})
      raise NotImplementedError.new("Data not available for #{year}")
    end

    def general_election_results_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2012 Pres General Results')
      rows = t.entries
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        next if candidate['LAST NAME,  FIRST'].blank?
        c = {:year => year}
        c[:chamber] = "P"
        c[:state] = candidate['STATE ABBREVIATION']
        c[:party] = candidate['PARTY'] == 'Combined Parties:' ? "COMBINED TOTAL" : candidate['PARTY']
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
    
    def primary_election_results_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2012 Pres Primary Results')
      rows = t.entries
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        next if candidate['LAST NAME,  FIRST'].blank?
        c = {:year => year}
        c[:chamber] = "P"
        c[:state] = candidate['STATE ABBREVIATION']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['LAST NAME,  FIRST'] == 'Obama, Barack' ? true : false
        c[:fec_id] = candidate['FEC ID']
        c[:candidate_first] = candidate['LAST NAME,  FIRST']
        c[:candidate_last] = candidate['LAST NAME,  FIRST']
        c[:candidate_suffix] = candidate['LAST NAME,  FIRST'].split(', ').last if candidate['LAST NAME,  FIRST'].split(', ').size > 2
        c[:candidate_name] = candidate['LAST NAME,  FIRST']
        c[:general_votes] = candidate['PRIMARY RESULTS'].to_i
        c[:general_pct] = candidate['PRIMARY %'].to_f*100.0
        c[:general_winner] = nil
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
        c[:party] = candidate['PARTY'] == 'Combined Parties:' ? "COMBINED TOTAL" : candidate['PARTY']
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
    
    def primary_election_results_2008(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2008 Pres Primary Results')
      rows = t.entries
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        next if candidate['LAST NAME,  FIRST'].blank?
        c = {:year => year}
        c[:chamber] = "P"
        c[:date] = Date.parse(candidate['PRIMARY DATE'])
        c[:state] = candidate['STATE ABBREVIATION']
        c[:party] = candidate['PARTY']
        c[:incumbent] = false
        c[:fec_id] = candidate['FEC ID']
        c[:candidate_first] = candidate['FIRST NAME']
        c[:candidate_last] = candidate['LAST NAME']
        c[:candidate_suffix] = candidate['LAST NAME,  FIRST'].split(', ').last if candidate['LAST NAME,  FIRST'].split(', ').size > 2
        c[:candidate_name] = candidate['LAST NAME,  FIRST']
        c[:general_votes] = candidate['PRIMARY RESULTS'].to_i
        c[:general_pct] = candidate['PRIMARY %'].to_f*100.0
        c[:general_winner] = nil
        results << c
      end
      Result.create_from_results(results)
    end
    
    def general_election_results_2004(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2004 PRES GENERAL RESULTS')
      rows = t.entries
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        next if candidate['LAST NAME,  FIRST'].blank?
        c = {:year => year}
        c[:date] = Date.parse("GENERAL ELECTION DATE")
        c[:chamber] = "P"
        c[:state] = candidate['STATE ABBREVIATION']
        c[:party] = candidate['PARTY'].blank? ? "COMBINED TOTAL" : candidate['PARTY']
        c[:incumbent] = candidate['LAST NAME,  FIRST'] == 'Bush, George W.' ? true : false
        c[:fec_id] = candidate['FEC ID']
        c[:candidate_first] = candidate['LAST NAME,  FIRST']
        c[:candidate_last] = candidate['LAST NAME,  FIRST']
        c[:candidate_suffix] = candidate['LAST NAME,  FIRST'].split(', ').last if candidate['LAST NAME,  FIRST'].split(', ').size > 2
        c[:candidate_name] = candidate['LAST NAME,  FIRST']
        c[:general_votes] = candidate['GENERAL RESULTS'].to_i
        c[:general_pct] = candidate['GENERAL %'].to_f*100.0
        results << c
      end
      Result.create_from_results(results)
    end

    def primary_election_results_2004(options={})
      results = []
      t = RemoteTable.new(url, :sheet => '2004 PRES PRIMARY RESULTS')
      rows = t.entries
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        next if candidate['LAST NAME,  FIRST'].blank?
        c = {:year => year}
        c[:date] = Date.parse("GENERAL ELECTION DATE")
        c[:chamber] = "P"
        c[:state] = candidate['STATE ABBREVIATION']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['LAST NAME,  FIRST'] == 'Bush, George W.' ? true : false
        c[:fec_id] = candidate['FEC ID']
        c[:candidate_first] = candidate['LAST NAME,  FIRST'] #fixme
        c[:candidate_last] = candidate['LAST NAME,  FIRST'] #fixme
        c[:candidate_suffix] = candidate['LAST NAME,  FIRST'].split(', ').last if candidate['LAST NAME,  FIRST'].split(', ').size > 2
        c[:candidate_name] = candidate['LAST NAME,  FIRST']
        c[:primary_votes] = candidate['PRIMARY RESULTS'].to_i
        c[:primary_pct] = candidate['PRIMARY %'].to_f*100.0
        results << c
      end
      Result.create_from_results(results)
    end
    
    def general_election_results_2000(options={})
      results = []
      t = RemoteTable.new(url.first, :sheet => 'Master (with Totals & Percents)', :skip => 1, :headers => false)
      rows = t.entries
      rows = rows.select{|r| r[0] == options[:state]} if options[:state]
      rows.each do |candidate|
        next if candidate[2].blank?
        c = {:year => year}
        c[:date] = Date.parse("11/7/2000")
        c[:chamber] = "P"
        c[:state] = candidate[0]
        c[:party] = candidate[2] == 'Combined' ? "COMBINED TOTAL" : candidate[2]
        c[:incumbent] = false
        c[:fec_id] = nil
        c[:candidate_first] = candidate[1].split(', ')[1]
        c[:candidate_last] = candidate[1].split(', ')[0]
        c[:candidate_suffix] = candidate[1].split(', ').last if candidate[1].split(', ').size > 2
        c[:candidate_name] = candidate[1]
        c[:general_votes] = candidate[3].blank? ? candidate[5].to_i : candidate[3].to_i
        c[:general_pct] = candidate[4].to_f
        results << c
      end
      Result.create_from_results(results)
    end

    def primary_election_results_2000(options={})
      results = []
      t = RemoteTable.new(url.last, :sheet => 'Primary Results by State')
      rows = t.entries
      rows = rows.select{|r| r['STATE'] == options[:state]} if options[:state]
      rows.each do |candidate|
        next if candidate['PARTY'].blank?
        next if candidate['CANDIDATE'] == 'Total Party Votes'
        c = {:year => year}
        c[:date] = nil
        c[:chamber] = "P"
        c[:state] = candidate['STATE']
        c[:party] = candidate['PARTY']
        c[:incumbent] = false
        c[:fec_id] = nil
        c[:candidate_first] = candidate['CANDIDATE'].split(', ')[1]
        c[:candidate_last] = candidate['CANDIDATE'].split(', ')[0]
        c[:candidate_suffix] = candidate['CANDIDATE'].split(', ').last if candidate['CANDIDATE'].split(', ').size > 2
        c[:candidate_name] = candidate['CANDIDATE']
        c[:primary_votes] = candidate['# OF VOTES'].to_i
        c[:primary_pct] = candidate['PERCENT'].to_f
        results << c
      end
      Result.create_from_results(results)
    end


  end
 end