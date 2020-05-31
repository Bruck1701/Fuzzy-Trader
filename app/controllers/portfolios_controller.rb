class PortfoliosController < ApplicationController
  before_action :require_login
  before_action :set_portfolio, only: [:show, :edit, :update, :destroy]

  
  def index


    #get the porfolio from the user and the quey result
    
    

    @portfolio = Portfolio.where(:user_id => current_user.id)[0]


    @aquery = Aquery.where(:user_id => current_user.id)[-1]
    
    #update current value table.
    Currentvalue.delete_all
    
    queryresult = Queryresult.all
    
    queryresult.each do |q|
      currval=Currentvalue.new(:name=>q.qrname,:value=>q.qrcurrentvalue)
      currval.save
    end
    
    
    @investmentasset = Investmentasset.new
    last_id = @aquery.id
    

    # for crypto currency it always show the options, since you can buy a fraction of crypto
    @queryresult = Queryresult.where(:aquery_id=>last_id).where(:qrcategory => "cryptoCurrency").or(Queryresult.where(:aquery_id=>last_id).where("qrcurrentvalue <= :qvalue", qvalue: @aquery.query_value))

  end


  def show
  end

  # GET /portfolios/new
  def new
    
    @investmentasset = Investmentasset.new
    
  end

  
  def destroy
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
