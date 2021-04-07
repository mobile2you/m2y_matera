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

    def confirmRecharge(account_id, matera_params)
      matera_body = {
        mobilePhone: {
          country: 'BRA',
          phoneNumber: matera_params[:phoneNumber]
        },
        totalAmount: matera_params[:amount],
        carrierId: matera_params[:dealerCode],
        externalIdentifier: Digest::MD5.hexdigest(account_id + Time.now.to_i.to_s)
      }
      p matera_body
      response = @request.post(@url + ACCOUNT_PATH.gsub('s', '') + account_id + RECHARGE, matera_body, [account_id, matera_params[:phoneNumber], matera_params[:amount]].join(''))
      MateraModel.new(response)
    end
  end
end
