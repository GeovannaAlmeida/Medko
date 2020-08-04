class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
      format.html { 
        @users = User.order(name: :asc)
      }
      format.js {
        @users = User.search_user(params['search'])
        return @users
      }
    end
  end
   

  # GET /users/1
  # GET /users/1.json
  def show
        user = User.find(params['id'])
     if user.account_type_id == 3
       @attendences = Attendence.where(doctor_id: params['id'])
     else
      @attendences = Attendence.where(patient_id: params['id']) 
     end 
      @payments = Payment.where(user_id: params['id'])
  end

  # GET /users/new
  def new
    @user = User.new
    @bank_account = @user.bank_account.build
  end

  # GET /users/1/edit
  def edit
    user = User.find(params['id'])
     if user.account_type_id == 3
       @attendences = Attendence.where(doctor_id: params['id'])
     else
      @attendences = Attendence.where(patient_id: params['id']) 
     end 
      @payments = Payment.where(user_id: params['id'])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

   def update_resource(resource, params)
      resource.update_without_password(params)
    end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'Usuario modificado com sucesso' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      @user.active = true
    end

    # Never trust parameters from the scary internet, only allow the white list through.
   def user_params
    params.require(:user).permit(:name,:address,:zip_code,:rating, :value_home_care, :active, :avatar,:email, :password,:telephone,:crm,:crm_image, :proof_of_address_image,{:exam_type_ids => []},{:speciality_ids => []},:bank, :full_name,:blocked, :blocked_message, :account_type_id,bank_account_attributes:[:bank, :full_name, :cpf_cnpj,:account,:operation,:user,:agency])
    end
end