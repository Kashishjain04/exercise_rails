class PaymentGateway
  PAYMENT_WAIT_TIME = 1
  def self.make_payment
    sleep PAYMENT_WAIT_TIME
    Rails.logger.info "Done Processing payment..."
    OpenStruct.new(succeeded?: true)
  end
end