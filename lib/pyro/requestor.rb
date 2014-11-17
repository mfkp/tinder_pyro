module TinderPyro
  class Requestor
    include HTTParty

    attr_accessor :auth_token

    base_uri 'https://api.gotinder.com'

    def auth_request(facebook_id, facebook_token)
      post_request(
        :auth,
        facebook_id: facebook_id,
        facebook_token: facebook_token
      ).tap do |response|
        @auth_token = response['token']
      end
    end

    def get_request(endpoint)
      self.class.get("/#{endpoint}", headers: all_headers)
    end

    def post_request(endpoint, data = {})
      self.class.post(
        "/#{endpoint}",
        body: data.to_json,
        headers: all_headers
      )
    end

    private

    def all_headers
      default_headers.merge(auth_headers)
    end

    def auth_headers
      if @auth_token
        {
          'Authentication' => %Q(Token token="#{@auth_token}"),
          'X-Auth-Token' => @auth_token
        }
      else
        {}
      end
    end

    def default_headers
      {
        'Content-Type' => 'application/json; charset=utf-8',
        'User-Agent' => 'Tinder/4.0.9 (iPhone; iOS 8.0.2; Scale/2.00)',
        'Accept-Language' => 'en;q=1',
        'platform' => 'ios',
        'app-version' => '123',
        'os_version' => '80000000002'
      }
    end
  end
end
