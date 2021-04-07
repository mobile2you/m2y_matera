module M2yMatera

	class MateraService < MateraModule

        def initialize(access_key, secret_key, env)
            startModule(access_key, secret_key, env)
	    end


        def p2pTransfer(body)
            #fix cdt_params
            matera_body = {}
            matera_body[:externalIdentifier] = Digest::MD5.hexdigest(body[:originalAccount] + Time.now.to_i.to_s)
            matera_body[:totalAmount] = body[:amount]
            matera_body[:currency] = "BRL"
            matera_body[:paymentInfo] = {
                transactionType: "InternalTransfer",
            }
            matera_body[:sender] = {
                    account: {
                    	accountId: body[:originalAccount]
                    }
             }

            matera_body[:recipients] = [{
                    account: {
                    	accountId: body[:destinationAccount]
                    },
                    amount: body[:amount],
                    currency: "BRL"
             }]

            puts matera_body

			int_amount = (body[:amount].divmod 1)[0].to_s


            response = @request.post(@url + PAYMENT_PATH, matera_body,[body[:originalAccount], int_amount,body[:destinationAccount], int_amount].join("") )
            p2p = MateraModel.new(response)
            # recipient.accountId, and recipient.amount
            if p2p && p2p.data
                p2p.id = p2p.data["transactionId"]
                p2p.idAdjustment = p2p.data["transactionId"]
                p2p.idAdjustmentDestination = p2p.data["transactionId"]
                p2p.transactionCode = p2p.data["transactionId"]
                # p2p.content = p2p
                p2p.statusCode = 200
            end
            p2p
        end


	end
end
