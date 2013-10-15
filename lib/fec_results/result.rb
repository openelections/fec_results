module FecResults
  class Result

    attr_reader :year, :chamber, :state, :district, :fec_id, :incumbent, :candidate_last, :candidate_first, :candidate_name, :party,
    :primary_votes, :primary_pct, :primary_unopposed, :runoff_votes, :runoff_pct, :general_votes, :general_pct, :general_unopposed, 
    :general_runoff_votes, :general_runoff_pct, :general_combined_party_votes, :general_combined_party_pct, :general_winner, :notes

    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
    end

    def self.create_congress(results)
      results.map{|r|  
      self.new :year => r[:year],
               :chamber => r[:chamber], 
               :state => r[:state], 
               :district => r[:district], 
               :fec_id => r[:fec_id], 
               :incumbent => r[:incumbent], 
               :candidate_last => r[:candidate_last], 
               :candidate_first => r[:candidate_first], 
               :candidate_name => r[:candidate_name], 
               :party => r[:party],
               :primary_votes => r[:primary_votes], 
               :primary_pct => r[:primary_pct],
               :primary_unopposed => r[:primary_unopposed],
               :runoff_votes => r[:runoff_votes], 
               :runoff_pct => r[:runoff_pct], 
               :general_votes => r[:general_votes], 
               :general_pct => r[:general_pct],
               :general_unopposed => r[:general_unopposed],
               :general_runoff_votes => r[:general_runoff_votes], 
               :general_runoff_pct => r[:general_runoff_pct],
               :general_combined_party_votes => r[:general_combined_party_votes], 
               :general_combined_party_pct => r[:general_combined_party_pct], 
               :general_winner => r[:general_winner], 
               :notes => r[:notes]}
    end
  end
 end