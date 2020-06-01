class AqueriesController < ApplicationController
  before_action :require_login
  helper_method :is_number
  before_action :set_aquery, only: [:show, :edit, :update, :destroy]


  #checking if the value inserted by the user is a valid number,
  def is_number? string
    true if Float(string)>0.0 rescue false
  end


  def request_api(url)

    response = Excon.get(url)
    if response.status !=200
      return nil
     end

    JSON.parse(response.body)

  end


  def process_hist_data(currentValue,historicResult,cryptoBool)
    
    values=[]
    # JSON Data from crypto API
    if cryptoBool
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



 def get_external_data(query_id,query_value)
  # crypto currency:
  # the API from coingecko returns the current price of a set of coins, 
  # So we need to query individually each coin to get the max value and the min value
  todayCryptoPriceURL = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin%2Cethereum%2Cmaker&vs_currencies=USD&include_market_cap=true&include_24hr_vol=true&include_24hr_change=true&include_last_updated_at=true"
  historicPriceH = "https://api.coingecko.com/api/v3/coins/"
  historicPriceT = "/market_chart?vs_currency=usd&days=90\" -H \"accept: application/json"

  
  #Alpha Vantage API limits the number of free API calls for 5 calls a minute ... thanks a lot, you miser ! !
  
  todaySharePriceURL= "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol="
  historicSharePriceH = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol="
  sharePriceTail = "&apikey=1NGHI8KCLTGK24F6"
  
  # using other provider of API to get the current closing price

  shareCurrentPriceH = "https://finnhub.io/api/v1/quote?symbol="
  shareCurrentPriceT = "&token=br8m7vvrh5ral083hvm0"
  companies = ['AAPL','TSLA','GOOGL','TWTR']
  
      
  rows=[]

  ####  crypto API Calls
  puts("...Fetching crypto currency quote data")
  requestCrypto= request_api(todayCryptoPriceURL)
  requestCrypto.keys.each do |crypto| 
   
      currentValue=requestCrypto[crypto]["usd"].to_f
      historicRequest= historicPriceH+crypto+historicPriceT
      historicResultCrypto=request_api(historicRequest)

      hashValues= process_hist_data(currentValue,historicResultCrypto,true)
      hashValues["aquery_id"]=query_id
      hashValues["qrname"]=crypto
      hashValues["qrcategory"]="cryptoCurrency"

      rows.append(hashValues)
 
  end
  
  ### 
  puts("...Fetching company shares quote data")
  companies.each do |company|

    request = shareCurrentPriceH+company+shareCurrentPriceT
    currentValue = request_api(request)["c"].to_f
     
    historicRequest = historicSharePriceH+company+sharePriceTail
    historicResultShare = request_api(historicRequest)["Time Series (Daily)"]
 
    hashValues=process_hist_data(currentValue,historicResultShare,false)
    hashValues["aquery_id"] = query_id
    hashValues["qrname"] = company
    hashValues["qrcategory"] = "companyShare"

    
    rows.append(hashValues)


  end



  return rows

 end 


  def index
    @aqueries = Aquery.where(:user_id=>current_user.id)
  end

  
  def show
  end




  # GET /aqueries/new
  def new
    @aquery = Aquery.new
  end

  # GET /aqueries/1/edit
  def edit
  end

  # POST /aqueries
  # POST /aqueries.json
  def create
    
    @aquery = Aquery.new(aquery_params)
    @aquery[:user_id] = current_user.id
    
    if is_number?(@aquery.query_value)

   

     # once we have confirmed that the value is correct, we proceed to get data to queryResult
    
     

      respond_to do |format|
        if @aquery.save

          query_id= p @aquery.id
          begin
          rows = get_external_data(query_id,@aquery.query_value)
          rescue => e
            format.html { render :new }
            format.json { render json: @aquery.errors, notice: 'Oops! There was an error in one of the APIs response. Try again later.' }
          end
          
          rows.each do |entry|
            @queryresult = Queryresult.new(entry)
            @queryresult.save
          end

          format.html { redirect_to :portfolios, notice: 'query successful.' }
          format.json { render :show, status: :created, location: @aquery }
        
        else
          format.html { render :new }
          format.json { render json: @aquery.errors, status: :unprocessable_entity }
        end
      end
     

    else
      render :new, :notice => "Invalid Number"

    end

    

  end


  def destroy

    query_id=params[:id]
    Queryresult.where(:aquery_id =>query_id).destroy_all

    @aquery.destroy


    respond_to do |format|
      format.html { redirect_to aqueries_url, notice: 'Aquery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aquery
      @aquery = Aquery.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def aquery_params
      params.require(:aquery).permit(:query_value)

      #temp fix to associate the query to the user 1
      #params[:aquery][:user_id] => 1

    end
end
