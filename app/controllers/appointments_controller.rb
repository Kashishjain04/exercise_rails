class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show edit update destroy ]
  before_action :set_currency_rates, only: %i[ new create ]

  # GET /appointments or /appointments.json
  def index
    @appointments = Appointment.all
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new(doctor_id: params[:doctor_id])
    @slots = @appointment.doctor.available_slots
    session_user = get_session_user
    @appointment.user = session_user
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    new_user = User.find_or_create_by(email: appointment_params[:user][:email])
    new_user.update(appointment_params[:user])
    session[:user_id] = new_user.id

    @appointment = Appointment.create!(user: new_user,
                                       doctor: Doctor.find(appointment_params[:doctor_id]),
                                       date_time: appointment_params[:date_time],
                                       currency: appointment_params[:user][:preferred_currency],
                                       amount: view_context.convert_currency(
                                         Appointment::APPOINTMENT_PRICE_INR,
                                         @rates,
                                         appointment_params[:user][:preferred_currency]
                                       ))

    respond_to do |format|
      if @appointment.save
        format.turbo_stream { PaymentJob.perform_now(@appointment) }
      else
        format.html { render :new, params: { doctor_id: appointment_params[:doctor_id] },
                             status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to appointment_url(@appointment), notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to appointments_url, notice: "Appointment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def set_currency_rates
    @rates = FixerApi.today_rates
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(
      :date_time,
      :doctor_id,
      user: [:name, :email, :preferred_currency]
    )
  end
end
