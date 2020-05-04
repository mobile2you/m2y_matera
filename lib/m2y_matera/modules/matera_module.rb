module M2yMatera

  class MateraModule

      def startModule(access_key, secret_key, env)
        @request = MateraRequest.new(access_key, secret_key)
        @url = MateraHelper.homologation?(env) ? URL_HML : URL_PRD
      end

      def generateResponse(input)
        MateraHelper.generate_general_response(input)
      end
  end

end
