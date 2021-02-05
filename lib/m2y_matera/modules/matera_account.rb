module M2yMatera

	class MateraAccount < MateraModule

		def initialize(access_key, secret_key, env)
			startModule(access_key, secret_key, env)
		end

		def getAccounts(id)
			response = @request.get(@url + ACCOUNT_PATH + id.to_s, id.to_s)
			account = MateraModel.new(response["data"])
			
			#fixing cdt_fields
			if !account.nil? && !account.account.nil?
        if account.financialLimit.present?
				  account.saldoDisponivelGlobal = account.financialLimit['realBalance'].to_f #/100.0,
        end
				account.idPessoa = account.accountHolderId
				account.idStatusConta = 0
				account.id = account.account["accountId"]
			end
			account
		end


		def getTransactions(id)
			response = @request.get(@url + ACCOUNT_PATH + id.to_s + STATEMENT, id.to_s)
			transactions = MateraModel.new(response["data"]).statement.reject!{ |n| n["type"] == "S" } 

			# fixing cdt_fields
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

    def bureau_validation(params)
			matera_body = {
				metadata: {
				  validationTimestamp: params[:timestamp],
				  sourceSystem: params[:source_system],
				  transactionId: params[:transaction_id],
				  validationProtocol: params[:validation_protocol],
				  validationSystem: 'IDWALL'
				},
				results: {
					status: 'APPROVED',
					remarks: [
						'Additional information'
					]
				}
			}
			
			response = @request.post(@url + ACCOUNT_PATH + VALIDATION_BUREAU, matera_body, [body[:idConta], int_amount].join(""))
			MateraModel.new(response['data'])
		end

	end
end
