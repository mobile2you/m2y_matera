module M2yMatera

	class MateraCep < MateraModule

		def initialize(token, env)
			startModule(token, env)
		end

		def ceps(body)
			response = @request.get("https://viacep.com.br/ws/#{body[:CEP]}/json")
			person = MateraModel.new(response)
			person
		end

	end
end