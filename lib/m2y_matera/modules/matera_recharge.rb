module M2yMatera
  class MateraRecharge < MateraModule
    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def confirmDealers(area_code)
      response = @request.get(@url + RECHARGE_PATH + area_code + '/carriers', nil)
      model = MateraModel.new(response)
      model.dealers = model.data.map { |a| { name: a['carrierName'], code: a['carrierId'] } }
      model
    end

    def getRechargesValues(area_code, carrier_id)
      response = @request.get(@url + RECHARGE_PATH + area_code + '/carrier/' + carrier_id + '/values', nil)
      model = MateraModel.new(response)
      model.values = model.data
      model
    end
  end
end
