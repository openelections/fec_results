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
      send("state_electoral_and_popular_vote_summary_#{year}")
    end

    def popular_vote_summary_2012(*args)
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 1. 2012 Pres Popular Vote', :skip => 3)
      t.entries.each do |row|
        break if row['Candidate (Party Label)'] == 'Total:'
        results << OpenStruct.new(:candidate => row['Candidate (Party Label)'], :popular_votes => row['Popular Vote Total'].to_i, :popular_vote_percent => row['Percent of Popular Vote'].to_f)
      end
      results
    end

    def state_electoral_and_popular_vote_summary_2012(*args)
      results = []
      t = RemoteTable.new(url, :sheet => 'Table 2. Electoral &  Pop Vote', :skip => 4, :headers => false)
      t.entries.each do |row|
        break if row[0] == 'Total:'
        results << OpenStruct.new(:state => row[0], :democratic_electoral_votes => row[1].to_i, :republican_electoral_votes => row[2].to_i, :democratic_popular_votes => row[3].to_i, :republican_popular_votes => row[4].to_i, :other_popular_votes => row[5].to_i, :total_votes => row[6].to_i)
      end
      results
    end


  end
 end