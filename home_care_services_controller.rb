class HomeCareServicesController < ApplicationController
  before_action :set_home_care_service, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /home_care_services
  # GET /home_care_services.json
  def index
    @home_care_services = HomeCareService.all
  end

  # GET /home_care_services/1
  # GET /home_care_services/1.json
  def show
  end

  # GET /home_care_services/new
  def new
    @home_care_service = HomeCareService.new
  end

  # GET /home_care_services/1/edit
  def edit
  end

  # POST /home_care_services
  # POST /home_care_services.json
  def create
    @home_care_service = HomeCareService.new(home_care_service_params)

    respond_to do |format|
      if @home_care_service.save
        format.html { redirect_to @home_care_service, notice: 'Home care service was successfully created.' }
        format.json { render :show, status: :created, location: @home_care_service }
      else
        format.html { render :new }
        format.json { render json: @home_care_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /home_care_services/1
  # PATCH/PUT /home_care_services/1.json
  def update
    respond_to do |format|
      if @home_care_service.update(home_care_service_params)
        format.html { redirect_to @home_care_service, notice: 'Home care service was successfully updated.' }
        format.json { render :show, status: :ok, location: @home_care_service }
      else
        format.html { render :edit }
        format.json { render json: @home_care_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /home_care_services/1
  # DELETE /home_care_services/1.json
  def destroy
    @home_care_service.destroy
    respond_to do |format|
      format.html { redirect_to home_care_services_url, notice: 'Home care service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_home_care_service
      @home_care_service = HomeCareService.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def home_care_service_params
      params.require(:home_care_service).permit(:valor, :exam_type_id, :speciality_id, :user_id)
    end
end
