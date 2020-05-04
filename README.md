# Magic::Link
Short description and motivation.

## Usage
configure the gem
```ruby
# config/initializers/magic_link.rb
Magic::Link.configure do |config|
  config.user_class = "Customer" # Default is User
  config.email_from = "test@yourapp.com"
  config.token_expiration_hours = 6 # Default is 6
end
```

## Upgrading to 1.0.0

Run `rails magic_link:install:migrations`

Run `rails db:migrate`

You can move your existing tokens over by running this:

Run `rails magic_link:move_to_multi`

Or if you prefer to integrate it into your own migration, you can

Run `Magic::Link::Utility.move_to_multi`

That line will create copy existing `sign_in_token` and `sign_in_token_sent_at` to the new magic_link_tokens table/schema.

You can then remove those columns from your existing User/Resource table in the same migration.


## 1.0.0 New Features

The API has changed slightly to the following:

`mg = Magic::Link::MagicLink.new(email: 'someone@hi.com')`

This will generate a new token on first call but return the same token on subsequent
`mg.get_login_token` 

Same with this one, and in fact the tokens are the same within the same mg instance
`mg.send_login_instructions` 

The `send_login_instructions` now returns a mail object, which you can then call `deliver_now` on or `deliver_later`
`mail = mg.send_login_instructions; mail.deliver_now` 

You can now make links/tokens reusable. They will still expire at the configured time, but can be clicked multiple times.

`mg = Magic::Link::MagicLink.new(email: 'someone@hi.com', reusable: true)`



## 1.0.0 Dropped Features

MagicLink no longer accepts options for path or resource_id. 

You can use the new magic_link_to helper to construct URLs that go directly to the desired protected URL.


reusable

path/resource_id

Remove old columns 


resource_or_magic_link
magic_link_to('joel', app.admin_dashboard_path(10), reusable: true, resource: User.last)
magic_link_to(app.admin_dashboard_path(10), {class: 'help'}, resource: User.last) { 'joel' }


mount the engine
```ruby
mount Magic::Link::Engine, at: '/'
```

Now users can visit `/magic_links/new` to enter their email and have a sign in
link sent to them via email. Tokens are cleared after use and expire after the
configured number of hours

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'magic-link'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install magic-link
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
