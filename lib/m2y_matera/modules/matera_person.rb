module M2yMatera
  class MateraPerson < MateraModule

    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def getPeople(matera_body, version = 'v1')
      matera_hash = [
        matera_body[:phoneNumberCountry],
        matera_body[:phoneNumber]
      ].join('')

      response = @request.get( @url + version + ACCOUNT + 
                               MateraHelper.conductorBodyToString(matera_body),
                               matera_hash)

      response = MateraModel.new(response)
      response.statusCode = response.nil? || response['data'].nil? ? '400' : '200'
      response
    end
  end
end