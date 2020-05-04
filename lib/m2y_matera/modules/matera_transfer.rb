module M2yMatera

	class MateraTransfer < MateraModule

        def initialize(access_key, secret_key, env)
            startModule(access_key, secret_key, env)
	     end


		def bankTransfers(body)
			
            #fix cdt_params
            matera_body = {}
            matera_body[:externalIdentifier] = rand(1..9999)
            matera_body[:currency] = "BRL"
            matera_body[:totalAmount] = body[:value]
            matera_body[:withdrawInfo] = {
                withdrawType: "BankTransfer",
                bankTransfer: {
                    bankDestination: body[:beneficiary][:bankId],
                    branchDestination: body[:beneficiary][:agency],
                    accountDestination: [body[:beneficiary][:account], body[:beneficiary][:accountDigit]].join(""),
                	taxIdentifier: {
                    	country: "BRA",
                    	taxId: body[:beneficiary][:docIdCpfCnpjEinSSN]
                	},
		            personType: "PERSON",
        		    name: body[:beneficiary][:name],
            	    accountTypeDestination: "1"
	            }
            }
            puts matera_body

			id = body[:idOriginAccount]
			int_amount = (body[:value].divmod 1)[0].to_s
			matera_hash = [int_amount, id, body[:beneficiary][:bankId], body[:beneficiary][:agency], body[:beneficiary][:account], body[:beneficiary][:accountDigit]].join("")


			response = @request.post(@url + ACCOUNT_PATH + id.to_s + WITHDRAW, matera_body, matera_hash)
			transferResponse = MateraModel.new(response)
			
            if transferResponse && transferResponse.data
                transferResponse.id = transferResponse.data["transactionId"]
                transferResponse.statusCode = 200
                transferResponse.transactionCode = transferResponse.data["transactionId"]
                # transferResponse.content = transferResponse
            end
            transferResponse
		end


	end
end
