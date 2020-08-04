class PaymentPeriodsController < ApplicationController
  before_action :set_payment_period, only: [:show, :edit, :update, :destroy]

  # GET /payment_periods
  # GET /payment_periods.json
  def index
    @payment_periods = PaymentPeriod.where(user_id: current_user).order("start_date DESC")
    payment_period = PaymentPeriod.new
    payment_period = PaymentPeriod.month_valor_pagseguro  
  end

  # GET /payment_periods/1
  # GET /payment_periods/1.json
  def show
  end

  # GET /payment_periods/new
  def new
    @payment_period = PaymentPeriod.new
  end

  # GET /payment_periods/1/edit
  def edit
  end

  # POST /payment_periods
  # POST /payment_periods.json
  def create
    @payment_period = PaymentPeriod.new(payment_period_params)

    respond_to do |format|
      if @payment_period.save
        format.html { redirect_to @payment_period, notice: 'Payment period was successfully created.' }
        format.json { render :show, status: :created, location: @payment_period }
      else
        format.html { render :new }
        format.json { render json: @payment_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_periods/1
  # PATCH/PUT /payment_periods/1.json
  def update
    respond_to do |format|
      if @payment_period.update(payment_period_params)
        format.html { redirect_to @payment_period, notice: 'Payment period was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_period }
      else
        format.html { render :edit }
        format.json { render json: @payment_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_periods/1
  # DELETE /payment_periods/1.json
  def destroy
    @payment_period.destroy
    respond_to do |format|
      format.html { redirect_to payment_periods_url, notice: 'Payment period was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_period
      @payment_period = PaymentPeriod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_period_params
      params.require(:payment_period).permit(:start_date, :end_date, :accomplished)
    end
end
