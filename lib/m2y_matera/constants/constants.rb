module M2yMatera
  
  #envs
  HOMOLOGATION = "hml"
  PRODUCTION = "prd"

  #urls
  # URL_HML = "https://varcom-mp-api-01.matera.com/"
  URL_HML = "https://incubadora-mp-api-hml.matera.systems/"
  URL_PRD = "https://monetiza-flagship-prd-mp-server.maas.link/"

  ### Paths

  #account
  ACCOUNT_PATH = "v1/accounts/"
  DEPOSIT_PATH = "v1/accounts/deposits"
  PAYMENT_PATH = "v1/payments"
  RECHARGE_PATH = 'v1/country/BRA/area-code/'

  STATEMENT = "/statement"
  WITHDRAW = "/withdraw"
  VALIDATION_BUREAU = "/validationBureauCallback"
  BALANCE = "/balance"
  RECHARGE = '/recharge'
  TRANSACTIONS = '/transactions'

  BILLS_PATH = 'v3/bills'

  PUSH = '/notifications/push'
end
