require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


module Viewmaster
  describe LooksController do


    let(:user){ FactoryGirl.build(:user) }

    before :each do
      ApplicationController.any_instance.stub(:logged_in?).and_return(true)
      Request.stub(:logged_in?).and_return(true)

      controller.stub(:logged_in?).and_return(true)
      controller.stub(:current_user).and_return(user)

      Viewmaster::Config.setup do |config|
        config.default_version  = "v1"

        config.add_version(name: "v1") do |version|
          version.template_path = "app/views/v1"
          version.transition to: ["v3"], do: -> { RequestStore.store[:current_user].update_attribute(:layout, RequestStore.store[:new_layout]) }

        end

        config.add_version(name: "v3") do |version|
          version.template_path = "app/views/v3"
          version.transition to: ["v1"], do: -> { RequestStore.store[:current_user].update_attribute(:layout, RequestStore.store[:new_layout]) }

        end
      end
    end

    it "switch to v3 from nil layout" do
      expect(user.layout).to be_blank
      get :switch_to, id: "v3"
      response.should redirect_to '/'
      expect(cookies[:layout]).to be == "v3"
      expect(user.layout).to be == "v3"
    end

    it "switch back to v1 from v3" do
      get :switch_to, id: "v3"
      expect(user.layout).to be == "v3"
      get :switch_to, id: "v1"
      expect(cookies[:layout]).to be == "v1"
      expect(user.layout).to be == "v1"
    end

  end
end
