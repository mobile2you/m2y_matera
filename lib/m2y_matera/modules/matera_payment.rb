module M2yMatera
  class MateraPayment < MateraModule

    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def paymentValidate(matera_params)
      response = @request.get(@url + BILLS_PATH +
                              MateraHelper.conductorBodyToString(matera_params),
                              matera_params[:document])

      return response if response['data'].nil?
      MateraModel.new(response['data'])
    end
  end
end
