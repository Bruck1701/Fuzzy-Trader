class InvestmentassetsController < ApplicationController
  before_action :require_login
  before_action :set_investmentasset, only: [:show, :edit, :update, :destroy]

 
  def index
    portfolio = Portfolio.where(:user_id => current_user.id)[0]
    @investmentassets = Investmentasset.where(:portfolio_id => portfolio.id)
  end

 
  def show
  end

 
  def new
    @investmentasset = Investmentasset.new
  end

 
  def edit
  end



  # POST /investmentassets
  # POST /investmentassets.json
  def create
    
    queryChoice = investmentasset_params[:name]
    queryresult= Queryresult.find(queryChoice)

    #portfolio_id = queryresult.aquery.user_id

    portfolio = Portfolio.where(:user_id => current_user.id)[0]


    valueToUse  = investmentasset_params[:qty].to_f
    
    # first step is to update the price of all assets with the CurrentValue model, which was updated during the query.
    # Another backend solution would be necessary to update the CurrentValue from time to time and not only when the client performs a query

    assetz = Investmentasset.all
    if assetz.length >= 1
      assetz.each do |a|
        newValue = Currentvalue.where(:name =>a.name)[0].value
        a.totalcurrval = a.qty * newValue
        a.save
      end
    end


    # calc how much should go into the the assets and how much is to remain on the checking account.
    # if the investment is to be made on crypto currency, it invests all the money, since you can purchase a fraction 
    # of crypto. Else it will purchase the max possible number of shares and deposit the remaining value on 
    # checking account of the porfolio to be withdrawn
    portfolioChkAccount =0
    pcryptoAsts = portfolio.cryptoAssets
    pshareAsts = portfolio.shareAssets




    if queryresult.qrcategory == "cryptoCurrency"
      pcryptoAsts += 1

      qty = valueToUse/queryresult.qrcurrentvalue
    else
      if valueToUse < queryresult.qrcurrentvalue
        redirect_to portfolios_path, notice: 'Value not compatible' and return
      else
        qty = (valueToUse/queryresult.qrcurrentvalue).to_i
        portfolioChkAccount = valueToUse % queryresult.qrcurrentvalue
        pshareAsts +=1
      end

    end

    totalCurrentValue = qty*queryresult.qrcurrentvalue
    

    @investmentasset = Investmentasset.new(:portfolio_id => portfolio.id,
     :category => queryresult.qrcategory, :name=> queryresult.qrname,
     :purchaseValue => queryresult.qrcurrentvalue,
     :qty => qty, :totalcurrval => totalCurrentValue)


      respond_to do |format|
        if @investmentasset.save
          format.html { redirect_to @investmentasset, notice: 'Investmentasset was successfully created.' }
          format.json { render :show, status: :created, location: @investmentasset }


          assetz = Investmentasset.where(:portfolio_id => portfolio.id)

          portfolio.totalInv = portfolio.totalInv + totalCurrentValue
          portfolio.currentVal =  assetz.sum(:totalcurrval)
          portfolio.cryptoAssets = pcryptoAsts
          portfolio.shareAssets = pshareAsts
          portfolio.totalAssets = portfolio.totalAssets + 1
          portfolio.checkingacc = portfolio.checkingacc + portfolioChkAccount
          portfolio.save


        else
          format.html { render :new }
          format.json { render json: @investmentasset.errors, status: :unprocessable_entity }
        end
      end
  end


 
  def destroy

    portfolio = Portfolio.find(@investmentasset.portfolio_id)

    portfolio.totalInv -= (@investmentasset.qty * @investmentasset.purchaseValue)


    if @investmentasset.category == 'cryptoCurrency'
      portfolio.cryptoAssets -=1 
    else
      portfolio.shareAssets -=1 
    end  
    portfolio.totalAssets -=1

    portfolio.checkingacc = @investmentasset.totalcurrval
    
    @investmentasset.destroy
    
    assetz = Investmentasset.where(:portfolio_id => portfolio.id)
    portfolio.currentVal =  assetz.sum(:totalcurrval)
    portfolio.save

    respond_to do |format|
      format.html { redirect_to investmentassets_url, notice: 'Asset was succesfully sold.' }
      format.json { head :no_content }
    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_investmentasset
      @investmentasset = Investmentasset.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def investmentasset_params
      params.require(:investmentasset).permit(:porfolio_id, :category, :name, :qty, :purchaseValue)
      
      

    end
end
