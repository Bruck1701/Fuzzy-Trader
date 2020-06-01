class PortfoliosController < ApplicationController
  before_action :require_login
  before_action :set_portfolio, only: [:show, :edit, :update, :destroy]

  
  def index


    #get the porfolio from the user and the very last query result from the user. 
    #every user has only one portfolio.
    

    @portfolio = Portfolio.where(:user_id => current_user.id)[0]
    @aquery = Aquery.where(:user_id => current_user.id)[-1]
    

    # in case the person skips the search query and jumps straight to the portfolios page 
    if @aquery.nil?
      redirect_to @portfolio and return
    end




    #update current value table to get the a new current value of the already bought investments.
    Currentvalue.delete_all
    # there was a bug here!!!  
    queryresult = Queryresult.where(:aquery_id=>@aquery.id)
    
    queryresult.each do |q|
      currval=Currentvalue.new(:name=>q.qrname,:value=>q.qrcurrentvalue)
      currval.save
    end
    
    
    @investmentasset = Investmentasset.new
    last_id = @aquery.id
    

   # for crypto currency it always show the options, since you can buy a fraction of crypto
   # for the company shares, it only returns as option the ones with smaller value.
   # although, we store in the database all the results for future research purposes.
    @queryresult = Queryresult.where(:aquery_id=>last_id).where(:qrcategory => "cryptoCurrency").or(Queryresult.where(:aquery_id=>last_id).where("qrcurrentvalue <= :qvalue", qvalue: @aquery.query_value))

  end

  def show
  end

  
  def new
    
    @investmentasset = Investmentasset.new
    
  end

  
  def destroy
    # this action actually represents a money withdrawal from the portfolio account. The portfolio cannot be destroyed.

    @portfolio.checkingacc=0.0
    @portfolio.save
    render :show
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portfolio
      @portfolio = Portfolio.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def portfolio_params
      params.require(:portfolio).permit(:user_id, :totalInv, :currentVal, :cryptoAssets, :shareAssets, :totalAssets)
    end
end
