module M2yMatera

	class MateraBankSlip < MateraModule

        def initialize(access_key, secret_key, env)
            startModule(access_key, secret_key, env)
	     end

		def getPDF(id)
            response = @request.get(@url + DEPOSIT_PATH + "/#{id}", ["get:/v1/accounts/deposits/",id].join("") )
            invoice = MateraModel.new(response)
            invoice
      		req = HTTParty.get(invoice.data["boleto"]["url"])
      		req.parsed_response
		end


	end
end
