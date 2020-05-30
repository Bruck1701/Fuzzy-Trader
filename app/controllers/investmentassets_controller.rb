class InvestmentassetsController < ApplicationController
  before_action :set_investmentasset, only: [:show, :edit, :update, :destroy]

  # GET /investmentassets
  # GET /investmentassets.json
  def index
    @investmentassets = Investmentasset.all
  end

  # GET /investmentassets/1
  # GET /investmentassets/1.json
  def show
  end

  # GET /investmentassets/new
  def new
    @investmentasset = Investmentasset.new
  end

  # GET /investmentassets/1/edit
  def edit
  end

  # POST /investmentassets
  # POST /investmentassets.json
  def create
    
    queryChoice = investmentasset_params[:name]
    queryresult= Queryresult.find(queryChoice)
    
    portfolio_id = queryresult.aquery.user_id
    # calculate the qty
    
    

    @investmentasset = Investmentasset.new(:porfolio_id => portfolio_id,
     :category => queryresult.qrcategory, :name=> queryresult.qrname,
     :purchaseValue => queryresult.qrcurrentvalue )

    #@investmentasset = Investmentasset.new(investmentasset_params)



    respond_to do |format|
      if @investmentasset.save
        format.html { redirect_to @investmentasset, notice: 'Investmentasset was successfully created.' }
        format.json { render :show, status: :created, location: @investmentasset }
      else
        format.html { render :new }
        format.json { render json: @investmentasset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /investmentassets/1
  # PATCH/PUT /investmentassets/1.json
  def update
    respond_to do |format|
      if @investmentasset.update(investmentasset_params)
        format.html { redirect_to @investmentasset, notice: 'Investmentasset was successfully updated.' }
        format.json { render :show, status: :ok, location: @investmentasset }
      else
        format.html { render :edit }
        format.json { render json: @investmentasset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /investmentassets/1
  # DELETE /investmentassets/1.json
  def destroy
    @investmentasset.destroy
    respond_to do |format|
      format.html { redirect_to investmentassets_url, notice: 'Investmentasset was successfully destroyed.' }
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
