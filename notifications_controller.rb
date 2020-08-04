class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create

    logger.info "CHEGOU NOTIFICAÇÃO PAGSEGURO"

    credentials = PagSeguro::AccountCredentials.new('augustuscosta@gmail.com', '2611659A82DE4AAC98F5C5F26E93F42C')

    options = { credentials: credentials } # Unnecessary if you set in application config

    transaction = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode], options)

    
    if transaction.errors.empty?
      # Processa a notificação. A melhor maneira de se fazer isso é realizar
      # o processamento em background. Uma boa alternativa para isso é a
      # biblioteca Sidekiq.
      log_pagseguro_transaction(transaction)

      # Aqui deve ser buscado ou iniciado um objeto para armazenar os dados 
      # básicos da transação pelo código da transação do pagseguro transaction.code
      # utilizando o método do Active Model find_or_initialize
      # deve ser setado no obeto os dados: status = transaction.status.status, e o id 
      # do produto que vai estar no transaction.reference e o codigo da transacao transaction.code

      status = transaction.status.status.to_s

      if status == "paid"
        logger.info "PAGAMENTO CONFIRMADO"
        
        attendence = Attendence.find_by_id(transaction.reference)
        attendence.attendence_status_id = 1
        attendence.date = DateTime.now + 1.hour
        attendence.save
      
        # Aqui deve ser buscado o produto pelo id (o id do produto vai estar em transaction.reference).
        # O estado deve ser modificado para agendando e o horário do atendimento para do momento atual + 1 hora.

   end


    else
      logger.info "ERRO"
      logger.info transaction.errors.join("\n")
    end

    render nothing: true, status: 200
  end


  private

  def log_pagseguro_transaction(transaction)
        logger.info "=> Transaction"
        logger.info "  code: #{transaction.code}"
        logger.info "  type: #{transaction.type_id}"
        logger.info "  reference: #{transaction.reference}"
        logger.info "  status: #{transaction.status.status}"
        logger.info "  cancellation source: #{transaction.cancellation_source}"
        logger.info "  escrow end date: #{transaction.escrow_end_date}"
        logger.info "  payment method type: #{transaction.payment_method.type}"
        logger.info "  gross amount: #{transaction.gross_amount.to_f}"
        logger.info "  discount amount: #{transaction.discount_amount.to_f}"
        logger.info "  operational fee amount: #{transaction.creditor_fees.operational_fee_amount.to_f}"
        logger.info "  installment fee amount: #{transaction.creditor_fees.installment_fee_amount.to_f}"
        logger.info "  intermediation rate amount: #{transaction.creditor_fees.intermediation_rate_amount.to_f}"
        logger.info "  intermediation fee amount: #{transaction.creditor_fees.intermediation_fee_amount.to_f}"
        logger.info "  commission fee amount: #{transaction.creditor_fees.commission_fee_amount.to_f}"
        logger.info "  commission fee amount: #{transaction.creditor_fees.commission_fee_amount.to_f}"
        logger.info "  efrete: #{transaction.creditor_fees.efrete.to_f}"
        logger.info "  net amount: #{transaction.net_amount.to_f}"
        logger.info "  extra amount: #{transaction.extra_amount.to_f}"

        logger.info "    => Payments"
        logger.info "      installment count: #{transaction.installments}"
        transaction.payment_releases.each do |release|
          logger.info "    current installment: #{release.installment}"
          logger.info "    total amount: #{release.total_amount.to_f}"
          logger.info "    release amount: #{release.release_amount.to_f}"
          logger.info "    status: #{release.status}"
          logger.info "    release date: #{release.release_date}"
        end

        logger.info "    => Items"
        logger.info "      items count: #{transaction.items.size}"
        transaction.items.each do |item|
          logger.info "      item id: #{item.id}"
          logger.info "      description: #{item.description}"
          logger.info "      quantity: #{item.quantity}"
          logger.info "      amount: #{item.amount.to_f}"
          logger.info "      weight: #{item.weight}g"
        end

        logger.info "    => Sender"
        logger.info "      name: #{transaction.sender.name}"
        logger.info "      email: #{transaction.sender.email}"
        logger.info "      phone: (#{transaction.sender.phone.area_code}) #{transaction.sender.phone.number}"
        logger.info "      document: #{transaction.sender.document.type}: #{transaction.sender.document.value}"

        logger.info "    => Shipping"
        logger.info "      street: #{transaction.shipping.address.street}, #{transaction.shipping.address.number}"
        logger.info "      complement: #{transaction.shipping.address.complement}"
        logger.info "      postal code: #{transaction.shipping.address.postal_code}"
        logger.info "      district: #{transaction.shipping.address.district}"
        logger.info "      city: #{transaction.shipping.address.city}"
        logger.info "      state: #{transaction.shipping.address.state}"
        logger.info "      country: #{transaction.shipping.address.country}"
        logger.info "      type: #{transaction.shipping.type_name}"
        logger.info "      cost: #{transaction.shipping.cost}"
  end


end