class AqueriesController < ApplicationController
  before_action :require_login
  helper_method :is_number
  before_action :set_aquery, only: [:show, :edit, :update, :destroy]


  #checking if the value inserted by the user is a valid number,
  def is_number? string
    true if Float(string)>0.0 rescue false
  end


  def index
    @aqueries = Aquery.where(:user_id=>current_user.id)
  end

  
  def show
  end


  # GET /aqueries/new
  def new
    @aqueries = Aquery.where(:user_id=>current_user.id)
    if @aqueries.length>=1
      @aqueries.delete_all
    end

    @aquery = Aquery.new
  end

  # GET /aqueries/1/edit
  def edit
  end


  def create
    
    @aquery = Aquery.new(aquery_params)
    @aquery[:user_id] = current_user.id
    
    if is_number?(@aquery.query_value)
     # once we have confirmed that the value is correct, we proceed to get data to queryResult
      

      respond_to do |format|
        if @aquery.save

          query_id= p @aquery.id
          begin

            apiData = ExternalData.new(query_id,@aquery.query_value)
            rows = p apiData.rows
            
            rows.each do |entry|
              queryresult = Queryresult.new(entry)
              queryresult.save
            end

            format.html { redirect_to :portfolios, notice: 'query successful.' }
            format.json { render :show, status: :created, location: @aquery } 

          rescue => e
            format.html { render :new }
            format.json { render json: @aquery.errors, notice: 'Oops! There was an error in one of the APIs response. Try again later.' }
          end
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

    end




end
