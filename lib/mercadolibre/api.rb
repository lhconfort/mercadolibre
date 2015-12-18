module Mercadolibre
  class Api
    attr_accessor :access_token

    def initialize(args={})
      @app_key = args[:app_key]
      @app_secret = args[:app_secret]
      @callback_url = args[:callback_url]
      @site = args[:site]
      @access_token = args[:access_token]
      @endpoint_url = 'https://api.mercadolibre.com'
      @auth_url = "https://auth.#{sdl}.#{tdl}/authorization"
      @logout_url = "https://www.#{sdl}.#{tdl}/jm/logout"
      @debug = args[:debug]
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

    def sdl
      if @site == 'MLB' || @site == 'MPT'
        'mercadolivre'
      else
        'mercadolibre'
      end
    end

    def tdl
      case @site
      when 'MLA' then 'com.ar'
      when 'MLB' then 'com.br'
      when 'MLU' then 'com.uy'
      when 'MLC' then 'cl'
      when 'MEC' then 'com.ec'
      when 'MPE' then 'com.pe'
      when 'MPT' then 'pt'
      when 'MLV' then 'com.ve'
      when 'MCO' then 'com.co'
      when 'MCR' then 'co.cr'
      when 'MPA' then 'com.pa'
      when 'MRD' then 'com.do'
      when 'MLM' then 'com.m'
      else
        'com'
      end
    end

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
