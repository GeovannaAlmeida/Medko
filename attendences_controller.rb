
  class AttendencesController < ApplicationController
    before_action :set_attendence, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    skip_before_filter  :verify_authenticity_token
    respond_to :json, :html

    # GET /attendences
    # GET /attendences.json
     def index
    respond_to do |format|
      format.html { 
         if current_user.account_type_id == 1
          @attendences = Attendence.where(patient_id: current_user).order("created_at DESC")
        elsif current_user.account_type_id == 3
          @attendences = Attendence.where(doctor_id: current_user).order("created_at DESC")
         else
          @attendences = Attendence.all
        end
      }
      format.js {
        if !params['inicio'].blank? && !params['fim'].blank?
          inicio = DateTime.parse(params['inicio'])+ 3.hours
          fim = DateTime.parse(params['fim'])+ 3.hours
          @attendences = Attendence.search_between(params['search'], inicio, fim)
          return @attendences
        elsif current_user.account_type_id == 3
          @attendences = Attendence.search(params['search']).where(doctor_id: current_user)
          return @attendences
        elsif current_user.account_type_id == 1
          @attendences = Attendence.search(params['search']).where(patient_id: current_user)
          return @attendences
        end
      }

       format.json { 
        if current_user.account_type_id == 1
          @attendences = Attendence.where(patient_id: current_user)
        end
          if current_user.account_type_id == 3
            @attendences = Attendence.where(doctor_id: current_user)
          else
            @attendences = Attendence.all
      end }
    end
  end

    # GET /attendences/1
    # GET /attendences/1.json
    def show
    
    end

    def create_attendences
        @attendence = Attendence.new
        @attendence.place_id = params['place']
        @attendence.service_window_id = params['id']
        @attendence.doctor_id = params['doctor']
        @attendence.health_plan_id = params['health_plan']
        @attendence.exam_type_id = params['exam']
        @attendence.speciality_id = params['speciality']
        @attendence.attendence_type_id = 2
        @attendence.value = params['value']
        @attendence.attendence_status_id = 7
        @attendence.patient_id = current_user.id
        @attendence.save
        respond_to do |format|
        format.js{
             render :js =>"document.location = '#{attendence_path(@attendence.id)}'"
            }        

      end
    end
   def search
       @speciality = Speciality.all
       @exam_type = ExamType.all
       @payment_method = PaymentMethod.all
       @health_plan = HealthPlan.all
       @attendence_type = AttendenceType.all
     end

  def search_attendences
      @speciality_id = params['speciality']
      @exam_type_id = params['exam']
      @payment_id = params['payment']
      @health_plan_id = params['health_plan']
      @attendence_type_id = params['attendence_type']
      @address = params['address']
      @latitude = params['latitude']
      @longitude = params['longitude'] 
      @patient_id = current_user.id
     
      if @attendence_type_id == '1' &&
        @attendence = Attendence.search_home_care(@address,@latitude,@longitude,@exam_type_id,@speciality_id,@patient_id)
          respond_to do |format|
            if @attendence.blank?
               flash[:notice] = 'Infelizmente nenhum médico foi encontrado.'
              format.js{ render :js =>"document.location = '#{attendence_search_path}'" } 
            else
              format.js{ render :js =>"document.location = '#{attendence_path(@attendence.id)}'" } 
            end
          end
      else
        @service_windows  = Attendence.search_clinic(@exam_type_id,@payment_id,@speciality_id,@health_plan_id,@latitude,@longitude,@patient_id)
        respond_to do |format|
          format.js
        end
      end
   end

    # GET /attendences/new
    def new
      @attendence = Attendence.new
    end

    # GET /attendences/1/edit
    def edit
    end

     def confirm
      attendence = Attendence.find(params['attendence']['id'])
      attendence.attendence_status_id = 2
      attendence.save
      respond_to do |format|
        format.js { render nothing: true } 
      end
    end
    

     def cancel
      attendence = Attendence.find(params['attendence']['id'])
      attendence.attendence_status_id = 3
      attendence.save  
      respond_to do |format|
       format.js { render nothing: true } 
  end
    end

      def time
      attendence = Attendence.find(params['attendence']['id'])
      attendence.date = params['attendence']['date']
      attendence.attendence_status_id = 1
      attendence.save  
      respond_to do |format|
       format.js { render nothing: true } 
  end
    end


    # POST /attendences
    # POST /attendences.json
    def create
      @attendence = Attendence.new(attendence_params)
      respond_to do |format|
        if @attendence.save
          format.html { redirect_to @attendence}
          format.json { render :show, status: :created, location: @attendence }
        else
          format.html { render :new }
          format.json { render json: @attendence.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /attendences/1
    # PATCH/PUT /attendences/1.json
    def update
      respond_to do |format|

        if @attendence.update(attendence_params)
          format.html { redirect_to attendences_url}
          format.json { render :show, status: :ok, location: @attendence }
        else
          format.html { render :edit }
          format.json { render json: @attendence.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /attendences/1
    # DELETE /attendences/1.json
    def destroy
      @attendence.destroy
      respond_to do |format|
        format.html { redirect_to attendences_url}
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_attendence
        @attendence = Attendence.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def attendence_params
        params.require(:attendence).permit(
         :date,
         :value,
         :exam_type_id, 
         :speciality_id, 
         :place_id, 
         :attendence_type_id,
         :search_address_id, 
         :service_window_id, 
         :home_care_service_id, 
         :payment_method_id, 
         :health_plan_id,
         :classification_id,
         :attendence_status_id,
         {:exam_type_ids => []},
         {:speciality_ids => []},
          :patient_id, 
          :doctor_id,
          payment_attributes: [:price])
      end
  end
