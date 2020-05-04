require "httparty"

module M2yMatera

  class MateraRequest

    def initialize(access_key, secret_key)
      @secret_key = secret_key
      @headers = {
          "Content-Type" => 'application/json',
          "Api-Access-Key" => access_key
      }
    end


    def get(url, transaction_hash)
      @headers["Transaction-Hash"] = calculate_hash(transaction_hash)
      puts url.to_s
      req = HTTParty.get(url, headers: @headers)
      req.parsed_response
    end

    def post(url, body, transaction_hash)
      puts transaction_hash
      @headers["Transaction-Hash"] = calculate_hash(transaction_hash)
      puts @headers["Transaction-Hash"]
      puts url.to_s
      req = HTTParty.post(url,
                          body: body.to_json,
                          headers: @headers
      )
      req.parsed_response
    end



    private
    def calculate_hash(data)
      digest = OpenSSL::Digest.new('sha256')
      OpenSSL::HMAC.hexdigest(digest, @secret_key, data)
    end

  end

end
