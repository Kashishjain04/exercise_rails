class PaymentGateway
  def self.make_payment
    Rails.logger.info "Done Processing payment..."
    OpenStruct.new(succeeded?: true)
  end
end