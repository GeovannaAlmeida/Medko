class PaymentsController < ApplicationController

  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  skip_before_filter  :verify_authenticity_token


  def generate_billet
      @boleto = Brcobranca::Boleto::BancoBrasil.new     
      @boleto.cedente = "nome de quem vai receber" #Nome do proprietario da conta corrente
      @boleto.documento_cedente = "documento de quem vai receber"
      @boleto.sacado = current_user.name
      @boleto.sacado_documento = current_user.bank_account.collect(&:cpf_cnpj).join(", ")
      @boleto.avalista = "nome do avalista"
      @boleto.avalista_documento = "documento do avalista"
      @boleto.valor = params["payment"]
      @boleto.agencia = "3342" #agencia de quem vai receber
      @boleto.conta_corrente = "33421" #Número da conta corrente sem Digito Verificador
      @boleto.variacao = "19" 
      @boleto.carteira == "19" #Tipo de conta
      @boleto.quantidade ="01" #Quantidade de boletos
      @boleto.convenio = "1238798"  #Número do convênio/contrato do cliente junto ao banco emissor
      @boleto.numero_documento = current_user.id
      @boleto.data_vencimento = Date.today + 7.day
      @boleto.data_documento = Date.today
      @boleto.local_pagamento ="Pagável em qualquer banco até o vencimento. Após, atualize o boleto no site bb.com.br."
      @boleto.instrucao1 = "Pagável na rede bancária até a data de vencimento."
      @boleto.instrucao2 = "Juros de mora de 2.0% mensal(R$ 0,09 ao dia)"
      @boleto.instrucao3 = "Após vencimento,atualize o boleto no site bb.com.br."
      @boleto.instrucao4 = "ACRESCER R$ 4,00 REFERENTE AO BOLETO BANCÁRIO"
      @boleto.sacado_endereco = current_user.address + "-" + current_user.zip_code

      send_data @boleto.to(:pdf), :filename => "boleto_medko.#{:pdf}"
  end

  # GET /payments
  # GET /payments.json
   def index
     respond_to do |format|
      format.html { 
        if current_user.account_type_id == 3
           @payments = Payment.where(user_id: current_user)
        else
          @payments = Payment.all
        end  
      }
      format.js {
       if current_user.account_type_id == 3
          @payments = Payment.search_payment(params['search']).where(user_id: current_user)
          return @payments
        else 
          @payments = Payment.search_payment(params['search']).all
          return @payments
        end
      }
    end
end
  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  def confirm_payment
    payment_period = PaymentPeriod.find(params['payment']['id'])
      payment_period.accomplished = true
      payment_period.save
      respond_to do |format|
        format.js { render nothing: true } 
     end   
  end


  def confirm_receipt
    receipt_period = ReceiptPeriod.find(params['payment']['id'])
      receipt_period.accompliched = true
      receipt_period.save
      respond_to do |format|
        format.js { render nothing: true } 
     end   
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:price,:user_id)
    end
end
