require 'net/http'
require 'rexml/document'
require 'ecb_calculator/rates_store'

class Ecb

	def url
		'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'		
	end

	def todays_rates
		store = RatesStore.new.read_rates_date
		store.present? && store[:date] == Date.today ? store[:rates] : get_rates_and_store
	end

	private 

		def get_rates
			xml_data = Net::HTTP.get_response(URI.parse(url)).body
			parse_xml(xml_data)
		end

		def parse_xml(xml_data)
			doc = REXML::Document.new(xml_data)
			rates = {}
			doc.elements.each('*/Cube/Cube/Cube') do |ele|
			  rates[ele.attributes['currency'].downcase] = ele.attributes['rate']
			end
			return rates
		end

		def get_rates_and_store
			rates = get_rates
			RatesStore.new.store_rates(rates)
			return rates			
		end
end
