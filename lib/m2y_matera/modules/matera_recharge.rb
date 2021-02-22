module M2yMatera
  class MateraRecharge < MateraModule
    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def send(matera_body, id)
      response = @request.post(@url + "v1/accounts/#{id}#{PUSH}", matera_body, id)
      MateraModel.new(response)
    end
  end
end
