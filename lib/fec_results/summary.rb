module FecResults
  class Summary
    
    attr_reader :year, :url
    
    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
      @url = FecResults::SUMMARY_URLS[year.to_s]
    end
    
    #### main instance methods called with optional arguments to filter.

    def general_election_votes(*args)
      send("process_general_election_votes_#{year}", *args)
    end
    
    def general_election_votes_by_party(*args)
      send("process_general_election_votes_by_party_#{year}", *args)
    end
    
    def congressional_votes_by_election(*args)
      send("process_congressional_votes_by_election_#{year}", *args)
    end
    
    def presidential_electoral_and_popular_vote(*args)
      return "Not a presidential year" unless [2012, 2008, 2004, 2000].include?(year)
      send("process_presidential_electoral_and_popular_vote_#{year}", *args)
    end
    
    def chamber_votes_by_party(*args)
      send("process_chamber_votes_by_party_#{year}", *args)
    end

    def house_party_gains(*args)
      return "Not available" unless [2010].include?(year)
      send("process_house_party_gains_#{year}")
    end

    def party_labels
      send("party_labels_#{year}")
    end
    
    #### cycle-specific methods called by main methods above
    
    def process_general_election_votes_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 3.GEVotes for Pres, H & S', :skip => 2)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        pres_votes = row['Presidential Vote'].to_i == 0 ? nil : row['Presidential Vote'].to_i
        sen_votes = row['U.S. Senate Vote'].to_i == 0 ? nil : row['U.S. Senate Vote'].to_i
        results << OpenStruct.new(:state => row['State'], :presidential_votes => pres_votes, :senate_votes => sen_votes, :house_votes => row['U.S. House Vote'].to_i)
      end
      results
    end

    def process_general_election_votes_2010(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 1. GE Votes Cast for Cong', :skip => 2)
      t.entries.each do |row|
        break if row['STATE ABBREVIATION'] == 'Total:'
        sen_votes = row['U.S. SENATE VOTE'].to_i == 0 ? nil: row['U.S. SENATE VOTE'].to_i
        results << OpenStruct.new(:state => row['STATE'], :state_abbrev => row['STATE ABBREVIATION'], :senate_votes => sen_votes, :house_votes => row['U.S. HOUSE VOTE'].to_i)
      end
      results
    end

    def process_general_election_votes_2008(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 3.GEVotes for Pres, H & S', :skip => 2)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        pres_votes = row['Presidential Vote'].to_i == 0 ? nil : row['Presidential Vote'].to_i
        sen_votes = row['U.S. Senate Vote'].to_i == 0 ? nil : row['U.S. Senate Vote'].to_i
        results << OpenStruct.new(:state_abbrev => row['State'], :presidential_votes => pres_votes, :senate_votes => sen_votes, :house_votes => row['U.S. House Vote'].to_i)
      end
      results
    end
    
    def process_general_election_votes_2006(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 1. GE Votes by State ', :skip => 2)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        sen_votes = row['U.S. Senate Vote'].to_i == 0 ? nil : row['U.S. Senate Vote'].to_i
        results << OpenStruct.new(:state_abbrev => row['State'], :senate_votes => sen_votes, :house_votes => row['U.S. House Vote'].to_i, :total_votes => row['Combined Vote'].to_i)
      end
      results
    end
    
    def process_general_election_votes_2004(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 3. GE Votes by State', :skip => 2)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        pres_votes = row['Presidential Vote'].to_i == 0 ? nil : row['Presidential Vote'].to_i
        sen_votes = row['U.S. Senate Vote'].to_i == 0 ? nil : row['U.S. Senate Vote'].to_i
        results << OpenStruct.new(:state_abbrev => row['State'], :presidential_votes => pres_votes, :senate_votes => sen_votes, :house_votes => row['U.S. House Vote'].to_i)
      end
      results
    end
    
    def process_general_election_votes_2002(options={})
      raise NotImplementedError.new("This method not available for 2002")
    end

    def process_general_election_votes_by_party_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 4. GE Votes Cast by Party', :skip => 3)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        dem_votes = row['Democratic Candidates'].to_i == 0 ? nil : row['Democratic Candidates'].to_i
        gop_votes = row['Republican Candidates'].to_i == 0 ? nil : row['Republican Candidates'].to_i
        other_votes = row['Other Candidates'].to_i == 0 ? nil : row['Other Candidates'].to_i
        results << OpenStruct.new(:state => row['State'], :democratic_candidates => dem_votes, :republican_candidates => gop_votes, :other_candidates => other_votes)
      end
      results
    end

    def process_general_election_votes_by_party_2010(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 2. GE Votes by Party', :skip => 3)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        dem_votes = row['Democratic Candidates'].to_i == 0 ? nil : row['Democratic Candidates'].to_i
        gop_votes = row['Republican Candidates'].to_i == 0 ? nil : row['Republican Candidates'].to_i
        other_votes = row['Other Candidates'].to_i == 0 ? nil : row['Other Candidates'].to_i
        results << OpenStruct.new(:state => row['State'], :democratic_candidates => dem_votes, :republican_candidates => gop_votes, :other_candidates => other_votes)
      end
      results
    end

    def process_general_election_votes_by_party_2008(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 4. GE Votes Cast by Party', :skip => 3)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        dem_votes = row['Democratic Candidates'].to_i == 0 ? nil : row['Democratic Candidates'].to_i
        gop_votes = row['Republican Candidates'].to_i == 0 ? nil : row['Republican Candidates'].to_i
        other_votes = row['Other Candidates'].to_i == 0 ? nil : row['Other Candidates'].to_i
        results << OpenStruct.new(:state_abbrev => row['State'], :democratic_candidates => dem_votes, :republican_candidates => gop_votes, :other_candidates => other_votes)
      end
      results
    end

    def process_general_election_votes_by_party_2006(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 2. GE Votes by Party', :skip => 3)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        dem_votes = row['Democratic Candidates'].to_i == 0 ? nil : row['Democratic Candidates'].to_i
        gop_votes = row['Republican Candidates'].to_i == 0 ? nil : row['Republican Candidates'].to_i
        other_votes = row['Other Candidates'].to_i == 0 ? nil : row['Other Candidates'].to_i
        results << OpenStruct.new(:state_abbrev => row['State'], :democratic_candidates => dem_votes, :republican_candidates => gop_votes, :other_candidates => other_votes)
      end
      results
    end
    
    def process_general_election_votes_by_party_2004(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 4. GE Votes by Party', :skip => 3)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        dem_votes = row['Democratic Candidates'].to_i == 0 ? nil : row['Democratic Candidates'].to_i
        gop_votes = row['Republican Candidates'].to_i == 0 ? nil : row['Republican Candidates'].to_i
        other_votes = row['Other Candidates'].to_i == 0 ? nil : row['Other Candidates'].to_i
        results << OpenStruct.new(:state_abbrev => row['State'], :democratic_candidates => dem_votes, :republican_candidates => gop_votes, :other_candidates => other_votes)
      end
      results
    end
    
    def process_general_election_votes_by_party_2002(options={})
      raise NotImplementedError.new("This method not available for 2002")
    end
    
    def process_congressional_votes_by_election_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 5. P&G VotesCastforCong', :skip => 4, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        senate_primary_votes = row[1].to_i == 0 ? nil : row[1].to_i
        senate_general_votes = row[2].to_i == 0 ? nil : row[2].to_i
        house_primary_votes = row[3].to_i == 0 ? nil : row[3].to_i
        house_general_votes = row[4].to_i == 0 ? nil : row[4].to_i
        results << OpenStruct.new(:state => row[0], :senate_primary_votes => senate_primary_votes, :senate_general_votes => senate_general_votes, :house_primary_votes => house_primary_votes, :house_general_votes => house_general_votes)
      end
      results
    end

    def process_congressional_votes_by_election_2010(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 3. Prim & Gen Votes Cast', :skip => 2)
      t.entries.each do |row|
        break if row['STATE ABBREVIATION'] == 'Total:'
        senate_primary_votes = row['PRIMARY U.S. SENATE VOTE'].to_i == 0 ? nil : row['PRIMARY U.S. SENATE VOTE'].to_i
        senate_general_votes = row['GENERAL U.S. SENATE VOTE'].to_i == 0 ? nil : row['GENERAL U.S. SENATE VOTE'].to_i
        house_primary_votes = row['PRIMARY U.S. HOUSE VOTE'].to_i == 0 ? nil : row['PRIMARY U.S. HOUSE VOTE'].to_i
        house_general_votes = row['GENERAL U.S. HOUSE VOTE'].to_i == 0 ? nil : row['GENERAL U.S. HOUSE VOTE'].to_i
        results << OpenStruct.new(:state => row['STATE'], :state_abbrev => row['STATE ABBREVIATION'], :senate_primary_votes => senate_primary_votes, :senate_general_votes => senate_general_votes, :house_primary_votes => house_primary_votes, :house_general_votes => house_general_votes)
      end
      results
    end
    
    def process_congressional_votes_by_election_2008(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 5. P&G VotesCastforCong', :skip => 4, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        senate_primary_votes = row[1].to_i == 0 ? nil : row[1].to_i
        senate_general_votes = row[2].to_i == 0 ? nil : row[2].to_i
        house_primary_votes = row[3].to_i == 0 ? nil : row[3].to_i
        house_general_votes = row[4].to_i == 0 ? nil : row[4].to_i
        results << OpenStruct.new(:state_abbrev => row[0], :senate_primary_votes => senate_primary_votes, :senate_general_votes => senate_general_votes, :house_primary_votes => house_primary_votes, :house_general_votes => house_general_votes)
      end
      results
    end

    def process_congressional_votes_by_election_2006(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 3. P&G Votes for Congress', :skip => 2)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        senate_primary_votes = row['PRIMARY U.S. Senate Vote'].to_i == 0 ? nil : row['PRIMARY U.S. Senate Vote'].to_i
        senate_general_votes = row['GENERAL U.S. Senate Vote'].to_i == 0 ? nil : row['GENERAL U.S. Senate Vote'].to_i
        house_primary_votes = row['PRIMARY U.S. House Vote'].to_i == 0 ? nil : row['PRIMARY U.S. House Vote'].to_i
        house_general_votes = row['GENERAL U.S. House Vote'].to_i == 0 ? nil : row['GENERAL U.S. House Vote'].to_i
        results << OpenStruct.new(:state_abbrev => row['State'], :senate_primary_votes => senate_primary_votes, :senate_general_votes => senate_general_votes, :house_primary_votes => house_primary_votes, :house_general_votes => house_general_votes)
      end
      results
    end

    def process_congressional_votes_by_election_2004(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 5. P&G Votes for Congress', :skip => 2)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        senate_primary_votes = row['PRIMARY U.S. Senate Vote'].to_i == 0 ? nil : row['PRIMARY U.S. Senate Vote'].to_i
        senate_general_votes = row['GENERAL U.S. Senate Vote'].to_i == 0 ? nil : row['GENERAL U.S. Senate Vote'].to_i
        house_primary_votes = row['PRIMARY U.S. House Vote'].to_i == 0 ? nil : row['PRIMARY U.S. House Vote'].to_i
        house_general_votes = row['GENERAL U.S. House Vote'].to_i == 0 ? nil : row['GENERAL U.S. House Vote'].to_i
        results << OpenStruct.new(:state_abbrev => row['State'], :senate_primary_votes => senate_primary_votes, :senate_general_votes => senate_general_votes, :house_primary_votes => house_primary_votes, :house_general_votes => house_general_votes)
      end
      results
    end

    def process_congressional_votes_by_election_2002(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 1. Primary & General Vote', :skip => 4, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        senate_primary_votes = row[1].to_i == 0 ? nil : row[1].to_i
        senate_general_votes = row[2].to_i == 0 ? nil : row[2].to_i
        house_primary_votes = row[3].to_i == 0 ? nil : row[3].to_i
        house_general_votes = row[4].to_i == 0 ? nil : row[4].to_i
        results << OpenStruct.new(:state_abbrev => row[0], :senate_primary_votes => senate_primary_votes, :senate_general_votes => senate_general_votes, :house_primary_votes => house_primary_votes, :house_general_votes => house_general_votes)
      end
      results
    end
    
    # columns are dem primary, gop primary, other primary, dem general, gop general, other general
    # runoff election votes are included in the primary totals
    def process_chamber_votes_by_party_2012(options={})
      results = []
      sheet = options[:chamber] == 'senate' ? 'Table 6. Senate by Party' : 'Table 7. House by Party'
      t = RemoteTable.new(url, :sheet => sheet, :skip => 4, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        dem_primary = row[1].to_i == 0 ? nil : row[1].to_i
        gop_primary = row[2].to_i == 0 ? nil : row[2].to_i
        other_primary = row[3].to_i == 0 ? nil : row[3].to_i
        dem_general = row[4].to_i == 0 ? nil : row[4].to_i
        gop_general = row[5].to_i == 0 ? nil : row[5].to_i
        other_general = row[6].to_i == 0 ? nil : row[6].to_i
        results << OpenStruct.new(:state => row[0], :democratic_primary_votes => dem_primary, :republican_primary_votes => gop_primary, :other_primary_votes => other_primary,
        :democratic_general_votes => dem_general, :republican_general_votes => gop_general, :other_general_votes => other_general)
      end
      results
    end

    def process_chamber_votes_by_party_2010(options={})
      results = []
      sheet = options[:chamber] == 'senate' ? 'Table 4. Senate by Party' : 'Table 5. House by Party'
      t = RemoteTable.new(url, :sheet => sheet, :skip => 2)
      t.entries.each do |row|
        break if row['STATE ABBREVIATION'] == 'Total:'
        dem_primary = row['PRIMARY ELECTION DEMOCRATIC'].to_i == 0 ? nil : row['PRIMARY ELECTION DEMOCRATIC'].to_i
        gop_primary = row['PRIMARY ELECTION REPUBLICAN'].to_i == 0 ? nil : row['PRIMARY ELECTION REPUBLICAN'].to_i
        other_primary = row['PRIMARY ELECTION OTHER'].to_i == 0 ? nil : row['PRIMARY ELECTION OTHER'].to_i
        dem_general = row['GENERAL ELECTION DEMOCRATIC'].to_i == 0 ? nil : row['GENERAL ELECTION DEMOCRATIC'].to_i
        gop_general = row['GENERAL ELECTION REPUBLICAN'].to_i == 0 ? nil : row['GENERAL ELECTION REPUBLICAN'].to_i
        other_general = row['GENERAL ELECTION OTHER'].to_i == 0 ? nil : row['GENERAL ELECTION OTHER'].to_i
        results << OpenStruct.new(:state => row['STATE'], :state_abbrev => row['STATE ABBREVIATION'], :democratic_primary_votes => dem_primary, :republican_primary_votes => gop_primary, :other_primary_votes => other_primary,
        :democratic_general_votes => dem_general, :republican_general_votes => gop_general, :other_general_votes => other_general)
      end
      results
    end

    def process_chamber_votes_by_party_2008(options={})
      results = []
      sheet = options[:chamber] == 'senate' ? 'Table 6. Senate by Party' : 'Table 7. House by Party'
      t = RemoteTable.new(url, :sheet => sheet, :skip => 4, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        dem_primary = row[1].to_i == 0 ? nil : row[1].to_i
        gop_primary = row[2].to_i == 0 ? nil : row[2].to_i
        other_primary = row[3].to_i == 0 ? nil : row[3].to_i
        dem_general = row[4].to_i == 0 ? nil : row[4].to_i
        gop_general = row[5].to_i == 0 ? nil : row[5].to_i
        other_general = row[6].to_i == 0 ? nil : row[6].to_i
        results << OpenStruct.new(:state_abbrev => row[0], :democratic_primary_votes => dem_primary, :republican_primary_votes => gop_primary, :other_primary_votes => other_primary,
        :democratic_general_votes => dem_general, :republican_general_votes => gop_general, :other_general_votes => other_general)
      end
      results
    end

    def process_chamber_votes_by_party_2006(options={})
      results = []
      sheet = options[:chamber] == 'senate' ? 'Table 4. Senate Votes by Party' : 'Table 5. House Votes by Party'
      t = RemoteTable.new(url, :sheet => sheet, :skip => 2)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        dem_primary = row['PRIMARY Democratic'].to_i == 0 ? nil : row['PRIMARY Democratic'].to_i
        gop_primary = row['PRIMARY Republican'].to_i == 0 ? nil : row['PRIMARY Republican'].to_i
        other_primary = row['PRIMARY Other'].to_i == 0 ? nil : row['PRIMARY Other'].to_i
        dem_general = row['GENERAL Democratic'].to_i == 0 ? nil : row['GENERAL Democratic'].to_i
        gop_general = row['GENERAL Republican'].to_i == 0 ? nil : row['GENERAL Republican'].to_i
        other_general = row['GENERAL Other'].to_i == 0 ? nil : row['GENERAL Other'].to_i
        results << OpenStruct.new(:state_abbrev => row['State'], :democratic_primary_votes => dem_primary, :republican_primary_votes => gop_primary, :other_primary_votes => other_primary,
        :democratic_general_votes => dem_general, :republican_general_votes => gop_general, :other_general_votes => other_general)
      end
      results
    end

    def process_chamber_votes_by_party_2004(options={})
      results = []
      sheet = options[:chamber] == 'senate' ? 'Table 6. Senate Votes by Party' : 'Table 7. House Votes by Party'
      state = options[:chamber] == 'senate' ? 'STATE' : 'State'
      t = RemoteTable.new(url, :sheet => sheet, :skip => 2)
      t.entries.each do |row|
        break if row[state] == 'Total:'
        dem_primary = row['PRIMARY Democratic'].to_i == 0 ? nil : row['PRIMARY Democratic'].to_i
        gop_primary = row['PRIMARY Republican'].to_i == 0 ? nil : row['PRIMARY Republican'].to_i
        other_primary = row['PRIMARY Other'].to_i == 0 ? nil : row['PRIMARY Other'].to_i
        dem_general = row['GENERAL Democratic'].to_i == 0 ? nil : row['GENERAL Democratic'].to_i
        gop_general = row['GENERAL Republican'].to_i == 0 ? nil : row['GENERAL Republican'].to_i
        other_general = row['GENERAL Other'].to_i == 0 ? nil : row['GENERAL Other'].to_i
        results << OpenStruct.new(:state_abbrev => row[state], :democratic_primary_votes => dem_primary, :republican_primary_votes => gop_primary, :other_primary_votes => other_primary,
        :democratic_general_votes => dem_general, :republican_general_votes => gop_general, :other_general_votes => other_general)
      end
      results
    end

    def process_chamber_votes_by_party_2002(options={})
      results = []
      sheet = options[:chamber] == 'senate' ? 'Table 2. Senate Votes by Party' : 'Table 3. House Votes by Party'
      t = RemoteTable.new(url, :sheet => sheet, :skip => 4, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        dem_primary = row[1].to_i == 0 ? nil : row[1].to_i
        gop_primary = row[2].to_i == 0 ? nil : row[2].to_i
        other_primary = row[3].to_i == 0 ? nil : row[3].to_i
        dem_general = row[4].to_i == 0 ? nil : row[4].to_i
        gop_general = row[5].to_i == 0 ? nil : row[5].to_i
        other_general = row[6].to_i == 0 ? nil : row[6].to_i
        results << OpenStruct.new(:state_abbrev => row[0], :democratic_primary_votes => dem_primary, :republican_primary_votes => gop_primary, :other_primary_votes => other_primary,
        :democratic_general_votes => dem_general, :republican_general_votes => gop_general, :other_general_votes => other_general)
      end
      results
    end

    def process_house_party_gains_2010(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 6. House Party Gains', :skip => 3)
      t.entries.each do |row|
        break if row['State'] == 'Total:'
        results << OpenStruct.new(:state_abbrev => row['State'], :republican_seats_2010 => row['2010 Republican Seats'].to_i, :democratic_seats_2010 => row['2010 Democratic Seats'].to_i, 
          :republican_seats_2008 => row['2008 Republican Seats'].to_i, :democratic_seats_2008 => row['2008 Democratic Seats'].to_i, :change_in_republican_seats => row['Change in # of Republican Seats, 2008-2010'].to_i)
      end
      results
    end

    def party_labels_2012
      results = []
      t = RemoteTable.new(url, :sheet => '2012 Party Labels', :skip => 5, :headers => false)
      t.entries.each do |row|
        results << OpenStruct.new(:abbrev => row[0], :name => row[2])
      end
      results
    end

    def party_labels_2010
      results = []
      t = RemoteTable.new(FecResults::CONGRESS_URLS[year.to_s], :sheet => '2010 Party Labels', :skip => 5, :headers => false)
      t.entries.each do |row|
        results << OpenStruct.new(:abbrev => row[0], :name => row[2])
      end
      results
    end

    def party_labels_2008
      results = []
      t = RemoteTable.new(FecResults::PRESIDENT_URLS[year.to_s], :sheet => '2008 Party Labels', :skip => 5, :headers => false)
      t.entries.each do |row|
        results << OpenStruct.new(:abbrev => row[0], :name => row[2])
      end
      results
    end

    def party_labels_2006
      results = []
      t = RemoteTable.new(FecResults::CONGRESS_URLS[year.to_s], :sheet => '2006 Party Labels', :skip => 7, :headers => false)
      t.entries.each do |row|
        results << OpenStruct.new(:abbrev => row[0], :name => row[2])
      end
      results
    end

    def party_labels_2004
      results = []
      t = RemoteTable.new(FecResults::PRESIDENT_URLS[year.to_s], :sheet => '2004 Party Labels', :skip => 7, :headers => false)
      t.entries.each do |row|
        results << OpenStruct.new(:abbrev => row[0], :name => row[2])
      end
      results
    end

    def party_labels_2002
      results = []
      t = RemoteTable.new(url, :sheet => '2002 Party Labels', :skip => 3, :headers => false)
      t.entries.each do |row|
        results << OpenStruct.new(:abbrev => row[0], :name => row[2])
      end
      results
    end

    def party_labels_2000
      results = []
      t = RemoteTable.new(FecResults::PRESIDENT_URLS[year.to_s].first, :sheet => 'Guide to 2000 Party Labels', :headers => false)
      t.entries.each do |row|
        results << OpenStruct.new(:abbrev => row[0], :name => row[2])
      end
      results
    end

  end
end