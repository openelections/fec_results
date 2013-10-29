require 'rubygems'
require 'remote_table'
require 'ostruct'

module FecResults
  class Summary
    
    attr_reader :year, :url
    
    def new(year)
      @year = year.to_i
      @url = FecResults::SUMMARY_URLS[year.to_s]
    end
        
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
    
    def process_general_election_votes_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 3.GEVotes for Pres, H & S', :skip => 2)
      t.entries.each do |row|
        pres_votes = row['Presidential Vote'].to_i == 0 ? nil : row['Presidential Vote'].to_i
        sen_votes = row['U.S. Senate Vote'].to_i == 0 ? nil : row['U.S. Senate Vote'].to_i
        results << OpenStruct.new(:state => row['State'], :presidential_votes => pres_votes, :senate_votes => sen_votes, :house_votes => row['U.S. House Vote'].to_i)
      end
      results
    end
    
    def process_general_election_votes_by_party_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 4. GE Votes Cast by Party', :skip => 3)
      t.entries.each do |row|
        dem_votes = row['Democratic Candidates'].to_i == 0 ? nil : row['Democratic Candidates'].to_i
        gop_votes = row['Republican Candidates'].to_i == 0 ? nil : row['Republican Candidates'].to_i
        other_votes = row['Other Candidates'].to_i == 0 ? nil : row['Other Candidates'].to_i
        results << OpenStruct.new(:state => row['State'], :democratic_candidates => dem_votes, :republican_candidates => gop_votes, :other_candidates => other_votes)
      end
      results
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
    
    # columns are obama electoral, romney electoral, obama popular, romney popular, all others popular, total popular
    def process_presidential_electoral_and_popular_vote_2012(options={})
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 2. Electoral &  Pop Vote', :skip => 4, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        dem_electoral = row[1].to_i == 0 ? nil : row[1].to_i
        gop_electoral = row[2].to_i == 0 ? nil : row[2].to_i
        dem_popular = row[3].to_i == 0 ? nil : row[3].to_i
        gop_popular = row[4].to_i == 0 ? nil : row[4].to_i
        others_popular = row[5].to_i == 0 ? nil : row[5].to_i
        total_popular = row[6].to_i == 0 ? nil : row[6].to_i
        results << OpenStruct.new(:state => row[0], :democratic_electoral_votes => dem_electoral, :republican_electoral_votes => gop_electoral, :democratic_popular_votes => dem_popular, 
        :republican_popular_votes => gop_popular, :others_popular => others_popular, :total_popular => total_popular)
      end
      results
    end
    
    # columns are dem primary, gop primary, other primary, dem general, gop general, other general
    # runoff election votes are included in the primary totals
    def process_chamber_votes_by_party_2012(options={})
      results = []
      sheet = chamber == 'senate' ? 'Table 6. Senate by Party' : 'Table 7. House by Party'
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
    

  end
end