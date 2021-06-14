module M2yMatera

  class MateraTransfer < MateraModule

    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end


    def bankTransfers(body)

      begin
        type = body[:beneficiary][:account_type].upcase
      rescue
      end

      if type.blank?
        type = "CC"
      end

      #fix cdt_params
      matera_body = {}
      matera_body[:externalIdentifier] = Digest::MD5.hexdigest(body[:idOriginAccount] + Time.now.to_i.to_s)
      matera_body[:currency] = "BRL"
      matera_body[:totalAmount] = body[:value]
      matera_body[:withdrawInfo] = {
        withdrawType: "BankTransfer",
        bankTransfer: {
          bankDestination: body[:beneficiary][:bankId],
          branchDestination: body[:beneficiary][:agency],
          accountDestination: [body[:beneficiary][:account], body[:beneficiary][:accountDigit]].join(body[:beneficiary][:bankId].to_s == "341" ? "-" : ""),
          taxIdentifier: {
            country: "BRA",
            taxId: body[:beneficiary][:docIdCpfCnpjEinSSN]
          },
          personType: "PERSON",
          name: body[:beneficiary][:name],
          accountTypeDestination: type
        }
      }
      puts matera_body

      id = body[:idOriginAccount]
      int_amount = (body[:value].divmod 1)[0].to_s
      matera_hash_string = int_amount
      puts matera_hash_string
      matera_hash_string += id.to_s
      puts matera_hash_string
      matera_hash_string += body[:beneficiary][:bankId].to_s
      puts matera_hash_string
      matera_hash_string += body[:beneficiary][:agency].to_s

      puts matera_hash_string
      matera_hash_string += matera_body[:withdrawInfo][:accountDestination].to_s

      puts matera_hash_string


      response = @request.post(@url + ACCOUNT_PATH + id.to_s + WITHDRAW, matera_body, matera_hash_string)
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
