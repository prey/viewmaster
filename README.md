# Viewmaster

![logo](./logo.png)


##The layout version switcher for Rails.


[![Build Status](https://travis-ci.org/michelson/viewmaster.png?branch=master)](http://travis-ci.org/michelson/viewmaster)
[![Code Climate](https://codeclimate.com/github/michelson/viewmaster.png)](https://codeclimate.com/github/michelson/viewmaster)

[ChangeLog](https://github.com/michelson/viewmaster/blob/master/CHANGELOG.md)

### Motivation:

When completely overhauling the interface of an app, it's our responsibility to make sure the user does not suffer because of the transition, considering he might need to re-learn to use our app practically from scratch. 

The common pattern to minimize the impact on the users is to allow them to transition back and forth between versions.

This gem provides said functionality, allowing you to easily implement the transition between your current layout and **one or more new layout versions**.

### Usage:

Viewmaster will need a current_user variable to be accesible from controller, just as many authentication solutions do. For example with Devise will work just fine.

#### config/routes.rb

```ruby
  # mount Viewmaster routes
  mount Viewmaster::Engine, at: "/"
```

#### config/initializers/viewmaster.rb

```ruby

  #configuration for viewmaster

  Viewmaster::Config.setup do |config|
    config.default_version  = "v1"

    config.add_version(name: "v1") do |version|
      version.template_path = "app/views/v1"
      version.transition to: ["v2"],
        do: ->{::ApplicationController.change_layout_version},
        filter: Proc.new{ |name| ::ApplicationController.user_can_switch_to?(name)}
    end

    config.add_version(name: "v2") do |version|
      version.template_path = "app/views/v2"
      version.transition to: ["v1"],
        do: ->{::ApplicationController.change_layout_version}
    end

  end

```

**default version**: sets the default layout version that will render in case the user does not have a version set in session or a setting persisted in DB. It can also accepts Procs.

**version block**: you can add as many layout versions you want with an `add_version` block. Then, `template_path` will set the proper path for that version to look up for your templates.

**transition block** will enable you to handle which versions will the user be able to transition to. Also you can set a callback action which is going to be triggered when transition from one version to another is completed. For example, this can help you to send data to KissMetric or Statsd.

Also you could add a `filter` to enable/disable the transition functionality on specific cases. For example, an user registered after the launch of the new version should not be able to transition to the old version, but old users could switch back to their previous known version.


PreyProject © 2005 , licensed under MIT.

