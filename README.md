# Viewmaster

![logo](./logo.png)


##The layout version switcher for Rails.


[![Build Status](https://travis-ci.org/michelson/viewmaster.png?branch=master)](http://travis-ci.org/michelson/viewmaster)
[![Code Climate](https://codeclimate.com/github/michelson/viewmaster.png)](https://codeclimate.com/github/michelson/viewmaster)

[ChangeLog](https://github.com/michelson/viewmaster/blob/master/CHANGELOG.md)

### Motivation:

Many times we face the problem of build the new version of an app, very often that new version are just interface improvements but also could be radical layout change with a tottaly different corporative image, UI, UX , you name it. in either case we always have to keep in mind that the user will suffer when he have to learn all your app stuff again.

In industry there is a common pattern, when a site display to us a new version it enable us to transition back and forth through versions.

the main intention of this gem is to provide that functionality to rails with an easy way to declare the behavior of the transition, even handling more than one *new version*.

### Usage:

Viewmaster will need a current_user variable to be accesible from controller, just as many authentication solutions does. for example with Devise will work just fine.

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

*default version*: sets the default version that will render in case the user will not have the session or the setting, it accepts Procs too

*version block*: you can add as many template versions you want with `add_version` block, `template_path` will set the proper path for that version to look up your templates

*transition block* will enable you to handle which versions will be able to transition to. Also you can set a callback action which is going to be triggered when the user transition from one version to another is done. for example send Kiss Metric, Statsd data when user transition.

Also you could add a `filter` to enable/disable the transition functionality on specific cases. For example an user registered after the lauch of the new version should not be able to transition the old version, but old users could switch back to their previous known version.


PreyProject © 2005 , licensed under MIT.

