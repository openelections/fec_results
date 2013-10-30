module FecResults
  class President

    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
      @url = FecResults::PRESIDENT_URLS[year.to_s]
    end

    def popular_vote_summary(*args)
      send("popular_vote_summary_#{year}", *args)
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


  end
 end