module M2yMatera
  class MateraPayment < MateraModule

    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def paymentValidate(matera_params)
      response = @request.get(@url + BILLS_PATH +
                              MateraHelper.conductorBodyToString(matera_params),
                              matera_params[:document])

      MateraModel.new(response['data'] || response['error'])
    end

    def payment(account_id, matera_params)
      matera_body = {
        totalAmount: matera_params[:amount].to_f,
        mediatorFee: 0,
        currency: 'BRL',
        externalIdentifier: Digest::MD5.hexdigest(account_id + Time.now.to_i.to_s),
        withdrawInfo: {
          withdrawType: 'Boleto',
          boleto: {
            interestAmount: matera_params[:interest],
            fineAmount: matera_params[:fine],
            documentNumber: matera_params[:document],
            typeableLine: matera_params[:linhaDigitavel],
            beneficiaryTaxIdentifier: matera_params[:taxIdentifier],
            dueDate: matera_params[:dueDate],
            discount: matera_params[:discount]
          },
          senderComment: matera_params[:description]
        }
      }

      p matera_body

      response = @request.post(@url + ACCOUNT_PATH + account_id + WITHDRAW, matera_body, [matera_body[:totalAmount].to_i, account_id, matera_params[:linhaDigitavel]].join(''))
      MateraModel.new(response['data'] || response['error'])
    end


    def getTransactions(id)
      response = @request.get(@url + ACCOUNT_PATH + id.to_s + STATEMENT, id.to_s)
      transactions = MateraModel.new(response["data"]).statement.reject { |n| n["type"] == "S" }

      if !transactions.nil?
        transactions.each do |transaction|
          transaction["dataOrigem"] = transaction["entryDate"].nil? ? transaction["creditDate"] : transaction["entryDate"]
          transaction["descricaoAbreviada"] = transaction["description"]
          transaction["idEventoAjuste"] = transaction["transactionId"]
          transaction["codigoMCC"] = transaction["transactionId"]
          transaction["nomeFantasiaEstabelecimento"] = transaction["description"]
          transaction["valorBRL"] = transaction["amount"].to_f #/100.0
          transaction["flagCredito"] = transaction["type"] == "C" ? 1 : 0
        end
      end
      transactions
    end


  end
end
