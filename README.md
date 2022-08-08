# UiucLibAd

This is a gem designed to make common Active Directory calls in Library software easy to call.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uiuc_lib_ad', git: 'https://github.com/UIUCLibrary/uiuc_lib_ad.git'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install uiuc_lib_ad

For now, this gem requires four environmental variables to be set...
    * UIUCLIBAD_USER - the dn of the service account connecting to AD 
    * UIUCLIBAD_PASSWORD - the password for the service account connecting to AD
    * UIUCLIBAD_ADSERVER - the ad server. Usually ad.uillinois.edu
    * UIUCLIBAD_TREEBASE - the default search base, you'll want to use DC=ad,DC=uillinois,DC=edu


At some point I'll look at best practices with configuration of Ruby gems to try to seeif there's a way to get more options.


As of right now, there's no need to tweak the skeleton, it's basically defaulting to uofi domain and has the highest level "base" as a config option.

## Usage

```
require 'uiuc_lib_ad'

user = UiucLibAd::Entity.new( entity_cn: "jtgorman" )

if user.is_member_of(group_cn: "Library IT - IMS Faculty and Staff)
  # do one thing for auth user
else
  #do other thing
end

```
If an entity or a is_member_of is passed a cn or dn that doesn't exist, an exception will be thrown.



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test-unit` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/uiuc_lib_ad. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/uiuc_lib_ad/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the UiucLibAd project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/uiuc_lib_ad/blob/master/CODE_OF_CONDUCT.md).
