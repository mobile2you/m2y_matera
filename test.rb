require "m2y_matera"


puts "testando contas"
# a = M2yMatera::MateraAccount.new("56C11618-E80F-6536-921C-9555C410F4D1", "36168AC6-5418-1CF7-5DE7-913304CF3B0B", "prod")
# p a.getAccounts("4A710C56-79F8-00A3-A4CD-3830F1DC8E45")
# p a.getTransactions("4A710C56-79F8-00A3-A4CD-3830F1DC8E45")

puts "testando cadastro"

# a = M2yMatera::MateraRegistration.new("56C11618-E80F-6536-921C-9555C410F4D1", "36168AC6-5418-1CF7-5DE7-913304CF3B0B", "prod")

# cdt_params = {}
# cdt_params[:name] = "Caio Lopes"
# cdt_params[:legalName] = "Caio Lopes"
# cdt_params[:document] = "98385944000129"
# cdt_params[:email] = "caio.lopes@mobil2you.com.br"
# cdt_params[:phone] = {
#  :areaCode => '011',
#  :number => "971806012"
# }

# p a.createRegistration(cdt_params)

 # a = M2yMatera::MateraIndividual.new("56C11618-E80F-6536-921C-9555C410F4D1", "36168AC6-5418-1CF7-5DE7-913304CF3B0B", "prod")

# cdt_params = {}
# cdt_params[:name] = "Caio Lopes"
# cdt_params[:legalName] = "Caio Lopes"
# cdt_params[:document] = "98385944000129"
# cdt_params[:email] = "caio.lopes@mobil2you.com.br"
# cdt_params[:phone] = {
#  :areaCode => '011',
#  :number => "971806012"
# }

# p a.findPerson("98385944000129")


 # a = M2yMatera::MateraBillet.new("56C11618-E80F-6536-921C-9555C410F4D1", "36168AC6-5418-1CF7-5DE7-913304CF3B0B", "prod")



# parsedParams = {
#     idConta: "4A710C56-79F8-00A3-A4CD-3830F1DC8E45",
#     valor: 10.53,
#     dataVencimento: (DateTime.now.to_date).strftime("%Y-%m-%d"),
#     tipoBoleto: 9,
# }



# p a.generateTicket(parsedParams)

# a = M2yMatera::MateraBankSlip.new("56C11618-E80F-6536-921C-9555C410F4D1", "36168AC6-5418-1CF7-5DE7-913304CF3B0B", "prod")

# p a.getPDF("2267AFA4-C0CB-31CC-D6F9-F50F7605B570")



a = M2yMatera::MateraService.new("56C11618-E80F-6536-921C-9555C410F4D1", "36168AC6-5418-1CF7-5DE7-913304CF3B0B", "prod")

parsedParams = {
    originalAccount: "4A710C56-79F8-00A3-A4CD-3830F1DC8E45",
    destinationAccount: "FB71CADF-49F8-5C59-68A0-D9AAE2785F42",
    amount: 1.53,
}


p a.p2pTransfer(parsedParams)

