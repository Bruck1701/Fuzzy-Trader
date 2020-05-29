class AqueriesController < ApplicationController


  
  
  
  helper_method :is_number
  before_action :set_aquery, only: [:show, :edit, :update, :destroy]

  def is_number? string
    true if Float(string)>0.0 rescue false
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


      respond_to do |format|
        if @aquery.save
          format.html { redirect_to @aquery, notice: 'Aquery was successfully created.' }
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
