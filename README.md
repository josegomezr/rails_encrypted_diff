# RailsEncryptedDiff

See differences between rails encrypted credentials across branches.

## Why??

I grew tired of manually decrypting the files, then running diff, then cleaning up everything and hope that I didn't miss a detail or commited it to the repo. Really the only reason 🤷

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_encrypted_diff'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_encrypted_diff

## Usage

```
bin/rails encrypted:diff[store,key,target_branch]  # Diff the encrypted storage against a version in another branch (master by default)
# defaults
# store = config/credentials.yml.enc
# key = config/master.ket
# target_branch = master
```

## 🚨🚨 WARNING 🚨🚨

🚨🚨 THIS IS INTENDED FOR CODE REVIEWS 🚨🚨

Please for the love of god, don't run this on a CI, you'll expose secrets and it'll create a mess.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/josegomezr/rails_encrypted_diff.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
