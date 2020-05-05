# Magic::Link
Send users a clickable magic login link. 

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

mount the engine
```ruby
mount Magic::Link::Engine, at: '/'
```

Now users can visit `/magic_links/new` to enter their email and have a sign in
link sent to them via email. Tokens are cleared after use and expire after the
configured number of hours



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

There is a new helper `magic_link_to` that works just like `link_to` but takes a `resource:` param and an optional `reusable:` param. 

If it's given a User/Resource instance, it will create a new token. If it's given a MagicLink instance, it will use that. The main feature of magic_link_to is to automatically append the correct params to ANY generated link.

So for example

```
user = User.find_by(email: 'bob@hi.com')
magic_link_to('Admin Dashboard', app.admin_dashboard_path, reusable: true, resource: user)
# <a href="/admin/dashboard?email=bob@hi.com&sign_in_token=asdf3dafsfj">Admin Dashboard</a>
```

You can use any of the same formats as `link_to`

```
magic_link_to(app.admin_edit_user(user), {class: 'selected-link'}, resource: user) do {
  "Edit This User"
}
```

Example using an instance of MagicLink. This is useful if you want to have the same token. You would probably want to make it reusable if it's for different features. Or it could be reused as a single login link for a set of different links
```
mg = Magic::Link::MagicLink.new(email: 'bob@bob.com')
magic_link_to('Edit My Account', app.admin_edit_user(user), resource: mg) 
```

You can also call `mg.to_hash` to use within existing link_to:

```
mg.to_hash
#  {:email=>"bob@hi.com", :sign_in_token=>"gWd8ZPad49uDm6PExeUaBM"}
```

Or `mg.to_param` to get the query string representation:

```
mg.to_param
# "email=bob%40hi.com&sign_in_token=gWd8ZPad49uDm6PExeUaBMM"  
```

## 1.0.0 Dropped Features

MagicLink no longer accepts options for `path` or `resource_id`. 

You can use the new magic_link_to helper to construct URLs that go directly to the desired protected URL.



## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
