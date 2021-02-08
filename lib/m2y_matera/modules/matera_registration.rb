module M2yMatera
  class MateraRegistration < MateraModule
    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def createRegistration(body, _version = 1)
      # fix cdt_params
      matera_body = {}
      matera_body[:externalIdentifier] = rand(1..9999)
      matera_body[:sharedAccount] = false
      matera_body[:client] = {
        name: body[:name],
        email: body[:email],
        documents: body[:documents],
        socialName: body[:legalName] || body[:name],
        taxIdentifier: {
          country: 'BRA',
          taxId: body[:document]
        },
        mobilePhone: {
          country: 'BRA',
          phoneNumber: body[:phone][:areaCode] + body[:phone][:number]
        }
      }
      puts matera_body

      response = @request.post(@url + ACCOUNT_PATH, matera_body, [matera_body[:externalIdentifier], matera_body[:client][:taxIdentifier][:taxId]].join(''))
      account = MateraModel.new(response)

      if account&.data
        account.data['registration_id'] = account.data['account']['accountId']
        account.data['id'] = matera_body[:externalIdentifier]
        account.data['account_id'] = matera_body[:externalIdentifier]
        account.data['person_id'] = account.data['accountHolderId']
      end
      account
    end
  end
end
