class ReceiptPeriodsController < ApplicationController
  before_action :set_receipt_period, only: [:show, :edit, :update, :destroy]
before_action :authenticate_user!
  # GET /receipt_periods
  # GET /receipt_periods.json
  def index
    @receipt_periods = ReceiptPeriod.all
  end

  # GET /receipt_periods/1
  # GET /receipt_periods/1.json
  def show
  end

  # GET /receipt_periods/new
  def new
    @receipt_period = ReceiptPeriod.new
  end

  # GET /receipt_periods/1/edit
  def edit
  end

  # POST /receipt_periods
  # POST /receipt_periods.json
  def create
    @receipt_period = ReceiptPeriod.new(receipt_period_params)

    respond_to do |format|
      if @receipt_period.save
        format.html { redirect_to @receipt_period, notice: 'Receipt period was successfully created.' }
        format.json { render :show, status: :created, location: @receipt_period }
      else
        format.html { render :new }
        format.json { render json: @receipt_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipt_periods/1
  # PATCH/PUT /receipt_periods/1.json
  def update
    respond_to do |format|
      if @receipt_period.update(receipt_period_params)
        format.html { redirect_to @receipt_period, notice: 'Receipt period was successfully updated.' }
        format.json { render :show, status: :ok, location: @receipt_period }
      else
        format.html { render :edit }
        format.json { render json: @receipt_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipt_periods/1
  # DELETE /receipt_periods/1.json
  def destroy
    @receipt_period.destroy
    respond_to do |format|
      format.html { redirect_to receipt_periods_url, notice: 'Receipt period was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt_period
      @receipt_period = ReceiptPeriod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receipt_period_params
      params.require(:receipt_period).permit(:start_date, :end_date, :accompliched, :user_id)
    end
end
