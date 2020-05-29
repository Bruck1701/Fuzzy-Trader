class AqueriesController < ApplicationController


  
  
  
  helper_method :is_number
  before_action :set_aquery, only: [:show, :edit, :update, :destroy]

  def is_number? string
    true if Float(string)>0.0 rescue false
  end


  def request_api(url)
    response = Excon.get(url)
    # puts(response.status)
    # puts(response.body)
     if response.status !=200
      #puts(response)
      return nil
     end


    JSON.parse(response.body)

  end


  def process_hist_data(currentValue,historicResult,cryptoBool)
    
    values=[]
    
    if cryptoBool
      historicResult["prices"].each do |price|
        values.append(price[1].to_f)
      end
      
    else
      
      historicResult.each do |date,value|
        #puts(date)
        values.append(value["4. close"].to_f)
      end

    end
  
    maxValue=values.max
    minValue=values.min
    
    puts(currentValue.class)
    puts(maxValue.class)

    recommendation=0

    if currentValue >= (maxValue*0.8)
      recommendation = -1    
    elsif currentValue <= (minValue*1.2)
      recommendation = 1
    end

    return {"qrcurrentvalue" => currentValue,"qrsixhigh"=>maxValue,"qrsixlow"=>minValue, "qrrecom"=>recommendation }

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
  
  # qrname: string, qrcategory: string, qrcurrentvalue: float, qrsixhigh: float, qrsixlow: float, qrrecom: integer
    
  rows=[]

  ####  crypto API Calls
  
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
  
  

  companies.each do |company|
    request = shareCurrentPriceH+company+shareCurrentPriceT
    puts(request)
    currentValue = request_api(request)["c"].to_f
    

    puts(currentValue)
    puts(currentValue.class)
    
    historicRequest = historicSharePriceH+company+sharePriceTail
    
    historicResultShare = request_api(historicRequest)["Time Series (Daily)"]
    #puts(historicResultShare)

    hashValues=process_hist_data(currentValue,historicResultShare,false)
    hashValues["aquery_id"] = query_id
    hashValues["qrname"] = company
    hashValues["qrcategory"] = "companyShare"

    #puts(hashValues)
    rows.append(hashValues)


  end



  return rows

 end 




  # GET /aqueries
  # GET /aqueries.json
  def index
    @aqueries = Aquery.all
  end

  
  
  
  # GET /aqueries/1
  # GET /aqueries/1.json
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
    
    if is_number?(@aquery.query_value)

   

    # once we have confirmed that the value is correct, we proceed to get data to queryResult
    
    #@queryresult = Queryresult.new()
    # aquery_id: integer, qrname: string, qrcategory: string, qrcurrentvalue: float, qrsixhigh: float, qrsixlow: float, qrrecom: integer

      respond_to do |format|
        if @aquery.save
          format.html { redirect_to @aquery, notice: 'Aquery was successfully created.' }
          format.json { render :show, status: :created, location: @aquery }
        else
          format.html { render :new }
          format.json { render json: @aquery.errors, status: :unprocessable_entity }
        end
      end
      query_id= p @aquery.id
      rows = get_external_data(query_id,@aquery.query_value)
      puts(rows[0])

      @queryresult = Queryresult.new(rows[0])
      @queryresult.save


    else
      render :new, :notice => "Invalid Number"

    end

    

  end

  # PATCH/PUT /aqueries/1
  # PATCH/PUT /aqueries/1.json
  # def update
  #   respond_to do |format|
  #     if @aquery.update(aquery_params)
  #       format.html { redirect_to @aquery, notice: 'Aquery was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @aquery }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @aquery.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /aqueries/1
  # # DELETE /aqueries/1.json
  def destroy
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
    end
end
