class DoctorsController < ApplicationController
  # GET /doctors or /doctors.json
  def index
    @doctors = Doctor.all
  end
end
