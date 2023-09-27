class PaymentGateway
  PAYMENT_WAIT_TIME = 1
  def self.make_payment
    Rails.logger.info "Processing payment..."
    sleep PAYMENT_WAIT_TIME
    Rails.logger.info "Done Processing payment..."
    OpenStruct.new(succeeded?: true)
  end
end