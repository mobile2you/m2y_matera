# frozen_string_literal: true

module M2yMatera
  class MateraRegistration < MateraModule
    def initialize(access_key, secret_key, env)
      startModule(access_key, secret_key, env)
    end

    def createRegistrationPj(body, _version = 1)
      # fix cdt_params
      # matera_body = {}
      # matera_body[:externalIdentifier] = rand(1..9999) # required
      # matera_body[:sharedAccount] = false
      # matera_body[:clientType] = 'Corporate'
      # # matera_body[:occupation] = 1
      # # matera_body[:maritalStatus] = 'SEPARATED'
      # # matera_body[:businessLine] = 1
      # # matera_body[:gender] = 'M'
      # # matera_body[:rg] = {
      #   # number: '222836933',
      #   # issueDate: '10-10-2012',
      #   # issuer: 'br',
      #   # state: 'SSP'
      # # }
      # matera_body[:client] = {
      #   name: body[:name], # required
      #   email: body[:email], # required
      #   # documents: body[:documents],
      #   # socialName: body[:legalName] || body[:name],
      #   taxIdentifier: { # required
      #     country: 'BRA',
      #     taxId: body[:document]
      #   },
      #   mobilePhone: { # required
      #     country: 'BRA',
      #     phoneNumber: body[:phone][:areaCode] + body[:phone][:number]
      #   },
      #   mailAddress: { # required
      #     logradouro: address[:street],
      #     numero: address[:number],
      #     cidade: address[:city],
      #     estado: address[:federativeUnit],
      #     cep: address[:zipCode],
      #     pais: address[:country],
      #     bairro: address[:neighborhood]
      #   }
      # }
      # matera_body[:billingAddress] = {
      #   logradouro: address[:street],
      #   numero: address[:number],
      #   cidade: address[:city],
      #   estado: address[:federativeUnit],
      #   cep: address[:zipCode],
      #   pais: address[:country],
      #   bairro: address[:neighborhood]
      # }
      # matera_body[:AdditionalDetailsPerson] = {
      #   mother: body[:motherName],
      #   birthDate: body[:birthDate],
      #   birthCity: address[:city],
      #   birthState: address[:federativeUnit],
      #   birthCountry: address[:country],
      #   legalResponsible: {
      #     name: body[:name],
      #     email: body[:email],
      #     documents: body[:documents],
      #     socialName: body[:legalName] || body[:name],
      #     taxIdentifier: {
      #       country: 'BRA',
      #       taxId: body[:document]
      #     },
      #     mobilePhone: {
      #       country: 'BRA',
      #       phoneNumber: body[:phone][:areaCode] + body[:phone][:number]
      #     },
      #     mailAddress: {
      #       logradouro: address[:street],
      #       numero: address[:number],
      #       cidade: address[:city],
      #       estado: address[:federativeUnit],
      #       cep: address[:zipCode],
      #       pais: address[:country],
      #       bairro: address[:neighborhood]
      #     }
      #   }
      # }

      address = body[:mainAddress]
      partners = body[:partners][:individuals]

      matera_body = {
        externalIdentifier: Digest::MD5.hexdigest(body[:document] + Time.now.to_i.to_s),
        sharedAccount: false,
        client: {
          name: body[:name],
          socialName: body[:legalName],
          taxIdentifier: {
            taxId: body[:document],
            country: 'BRA'
          },
          mobilePhone: {
            country: 'BRA',
            phoneNumber: body[:phone][:areaCode] + body[:phone][:number]
          },
          email: body[:email]
        },
        additionalDetailsCorporate: {
          companyName: body[:name],
          businessLine: '47',
          establishmentForm: '1',
          establishmentDate: body[:dateEstablishment],
          representatives: [],
          monthlyIncome: 0
        }
      }


      partners.each do |partner|
        partner_address = partner[:mainAddress]
        partner = {
          name: partner[:name],
          taxIdentifier: {
            taxId: partner[:nationalRegistration],
            country: 'BRA'
          },
          mobilePhone: {
            country: 'BRA',
            phoneNumber: partner[:mainPhone][:area] + partner[:mainPhone][:number]
          },
          email: body[:email],
          mother: partner[:moterName],
          birthDate: partner[:dateBirth],
          mailAddress: {
            logradouro: partner_address[:street],
            numero: partner_address[:number],
            cidade: partner_address[:city],
            estado: partner_address[:federativeUnit],
            cep: partner_address[:zipCode],
            pais: partner_address[:country],
            bairro: partner_address[:neighborhood]
          }
        }
        matera_body[:additionalDetailsCorporate][:representatives] << partner
      end

      puts matera_body

      response = @request.post(@url + ACCOUNT_PATH, matera_body, [matera_body[:externalIdentifier], matera_body[:client][:taxIdentifier][:taxId]].join(''))

      account = MateraModel.new(response)

      puts account

      if account&.data
        account.data['registration_id'] = account.data['account']['accountId']
        account.data['id'] = matera_body[:externalIdentifier]
        account.data['account_id'] = matera_body[:externalIdentifier]
        account.data['person_id'] = account.data['accountHolderId']
      end
      account
    end

    def createRegistrationPf(body, _version = 1)
      address = body[:address]

      matera_body = {
        externalIdentifier: Digest::MD5.hexdigest(body[:document] + Time.now.to_i.to_s),
        sharedAccount: false,
        clientType: 'PERSON',
        accountType: 'UNLIMITED_ORDINARY',
        client: {
          name: body[:name],
          birthDate: body[:birthDate],
          mother: body[:motherName],
          taxIdentifier: {
            taxId: body[:document],
            country: 'BRA'
          },
          mobilePhone: {
            country: 'BRA',
            phoneNumber: body[:phone][:areaCode] + body[:phone][:number]
          },
          email: body[:email]
        },
        billingAddress: {
          logradouro: address[:street],
          numero: address[:number],
          complemento: address[:complement],
          cidade: address[:city],
          estado: address[:federativeUnit],
          cep: address[:zipCode],
          pais: address[:country],
          bairro: address[:neighborhood]
        },
        additionalDetailsPerson: {
          birthDate: body[:birthDate],
          mother: body[:motherName]
        }
      }

      puts matera_body

      response = @request.post(@url + ACCOUNT_PATH, matera_body, [matera_body[:externalIdentifier], matera_body[:client][:taxIdentifier][:taxId]].join(''))

      account = MateraModel.new(response)

      puts account

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
