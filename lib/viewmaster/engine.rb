module Viewmaster
  class Engine < ::Rails::Engine
    isolate_namespace Viewmaster

    config.generators do |g|
      g.test_framework  :rspec,
                        :fixture_replacement => :factory_girl ,
                        :dir => "spec/factories"
      g.integration_tool :rspec
    end

    initializer "Viewmaster request logic" do |app|
      ActionController::Base.send(:include, Viewmaster::Request)
    end

  end
end




