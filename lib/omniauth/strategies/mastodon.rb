require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mastodon < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'read'.freeze

      option :name, 'mastodon'

      option :credentials
      option :identifier
      option :authorize_options, [:scope]

      option :client_options, {
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      }

      uid { identifier }

      info do
        {
          name: raw_info['username'],
          nickname: raw_info['username'],
          image: raw_info['avatar'],
          urls: { 'Profile' => raw_info['url'] }
        }
      end

      extra do
        { raw_info: raw_info }
      end

      # Before we can redirect the user to authorize access, we must know where the user is from
      # If the identifier param is not already present, a form will be shown for entering it
      def request_phase
        identifier ? start_oauth : get_identifier
      end

      def callback_phase
        set_options_from_identifier
        super
      end

      def raw_info
        @raw_info ||= access_token.get('api/v1/accounts/verify_credentials').parsed
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      private

      def get_identifier
        form = OmniAuth::Form.new(title: 'Mastodon Login')
        form.text_field 'Your full Mastodon identifier (username@domain)', 'identifier'
        form.button 'Login'
        form.to_response
      end

      def start_oauth
        set_options_from_identifier
        redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params))
      end

      def identifier
        i = options.identifier || request.params['identifier'] || (env['omniauth.params'].is_a?(Hash) ? env['omniauth.params']['identifier'] : nil)
        i = i.downcase.strip unless i.nil?
        i = nil if i == ''
        i
      end

      def set_options_from_identifier
        username, domain         = identifier.split('@')
        client_id, client_secret = options.credentials.call(domain, callback_url)

        options.identifier            = identifier
        options.client_options[:site] = "https://#{domain}"
        options.client_id             = client_id
        options.client_secret         = client_secret
      end
    end
  end
end
