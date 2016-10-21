require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mastodon < OmniAuth::Strategies::OAuth2
      option :name, 'mastodon'

      option :domain

      uid { [raw_info['username'], '@', options.domain].join }

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

      def raw_info
        @raw_info ||= access_token.get('api/v1/accounts/verify_credentials').parsed
      end
    end
  end
end
