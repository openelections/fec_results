module FecResults
  class Congress

    attr_reader :year, :chamber, :state

    # given a year and an optional chamber ('house' or 'senate') and state ('ar', 'az', etc.) 
    # retrieves election results that fit the criteria
    def initialize(params={})
      params.each_pair do |k,v|
       instance_variable_set("@#{k}", v)
      end
    end

    def results
      send("process_#{year}", {:chamber => chamber, :state => state})
    end

    def process_2012(options={})
      results = []
      url = FecResults::CONGRESS_URLS['2012']
      t = RemoteTable.new(url, :sheet => "2012 US House & Senate Resuts")
      rows = t.entries
      rows = rows.select{|r| r['D'] == options[:chamber]} if options[:chamber]
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        c = {:year => 2012}
        next if candidate['CANDIDATE NAME (Last)'].blank?
        next if candidate['D'].blank?
        # find the office_type
        if candidate['FEC ID#'].first != 'n'
          c[:chamber] = candidate['FEC ID#'].first
        elsif candidate['D'].first == 'S'
          c[:chamber] = "S"
        else
          c[:chamber] = 'H'
        end
        c[:state] = candidate['STATE ABBREVIATION']
        c[:district] = candidate['D']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['(I)'] == '(I)' ? true : false
        c[:fec_id] = candidate['FEC ID#']
        c[:candidate_first] = candidate['CANDIDATE NAME (First)']
        c[:candidate_last] = candidate['CANDIDATE NAME (Last)']
        c[:candidate_name] = candidate['CANDIDATE NAME']

        c = update_vote_tallies(c, candidate, 'PRIMARY VOTES', 'PRIMARY %', 'RUNOFF VOTES', 'RUNOFF %', 'GENERAL VOTES ', 'GENERAL %')
        c = update_general_runoff(c, candidate, 'GE RUNOFF ELECTION VOTES (LA)', 'GE RUNOFF ELECTION % (LA)') if c[:state] == 'LA'
        c = update_combined_totals(c, candidate, 'COMBINED GE PARTY TOTALS (CT, NY, SC)', 'COMBINED % (CT, NY, SC)') if ['CT', 'NY', 'SC'].include?(c[:state])

        c[:general_winner] = candidate['GE WINNER INDICATOR'] == "W" ? true : false unless c[:general_pct].nil?

        results << c
      end
      Result.create_congress(results)
    end

    def process_2010(options={})
      results = []
      url = FecResults::CONGRESS_URLS['2010']
      t = RemoteTable.new(url, :sheet => "2010 US House & Senate Results")
      rows = t.entries
      rows = rows.select{|r| r['DISTRICT'] == options[:chamber]} if options[:chamber]
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        c = {:year => 2010}
        next if candidate['CANDIDATE NAME (Last)'].blank?
        next if candidate['DISTRICT'].blank?
        # find the office_type
        if candidate['FEC ID#'].first != 'n'
          c[:chamber] = candidate['FEC ID#'].first
        elsif candidate['DISTRICT'].first == 'S'
          c[:chamber] = "S"
        else
          c[:chamber] = 'H'
        end
        c[:state] = candidate['STATE ABBREVIATION']
        c[:district] = candidate['DISTRICT']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['INCUMBENT INDICATOR (I)'] == '(I)' ? true : false
        c[:fec_id] = candidate['FEC ID#']
        c[:candidate_first] = candidate['CANDIDATE NAME (First)']
        c[:candidate_last] = candidate['CANDIDATE NAME (Last)']
        c[:candidate_name] = candidate['CANDIDATE NAME (Last, First)']

        c = update_vote_tallies(c, candidate, 'PRIMARY', 'PRIMARY %', 'RUNOFF', 'RUNOFF %', 'GENERAL ', 'GENERAL %')
        c = update_combined_totals(c, candidate) if ['CT', 'NY', 'SC'].include?(c[:state])

        results << c
      end
      Result.create_congress(results)
    end

    def process_2008(options={})
      results = []
      url = FecResults::CONGRESS_URLS['2008']
      t = RemoteTable.new(url, :sheet => "2008 House and Senate Results")
      rows = t.entries
      rows = rows.select{|r| r['DISTRICT'] == options[:chamber]} if options[:chamber]
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        c = {:year => 2008}
        next if candidate['Candidate Name (Last)'].blank?
        next if candidate['DISTRICT'].blank?
        # find the office_type
        if candidate['FEC ID#'].first != 'n'
          c[:chamber] = candidate['FEC ID#'].first
        elsif candidate['DISTRICT'].first == 'S'
          c[:chamber] = "S"
        else
          c[:chamber] = 'H'
        end
        c[:state] = candidate['STATE ABBREVIATION']
        c[:district] = candidate['DISTRICT']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['INCUMBENT INDICATOR (I)'] == '(I)' ? true : false
        c[:fec_id] = candidate['FEC ID#']
        c[:candidate_first] = candidate['CANDIDATE NAME (First)']
        c[:candidate_last] = candidate['CANDIDATE NAME (Last)']
        c[:candidate_name] = candidate['CANDIDATE NAME']

        c = update_vote_tallies(c, candidate, 'PRIMARY', 'PRIMARY %', 'RUNOFF', 'RUNOFF %', 'GENERAL ', 'GENERAL %')
        c = update_general_runoff(c, candidate, 'GE RUNOFF', 'GE RUNOFF %') if c[:state] == 'LA'
        c = update_combined_totals(c, candidate, 'COMBINED GE PARTY TOTALS (CT, NY)', 'COMBINED % (CT, NY)') if ['CT', 'NY'].include?(c[:state])

        results << c
      end
      Result.create_congress(results)
    end

    def process_2006(options={})
      results = []
      url = FecResults::CONGRESS_URLS['2006']
      t = RemoteTable.new(url, :sheet => "2006 US House & Senate Results")
      rows = t.entries
      rows = rows.select{|r| r['DISTRICT'] == options[:chamber]} if options[:chamber]
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        c = {:year => 2006}
        next if candidate['LAST NAME'].blank?
        next if candidate['DISTRICT'].blank?
        # find the office_type
        if candidate['FEC ID'].first != 'n'
          c[:chamber] = candidate['FEC ID'].first
        elsif candidate['DISTRICT'].first == 'S'
          c[:chamber] = "S"
        else
          c[:chamber] = 'H'
        end
        c[:state] = candidate['STATE ABBREVIATION']
        c[:district] = candidate['DISTRICT']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['INCUMBENT INDICATOR'] == '(I)' ? true : false
        c[:fec_id] = candidate['FEC ID#']
        c[:candidate_first] = candidate['FIRST NAME']
        c[:candidate_last] = candidate['LAST NAME']
        c[:candidate_name] = candidate['LAST NAME, FIRST']

        c = update_vote_tallies(c, candidate, 'PRIMARY', 'PRIMARY %', 'RUNOFF', 'RUNOFF %', 'GENERAL', 'GENERAL %')
        c = update_general_runoff(c, candidate, 'GE RUNOFF', 'GE RUNOFF %') if c[:state] == 'LA'
        c = update_combined_totals(c, candidate, 'COMBINED GE PARTY TOTALS (NY, SC)', 'COMBINED % (NY, SC)') if ['SC', 'NY'].include?(c[:state])

        results << c
      end
      Result.create_congress(results)
    end

    def process_2004(options={})
      results = []
      url = FecResults::CONGRESS_URLS['2004']
      t = RemoteTable.new(url, :sheet => "2004 US HOUSE & SENATE RESULTS")
      rows = t.entries
      rows = rows.select{|r| r['DISTRICT'] == options[:chamber]} if options[:chamber]
      rows = rows.select{|r| r['STATE ABBREVIATION'] == options[:state]} if options[:state]
      rows.each do |candidate|
        c = {:year => 2004}
        next if candidate['LAST NAME'].blank?
        next if candidate['DISTRICT'].blank?
        # find the office_type
        if candidate['FEC ID'].first != 'n'
          c[:chamber] = candidate['FEC ID'].first
        elsif candidate['DISTRICT'].first == 'S'
          c[:chamber] = "S"
        else
          c[:chamber] = 'H'
        end
        c[:state] = candidate['STATE ABBREVIATION']
        c[:district] = candidate['DISTRICT']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['INCUMBENT INDICATOR'] == '(I)' ? true : false
        c[:fec_id] = candidate['FEC ID#']
        c[:candidate_first] = candidate['FIRST NAME']
        c[:candidate_last] = candidate['LAST NAME']
        c[:candidate_name] = candidate['LAST NAME, FIRST']

        c = update_vote_tallies(c, candidate, 'PRIMARY', 'PRIMARY %', 'RUNOFF', 'RUNOFF %', 'GENERAL', 'GENERAL %')
        c = update_general_runoff(c, candidate, 'GE RUNOFF', 'GE RUNOFF %') if c[:state] == 'LA'

        results << c
      end
      Result.create_congress(results)
    end

    def process_2002(options={})
      results = []
      url = FecResults::CONGRESS_URLS['2002']
      t = RemoteTable.new(url, :sheet => "2002 House & Senate Results")
      rows = t.entries
      rows = rows.select{|r| r['DISTRICT'] == options[:chamber]} if options[:chamber]
      rows = rows.select{|r| r['STATE'] == options[:state]} if options[:state]
      rows.each do |candidate|
        c = {:year => 2002}
        next if candidate['LAST NAME'].blank?
        next if candidate['DISTRICT'].blank?
        # find the office_type
        if candidate['FEC ID'].first != 'n'
          c[:chamber] = candidate['FEC ID'].first
        elsif candidate['DISTRICT'].first == 'S'
          c[:chamber] = "S"
        else
          c[:chamber] = 'H'
        end
        c[:state] = candidate['STATE']
        c[:district] = candidate['DISTRICT']
        c[:party] = candidate['PARTY']
        c[:incumbent] = candidate['INCUMBENT INDICATOR'] == '(I)' ? true : false
        c[:fec_id] = candidate['FEC ID#']
        c[:candidate_first] = candidate['FIRST NAME']
        c[:candidate_last] = candidate['LAST NAME']
        c[:candidate_name] = candidate['LAST NAME, FIRST']

        c = update_vote_tallies(c, candidate, 'PRIMARY RESULTS', 'PRIMARY %', 'RUNOFF RESULTS', 'RUNOFF %', 'GENERAL RESULTS', 'GENERAL %')
        c = update_combined_totals(c, candidate, 'COMBINED GE PARTY TOTALS (NY, SC)', 'COMBINED % (NY, SC)') if ['SC', 'NY'].include?(c[:state])

        results << c
      end
      Result.create_congress(results)
    end

    def process_2000(options={})
      results = []
      urls = FecResults::CONGRESS_URLS['2000']
      urls.each do |url|
        t = RemoteTable.new(url.keys.first, :sheet => url.values.first)
        rows = t.entries
        rows = rows.select{|r| r['STATE'] == options[:state]} if options[:state]
        rows.each do |candidate|
          c = {:year => 2000}
          next if candidate['NAME'][0..4] == 'Total'
          next if candidate['DISTRICT'].blank?
          if candidate['DISTRICT'].first == 'S'
            c[:chamber] = "S"
          else
            c[:chamber] = 'H'
          end
          c[:state] = candidate['STATE']
          c[:district] = candidate['DISTRICT']
          c[:party] = candidate['PARTY']
          c[:incumbent] = candidate['INCUMBENT INDICATOR'] == '(I)' ? true : false
          c[:candidate_first], c[:candidate_last] = candidate['NAME'].split(', ')
          c[:candidate_name] = candidate['NAME']

          c = update_vote_tallies(c, candidate, 'PRIMARY RESULTS', 'PRIMARY %', 'RUNOFF RESULTS', 'RUNOFF %', 'GENERAL RESULTS', 'GENERAL %')
          c = update_general_runoff(c, candidate, 'GENERAL RUNOFF RESULTS', 'GENERAL RUNOFF %') if c[:state] == 'LA'

          results << c
        end
      end
      if options[:chamber] == 'H'
        results = results.select{|r| r[:chamber] != 'S'}
      elsif options[:chamber] == 'S'
        results = results.select{|r| r[:chamber] == 'S'}
      end
      Result.create_congress(results)
    end


    def update_vote_tallies(c, candidate, primary_votes, primary_pct, runoff_votes, runoff_pct, general_votes, general_pct)
      if candidate[primary_votes] == 'Unopposed'
        c[:primary_unopposed] = true
        c[:primary_votes] = nil
        c[:primary_pct] = 100.0
      else
        c[:primary_unopposed] = false
        c[:primary_votes] = candidate[primary_votes].to_i
        c[:primary_pct] = candidate[primary_pct].to_f*100.0
      end

      if candidate[runoff_votes].blank?
        c[:runoff_votes] = nil
        c[:runoff_pct] = nil
      else
        c[:runoff_votes] = candidate[runoff_votes].to_i
        c[:runoff_pct] = candidate[runoff_pct].to_f*100.0
      end

      if candidate[general_votes] == 'Unopposed'
        c[:general_unopposed] = true
        c[:general_votes] = nil
        c[:general_pct] = 100.0
      elsif candidate[general_votes].blank?
        c[:general_unopposed] = false
        c[:general_votes] = nil
        c[:general_pct] = nil
      else
        c[:general_unopposed] = false
        c[:general_votes] = candidate[general_votes].to_i
        c[:general_pct] = candidate[general_pct].to_f*100.0
      end
      c
    end

    def update_general_runoff(c, candidate, general_runoff_votes, general_runoff_pct)
      unless candidate[general_runoff_votes].blank?
        c[:general_runoff_votes] = candidate[general_runoff_votes].to_i
        c[:general_runoff_pct] = candidate[general_runoff_pct].to_f*100.0
      end
      c
    end

    def update_combined_totals(c, candidate, general_combined_party_votes, general_combined_party_pct)
      unless candidate[general_combined_party_votes].blank?
        c[:general_combined_party_votes] = candidate[general_combined_party_votes].to_i
        c[:general_combined_party_pct] = candidate[general_combined_party_pct].to_f*100.0
      end
      c
    end

  end
end