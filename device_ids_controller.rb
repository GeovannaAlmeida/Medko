class DeviceIdsController < ApplicationController
  before_action :set_device_id, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /device_ids
  # GET /device_ids.json
  def index
    @device_ids = DeviceId.all
  end

  # GET /device_ids/1
  # GET /device_ids/1.json
  def show
  end

  # GET /device_ids/new
  def new
    @device_id = DeviceId.new
  end

  # GET /device_ids/1/edit
  def edit
  end

  # POST /device_ids
  # POST /device_ids.json
  def create
    @device_id = DeviceId.new(device_id_params)

    respond_to do |format|
      if @device_id.save
        format.html { redirect_to @device_id, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device_id }
      else
        format.html { render :new }
        format.json { render json: @device_id.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /device_ids/1
  # PATCH/PUT /device_ids/1.json
  def update
    respond_to do |format|
      if @device_id.update(device_id_params)
        format.html { redirect_to @device_id, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device_id }
      else
        format.html { render :edit }
        format.json { render json: @device_id.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /device_ids/1
  # DELETE /device_ids/1.json
  def destroy
    @device_id.destroy
    respond_to do |format|
      format.html { redirect_to device_ids_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device_id
      @device_id = DeviceId.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_id_params
      params.require(:device_id).permit(:token, :os, :user_id)
    end
end
