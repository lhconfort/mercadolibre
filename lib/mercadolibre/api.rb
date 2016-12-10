module Mercadolibre
  class Api
    attr_accessor :access_token

    def initialize(args={})
      @app_key = args[:app_key]
      @app_secret = args[:app_secret]
      @callback_url = args[:callback_url]
      @access_token = args[:access_token]
      @endpoint_url = 'https://api.mercadolibre.com'
      @auth_url = args[:auth_url] || 'https://auth.mercadolibre.com.ar'
      @debug = args[:debug]
      @site = args[:site]
    end

    include Mercadolibre::Core::Auth
    include Mercadolibre::Core::CategoriesAndListings
    include Mercadolibre::Core::ItemsAndSearches
    include Mercadolibre::Core::LocationsAndCurrencies
    include Mercadolibre::Core::OrderManagement
    include Mercadolibre::Core::Questions
    include Mercadolibre::Core::Shippings
    include Mercadolibre::Core::Users

    private

    def get_request(action, params={}, headers={})
      begin
        parse_response(RestClient.get("#{@endpoint_url}#{action}", {params: params}.merge(headers)))
      rescue => e
        parse_response(e.response)
      end
    end

    def post_request(action, params={}, headers={})
      begin
        parse_response(RestClient.post("#{@endpoint_url}#{action}", params, headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def put_request(action, params={}, headers={})
      begin
        parse_response(RestClient.put("#{@endpoint_url}#{action}", params, headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def patch_request(action, params={}, headers={})
      begin
        parse_response(RestClient.patch("#{@endpoint_url}#{action}", params, headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def head_request(action, params={})
      begin
        parse_response(RestClient.head("#{@endpoint_url}#{action}", params))
      rescue => e
        parse_response(e.response)
      end
    end

    def delete_request(action, params={})
      begin
        parse_response(RestClient.delete("#{@endpoint_url}#{action}", params))
      rescue => e
        parse_response(e.response)
      end
    end

    def parse_response(response)
      result = {
        headers: response.headers,
        body: (JSON.parse(response.body) rescue response.body),
        status_code: response.code
      }

      p "DEBUG: #{result}" if @debug

      result
    end
  end
end
