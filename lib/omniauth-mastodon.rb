require 'i18n'
I18n.load_path += Dir[File.expand_path('../omniauth/mastodon/locale/*.yml', __FILE__)]

require 'omniauth/mastodon/version'
require 'omniauth/strategies/mastodon'
