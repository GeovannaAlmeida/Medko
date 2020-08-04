class AttendenceStatusesController < ApplicationController
  before_action :set_attendence_status, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /attendence_statuses
  # GET /attendence_statuses.json
  def index
    @attendence_statuses = AttendenceStatus.all
  end

  # GET /attendence_statuses/1
  # GET /attendence_statuses/1.json
  def show
  end

  # GET /attendence_statuses/new
  def new
    @attendence_status = AttendenceStatus.new
  end

  # GET /attendence_statuses/1/edit
  def edit
  end

  # POST /attendence_statuses
  # POST /attendence_statuses.json
  def create
    @attendence_status = AttendenceStatus.new(attendence_status_params)

    respond_to do |format|
      if @attendence_status.save
        format.html { redirect_to @attendence_status, notice: 'Attendence status was successfully created.' }
        format.json { render :show, status: :created, location: @attendence_status }
      else
        format.html { render :new }
        format.json { render json: @attendence_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendence_statuses/1
  # PATCH/PUT /attendence_statuses/1.json
  def update
    respond_to do |format|
      if @attendence_status.update(attendence_status_params)
        format.html { redirect_to @attendence_status, notice: 'Attendence status was successfully updated.' }
        format.json { render :show, status: :ok, location: @attendence_status }
      else
        format.html { render :edit }
        format.json { render json: @attendence_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendence_statuses/1
  # DELETE /attendence_statuses/1.json
  def destroy
    @attendence_status.destroy
    respond_to do |format|
      format.html { redirect_to attendence_statuses_url, notice: 'Attendence status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendence_status
      @attendence_status = AttendenceStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendence_status_params
      params.require(:attendence_status).permit(:name)
    end
end
