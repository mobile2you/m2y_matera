module M2yMatera
  class MateraPayment < MateraModule

    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def paymentValidate(matera_params)
      response = @request.get(@url + BILLS_PATH +
                              MateraHelper.conductorBodyToString(matera_params),
                              matera_params[:document])

      return response  if response['data'].nil?
      MateraModel.new(response['data'])
    end

    def payment(matera_body)
      matera_header_hash = [
        matera_body[:sender][:account][:branch],
        matera_body[:sender][:account][:accountId],
        matera_body[:sender][:client][:taxId],
        matera_body[:paymentInfo][:transactionType],
        matera_body[:totalAmount].to_i,
        matera_body[:sender][:account][:mobilePhone][:phoneNumber],
        matera_body[:totalAmount].to_i,
      ].join('')

      response = @request.post( @url + PAYMENT_PATH,
                                matera_body, matera_header_hash)

      return response if response['data'].nil?
      MateraModel.new(response['data'])
    end
  end
end
