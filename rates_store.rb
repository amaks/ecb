require "yaml/store"
class RatesStore

	def store_file
		"ecb_rates.yml"		
	end

	def store_rates(rates)
		store = YAML::Store.new(store_file)
		store.transaction do
		  store[:rates] = rates
		  store[:date]  = Date.today
		end		
	end

	def read_rates_date
		store = YAML::Store.new(store_file)
		store.transaction(true) do
		  store.roots.each do |data_root_name|
		    return store[data_root_name]
		  end
		end
	end
end