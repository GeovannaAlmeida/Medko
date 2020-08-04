class AttendenceTypesController < ApplicationController
  before_action :set_attendence_type, only: [:show, :edit, :update, :destroy]

  # GET /attendence_types
  # GET /attendence_types.json
  def index
    @attendence_types = AttendenceType.all
  end

  # GET /attendence_types/1
  # GET /attendence_types/1.json
  def show
  end

  # GET /attendence_types/new
  def new
    @attendence_type = AttendenceType.new
  end

  # GET /attendence_types/1/edit
  def edit
  end

  # POST /attendence_types
  # POST /attendence_types.json
  def create
    @attendence_type = AttendenceType.new(attendence_type_params)

    respond_to do |format|
      if @attendence_type.save
        format.html { redirect_to @attendence_type, notice: 'Attendence type was successfully created.' }
        format.json { render :show, status: :created, location: @attendence_type }
      else
        format.html { render :new }
        format.json { render json: @attendence_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendence_types/1
  # PATCH/PUT /attendence_types/1.json
  def update
    respond_to do |format|
      if @attendence_type.update(attendence_type_params)
        format.html { redirect_to @attendence_type, notice: 'Attendence type was successfully updated.' }
        format.json { render :show, status: :ok, location: @attendence_type }
      else
        format.html { render :edit }
        format.json { render json: @attendence_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendence_types/1
  # DELETE /attendence_types/1.json
  def destroy
    @attendence_type.destroy
    respond_to do |format|
      format.html { redirect_to attendence_types_url, notice: 'Attendence type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendence_type
      @attendence_type = AttendenceType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendence_type_params
      params.require(:attendence_type).permit(:name)
    end
end
