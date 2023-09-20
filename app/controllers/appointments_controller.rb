class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show edit update destroy ]
  before_action :set_currency_rates, only: %i[ new create ]

  # GET /appointments or /appointments.json
  def index
    @appointments = Appointment.all
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
    unless new_user.valid?
      flash[:error] = "Invalid User Details"
      redirect_to new_appointment_path, params: { doctor_id: appointment_params[:doctor_id] },
                  status: :unprocessable_entity
      return
    end
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
        flash[:error] = "Invalid Name"
        flash.keep
        format.html { redirect_to new_appointment_path, params: { doctor_id: 2 },
                                  notice: "Invalid Name", status: :unprocessable_entity }
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
    respond_to do |format|
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
    begin
      @appointment = Appointment.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      @appointment = nil
      # render :text => 'Not Found', :status => '404'
    end
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
