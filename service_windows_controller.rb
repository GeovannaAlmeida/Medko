class ServiceWindowsController < ApplicationController
  before_action :set_service_window, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /service_windows
  # GET /service_windows.json
  def index
    @service_windows = ServiceWindow.where(user_id: current_user).order("start_time ASC")
    @service_window = ServiceWindow.new
  end

  # GET /service_windows/1
  # GET /service_windows/1.json
  def show
  end

  # GET /service_windows/new
  def new
    @service_window = ServiceWindow.new
  end

  def calendar_view
    @service_windows = ServiceWindow.where(user_id: current_user)
  end

  # GET /service_windows/1/edit
  def edit
  end

  # POST /service_windows
  # POST /service_windows.json
  def create
    @service_window = ServiceWindow.new(service_window_params)
    @service_window.user = current_user
    respond_to do |format|
      if @service_window.save
        format.html { redirect_to service_windows_url }
        format.json { render :index, status: :created, location: @service_window }   
      else
        format.html { render :index}
        @service_windows = ServiceWindow.where(user_id: current_user)
        format.json { render json: @service_window.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_windows/1
  # PATCH/PUT /service_windows/1.json
  def update
    respond_to do |format|
      if @service_window.update(service_window_params)
        format.html { redirect_to service_windows_url}
        format.json { render :index, status: :ok, location: @service_window }
      else
        format.html { render :edit }
        format.json { render json: @service_window.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_windows/1
  # DELETE /service_windows/1.json
  def destroy
    @service_window.destroy
    respond_to do |format|
      format.html { redirect_to service_windows_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_window
      @service_window = ServiceWindow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_window_params
      params.require(:service_window).permit(:user_id, :attendence_id, :week_day, :start_time, :end_time,:exam_type_id,:speciality_id, :service_time, :place_id,:value, {:exam_type_attributes => [:id,:name]},{:speciality_attributes => [:id,:name]},{:payment_method_ids => []},{:health_plan_ids => []},place_attributes: [:id,:name])
    end
end













