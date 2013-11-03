require 'rubygems'
require 'remote_table'
require 'american_date'
require 'ostruct'

require "fec_results/version"
require "fec_results/congress"
require "fec_results/result"
require "fec_results/summary"
require "fec_results/president"

module FecResults

  SUMMARY_URLS = {
    '2012' => 'http://www.fec.gov/pubrec/fe2012/tables2012.xls',
    '2010' => 'http://www.fec.gov/pubrec/fe2010/tables2010.xls',
    '2008' => 'http://www.fec.gov/pubrec/fe2008/tables2008.xls',
    '2006' => 'http://www.fec.gov/pubrec/fe2006/tables06.xls',
    '2004' => 'http://www.fec.gov/pubrec/fe2004/tables.xls',
    '2002' => 'http://www.fec.gov/pubrec/fe2002/2002fedresults.xls',
    '2000' => 'http://www.fec.gov/pubrec/fe2000/tables.xls'
  }

  CONGRESS_URLS = {
    '2012' => 'http://www.fec.gov/pubrec/fe2012/2012congresults.xls',
    '2010' => 'http://www.fec.gov/pubrec/fe2010/results10.xls',
    '2008' => 'http://www.fec.gov/pubrec/fe2008/2008congresults.xls',
    '2006' => 'http://www.fec.gov/pubrec/fe2006/results06.xls',
    '2004' => 'http://www.fec.gov/pubrec/fe2004/2004congresults.xls',
    '2002' => 'http://www.fec.gov/pubrec/fe2002/2002fedresults.xls',
    '2000' => [{'http://www.fec.gov/pubrec/fe2000/senate.xls' => 'Senate (with Totals & Percent) '}, {'http://www.fec.gov/pubrec/fe2000/house.xls' => 'House (with Totals & Percents)'}]
  }

  PRESIDENT_URLS = {
    '2012' => 'http://www.fec.gov/pubrec/fe2012/2012pres.xls',
    '2008' => 'http://www.fec.gov/pubrec/fe2008/2008pres.xls',
    '2004' => 'http://www.fec.gov/pubrec/fe2004/2004pres.xls',
    '2000' => ['http://www.fec.gov/pubrec/fe2000/presge.xls', 'http://www.fec.gov/pubrec/fe2000/presprim.xls']
  }
end
