module M2yMatera

	class MateraInvoice < MateraModule

        def initialize(access_key, secret_key, env)
            startModule(access_key, secret_key, env)
	     end
	
        def findInvoice(id)
            response = @request.get(@url + DEPOSIT_PATH + "/#{id}", ["get:/v1/accounts/deposits/",id].join("") )
            invoice = MateraModel.new(response)
             if invoice && invoice.data
                invoice.status = invoice.data["status"] == "PAID" ? 4 : 3
                invoice.dataVencimento = invoice.data["boleto"]["dueDate"]
                invoice[:content] = invoice
            end
            invoice
        end

 	end

end