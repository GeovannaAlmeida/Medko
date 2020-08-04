class ExamTypesController < ApplicationController
  before_action :set_exam_type, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /exam_types
  # GET /exam_types.json
  def index
    @exam_types = ExamType.all.order("name")
  end

  # GET /exam_types/1
  # GET /exam_types/1.json
  def show
  end

  # GET /exam_types/new
  def new
    @exam_type = ExamType.new
  end

  # GET /exam_types/1/edit
  def edit
  end

  # POST /exam_types
  # POST /exam_types.json
  def create
    @exam_type = ExamType.new(exam_type_params)

    respond_to do |format|
      if @exam_type.save
        format.html { redirect_to exam_types_path}
        format.json { render :show, status: :created, location: @exam_type }
      else
        format.html { render :new }
        format.json { render json: @exam_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exam_types/1
  # PATCH/PUT /exam_types/1.json
  def update
    respond_to do |format|
      if @exam_type.update(exam_type_params)
        format.html { redirect_to exam_type_url}
        format.json { render :show, status: :ok, location: @exam_type }
      else
        format.html { render :edit }
        format.json { render json: @exam_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exam_types/1
  # DELETE /exam_types/1.json
  def destroy
    @exam_type.destroy
    respond_to do |format|
      format.html { redirect_to exam_types_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam_type
      @exam_type = ExamType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_type_params
      params.require(:exam_type).permit(:name,:image_url,:home_care)
    end
end
