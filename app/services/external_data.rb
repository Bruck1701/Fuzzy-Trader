class ExternalData
    

    attr_reader :rows 
    

    def initialize(query_id,query_value)

        @rows = []

        
        alpha_api_key = ENV["alpha_vantage_api_key"]
        finnhub_api_key = ENV["finnhub_api_key"]
      
        # crypto currency:
        # the API from coingecko returns the current price of a set of coins, 
        # So we need to query individually each coin to get the max value and the min value
        todayCryptoPriceURL = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin%2Cethereum%2Cmaker&vs_currencies=USD&include_market_cap=true&include_24hr_vol=true&include_24hr_change=true&include_last_updated_at=true"
        historicPriceH = "https://api.coingecko.com/api/v3/coins/"
        historicPriceT = "/market_chart?vs_currency=usd&days=90\" -H \"accept: application/json"
      
        
        #Alpha Vantage API limits the number of free API calls for 5 calls a minute ... thanks a lot, you miser ! !
        
        todaySharePriceURL= "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol="
        historicSharePriceH = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol="
        sharePriceTail = "&apikey="+alpha_api_key
        
        # using other provider of API to get the current closing price
      
        shareCurrentPriceH = "https://finnhub.io/api/v1/quote?symbol="
        shareCurrentPriceT = "&token="+finnhub_api_key
        companies = ['AAPL','TSLA','GOOGL','TWTR']

        puts(">>> HERE 1")
                   
              
        ####  crypto API Calls
        
        requestCrypto= self.class.request_api(todayCryptoPriceURL)

       
        requestCrypto.keys.each do |crypto| 
         
            currentValue=requestCrypto[crypto]["usd"].to_f
            historicRequest= historicPriceH+crypto+historicPriceT
            historicResultCrypto=self.class.request_api(historicRequest)
      
            hashValues= self.class.process_historical_data(currentValue,historicResultCrypto,true)
            hashValues["aquery_id"]=query_id
            hashValues["qrname"]=crypto
            hashValues["qrcategory"]="cryptoCurrency"
           

            @rows.append(hashValues)
           
       
        end

        
        
         companies.each do |company|
      
          request = shareCurrentPriceH+company+shareCurrentPriceT
          currentValue = self.class.request_api(request)["c"].to_f
           
          historicRequest = historicSharePriceH+company+sharePriceTail
          historicResultShare = self.class.request_api(historicRequest)["Time Series (Daily)"]
       
          hashValues=self.class.process_historical_data(currentValue,historicResultShare,false)
          hashValues["aquery_id"] = query_id
          hashValues["qrname"] = company
          hashValues["qrcategory"] = "companyShare"
          
          @rows.append(hashValues)
      
        end
        
        
      
    end 




    def self.request_api(url)


        response = Excon.get(url)
        if response.status !=200
          return nil
         end    
        JSON.parse(response.body)
    
    end
    
    
    def self.process_historical_data(currentValue,historicResult,isCrypto)
        
        values=[]
        # JSON Data from crypto API
        if isCrypto
          historicResult["prices"].each do |price|
            values.append(price[1].to_f)
          end
          period=90
          
        else
          #JSON Data from stock market API
          historicResult.each do |date,value|
            #puts(date)
            values.append(value["4. close"].to_f)
          end
          period=180
        end
      
        maxValue=values.max
        minValue=values.min
        average = values.sum.to_f/values.size.to_f
        
        
    
        recommendation=0
    
        if currentValue >= (maxValue*0.95)
          # If the current value is equal or larger than 95% of the highest price of the period, 
          # it receives a naive negative recommendation
          recommendation = -1    
        
        elsif currentValue <= (minValue*1.2)
          # If the current value is smaller than 120% of the lowest prices of the period, it receives a positive recommendation
          recommendation = 1
        end
    
        return {"qrcurrentvalue" => currentValue,"qrhigh"=>maxValue,"qrlow"=>minValue, "qrrecom"=>recommendation,"qraverage"=>average,"qravgperiod"=>period }
    
    end
     


    

end