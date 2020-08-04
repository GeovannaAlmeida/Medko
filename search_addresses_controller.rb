class SearchAddressesController < ApplicationController
  before_action :set_search_address, only: [:show, :edit, :update, :destroy]
before_action :authenticate_user!
    skip_before_filter  :verify_authenticity_token
  # GET /search_addresses
  # GET /search_addresses.json
  def index
    @search_addresses = SearchAddress.all
  end

  # GET /search_addresses/1
  # GET /search_addresses/1.json
  def show
  end

  # GET /search_addresses/new
  def new
    @search_address = SearchAddress.new
    @attendence = @search_address.attendence.build
  end

  # GET /search_addresses/1/edit
  def edit
  end

  # POST /search_addresses
  # POST /search_addresses.json
  def create
    @search_address = SearchAddress.new(search_address_params)
    
    respond_to do |format|
      if @search_address.save
        @attendence.save
        format.html { redirect_to @search_address, notice: 'Search address was successfully created.' }
        format.json { render :show, status: :created, location: @search_address }
      else
        format.html { render :new }
        format.json { render json: @search_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /search_addresses/1
  # PATCH/PUT /search_addresses/1.json
  def update
    respond_to do |format|
      if @search_address.update(search_address_params)
        format.html { redirect_to @search_address, notice: 'Search address was successfully updated.' }
        format.json { render :show, status: :ok, location: @search_address }
      else
        format.html { render :edit }
        format.json { render json: @search_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /search_addresses/1
  # DELETE /search_addresses/1.json
  def destroy
    @search_address.destroy
    respond_to do |format|
      format.html { redirect_to search_addresses_url, notice: 'Search address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search_address
      @search_address = SearchAddress.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_address_params
      params.require(:search_address).permit(:address, :complement, :latitude, :longitude, :user_id)
    end
end
