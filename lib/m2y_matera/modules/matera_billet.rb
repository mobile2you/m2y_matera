module M2yMatera

  class MateraBillet < MateraModule

    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def generateTicket(body)
      #fix cdt_params
      matera_body = {}
      matera_body[:externalIdentifier] = Digest::MD5.hexdigest(body[:idConta] + Time.now.to_i.to_s)
      matera_body[:paymentInfo] = {
        transactionType: "Boleto",
        boleto: {
          bank: "341",
          accountingMethod: "DEF",
          dueDate: body[:dataVencimento]
        }
      }
      if !body[:street].nil?
        matera_body[:paymentInfo][:billingAddress] = {
          logradouro: body[:street],
          numero: body[:number],
          cidade: body[:city],
          estado: body[:state],
          cep: body[:zip].gsub("-", ""),
          pais: "BRA",

        }
      end

      matera_body[:recipients] = [{
                                    account: {
                                      accountId: body[:idConta]
                                    },
                                    amount: body[:valor],
                                    currency: "BRL"
      }]

      puts matera_body

      int_amount = (body[:valor].divmod 1)[0].to_s


      response = @request.post(@url + DEPOSIT_PATH, matera_body,[body[:idConta], int_amount].join("") )

      billet = MateraModel.new(response)
      # recipient.accountId, and recipient.amount
      if billet && billet.data
        billet.id = billet.data["transactionId"]
        billet.banco = "341"
        billet.numeroDoDocumento = billet.id
        billet.linhaDigitavel = billet.data["typeableLine"]
        billet.url = billet.data["boletoUrl"]
        billet.statusCode = 200
      end
      billet
    end

    def findTransaction(id)
      transaction_hash = "get:/v1/accounts/deposits/#{id}"
      response = @request.get(@url + DEPOSIT_PATH + "/#{id.to_s}", transaction_hash)
      puts response["data"]
      transactions = MateraModel.new(response["data"])
      transactions
    end

  end
end
