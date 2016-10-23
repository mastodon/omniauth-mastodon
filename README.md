OmniAuth::Mastodon
==================

[![Gem Version](http://img.shields.io/gem/v/omniauth-mastodon.svg)][gem]

[gem]: https://rubygems.org/gems/omniauth-mastodon

Authentication strategy for federated Mastodon instances. This is just slightly more complicated than a traditional OAuth2 flow: We do not know the URL of the OAuth end-points in advance, nor can we be sure that
we already have client credentials for that Mastodon instance.

## Installation

    gem 'mastodon-api', require: 'mastodon'
    gem 'omniauth-mastodon'
    gem 'omniauth'

## Configuration

Example:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mastodon, scope: 'read write follow', credentials: lambda { |domain, callback_url|
    Rails.logger.info "Requested credentials for #{domain} with callback URL #{callback_url}"

    existing = MastodonClient.find_by(domain: domain)
    return [existing.client_id, existing.client_secret] unless existing.nil?

    client = Mastodon::REST::Client.new(base_url: "https://#{domain}")
    app = client.create_app('OmniAuth Test Harness', callback_url)

    MastodonClient.create!(domain: domain, client_id: app.client_id, client_secret: app.client_secret)

    [app.client_id, app.client_secret]
  }
end
```

The only configuration key you need to set is a lambda for `:credentials`. That lambda will be called whenever we need to get client credentials for OAuth2 requests. The example above uses an ActiveRecord model to store client credentials for different Mastodon domains, and uses the `mastodon-api` gem to fetch them dynamically if they're not stored yet.
