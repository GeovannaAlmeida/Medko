class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers
  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name,:blocked_message, :rating, :value_home_care, :active,:address,:zip_code,
    	:full_name,:crm,:email,:telephone,:password,:bank,:avatar,{:exam_type_ids => []},{:speciality_ids => []},
    	:proof_of_address_image,:crm_image,:password_confirmation,:account_type_id, bank_account_attributes: [:id,:bank, :full_name, :cpf_cnpj, :account, :operation,:agency]
      )}

    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name,:blocked_message, :rating, :value_home_care, :active,:address,:zip_code,
      :full_name,:crm,:email,:telephone,:password,:bank,:avatar,{:exam_type_ids => []},{:speciality_ids => []},
      :proof_of_address_image,:crm_image,:password_confirmation,:account_type_id, bank_account_attributes: [:id,:bank, :full_name, :cpf_cnpj, :account, :operation,:agency]
      )}   
  end


   def cors_set_access_control_headers
   if request.method == 'POST'
    headers['Access-Control-Allow-Origin'] = 'https://sandbox.pagseguro.uol.com.br'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
    end
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = 'https://sandbox.pagseguro.uol.com.br'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end

end
