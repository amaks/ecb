require 'ecb_calculator/ecb'
Numeric.class_eval do

  ECB = Ecb.new.todays_rates 

  ECB.keys.each do |currency|
  	method = "#{currency}_to_eur"
    define_method(method.to_sym) do 
    	self / ECB[currency].to_f 
    end     
  end

  ECB.keys.each do |currency|
  	method = "eur_to_#{currency}"
    define_method(method.to_sym) do 
    	self * ECB[currency].to_f 
    end     
  end

  ECB.keys.each do |master_currency|
  	
    ECB.keys do |currency| 
      
	  	method = "#{master_currency}_to_#{currency}"
	    define_method(method.to_sym) do 
	    	self * (ECB[currency].to_f * ECB[master_currency].to_f) 
	    end       

	  	method = "#{currency}_to_#{master_currency}"
	    define_method(method.to_sym) do 
	    	self * (ECB[currency].to_f * ECB[master_currency].to_f) 
	    end       	    		 
  	end
  end

end