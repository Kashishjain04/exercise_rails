class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show destroy ]
  before_action :set_currency_rates, only: %i[ new create ]
  before_action :authenticate, only: %i[ index show destroy ]

  # GET /appointments or /appointments.json
  def index
    @user = get_session_user
    @appointments = @user.appointments
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    respond_to do |format|
      if @appointment.nil?
        render_404
        return
      end
      format.html
      format.text do
        response.headers['Content-Type'] = 'text/plain'
        response.headers['Content-Disposition'] = "attachment; filename=receipt-#{@appointment.id}.txt"
      end
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=receipt-#{@appointment.id}.csv"
      end
      format.pdf do
        render pdf: "receipt-#{@appointment.id}",
               page_size: 'A4',
               layout: "application",
               orientation: "Portrait",
               zoom: 1,
               dpi: 75,
               locals: { appointment: @appointment }
      end
    end
  end

  # GET /appointments/new
  def new
    @rates = FixerApi.today_rates
    @appointment = Appointment.new(doctor_id: params[:doctor_id])
    @slots = @appointment.doctor.available_slots
    session_user = get_session_user
    session_user ? @appointment.user = session_user : @appointment.build_user
  end

  # POST /appointments or /appointments.json
  def create
    new_user = User.login_or_signup(appointment_params[:user])

    @appointment = Appointment.new(
      user: new_user,
      doctor: Doctor.find(appointment_params[:doctor_id]),
      date_time: appointment_params[:date_time],
      amount_inr: Appointment::APPOINTMENT_PRICE_INR,
      currency_rates: @rates
    )

    if new_user.errors.any?
      @appointment.errors.merge!(new_user.errors)
      @appointment.build_user
    else
      session[:user_id] = new_user.id
    end

    respond_to do |format|
      if @appointment.errors.none? && @appointment.save
        format.turbo_stream { PaymentJob.perform_now(@appointment) }
      else
        @slots = @appointment.doctor.available_slots
        format.html { render :new,
                             params: { doctor_id: appointment_params[:doctor_id] },
                             status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    respond_to do |format|
      if @appointment.nil?
        render_404
        return
      end
      if (@appointment.date_time - DateTime.now) <= Appointment::CANCEL_DEADLINE
        format.html { redirect_to appointments_url, notice: t('.cancellation_windows_closed') }
      else
        @appointment.destroy!
        format.html { redirect_to appointments_url, notice: t('.appointment_cancelled') }
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @user = get_session_user
    return if @user.nil?
    begin
      @appointment = Appointment.find_by(id: params[:id], user_id: @user.id)
    rescue ActiveRecord::RecordNotFound => e
      @appointment = nil
      # render :text => 'Not Found', :status => '404'
    end
  end

  def set_currency_rates
    @rates = FixerApi.today_rates
    if @rates.nil?
      flash[:error] = "Something went wrong"
      redirect_to doctors_index_path
    end
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
