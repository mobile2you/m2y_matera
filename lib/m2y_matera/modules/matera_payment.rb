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

    def payment(matera_body, account_id, matera_header_hash)
      response = @request.post( @url + ACCOUNT_PATH + account_id + 
                                WITHDRAW, matera_body, matera_header_hash)

      return response if response.nil? || response['data'].nil?
      MateraModel.new(response['data'])
    end
  end
end