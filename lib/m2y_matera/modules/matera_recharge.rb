module M2yMatera
  class MateraRecharge < MateraModule

    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def confirmDealers(country_code, area_code)
      response = @request.get( @url + COUNTRY_PATH + country_code +
                               AREA_CODE_PATH + area_code + CARRIERS_PATH, '')

      carriers = MateraModel.new(response)
      carriers.statusCode = response['data'].nil? ? 400 : 200
      carriers
    end

    def newRechargeOrder(country_code, area_code, carrier_id)
      response = @request.get( @url + COUNTRY_PATH + country_code +
                               AREA_CODE_PATH + area_code + CARRIERS_PATH.singularize +
                               '/'+ carrier_id + VALUE_PATH, '')

      carriers = MateraModel.new(response)
      carriers.statusCode = response['data'].nil? ? 400 : 200
      carriers
    end
  end
end
