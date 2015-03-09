require File.expand_path(File.dirname(__FILE__) + '/../../spec/spec_helper')

class SomeClass

  def self.some_method
    puts "method received"
    true
  end
end

describe "Config class" do
  before(:all) do

  end

  it "should have all the required keys" do
    Viewmaster::Config.setup do |config|
      config.default_version = "v1"
      config.add_version(name: "v1", template_path: "app/views/v1" )
      config.add_version(name: "v2", template_path: "app/views/v2" )
      config.add_version(name: "v3", template_path: "app/views/v3" )
    end
    expect(Viewmaster::Config).to have(3).versions
  end

  describe "block & transitions" do
    before do
      @config ||= Viewmaster::Config.setup do |config|
        config.add_version(name: "v1") do |version|
          version.template_path = "app/views/v1"
          version.transition to: ["v2", "v3"], do: ->{ SomeClass.some_method }
        end
      end
    end
    it "should have versions" do
      expect(@config).to have(1).versions
      expect(@config.first.template_path).to be == "app/views/v1"
    end

    it "v1 should be default version" do
      expect(Viewmaster::Config.default_version).to be_an_instance_of Viewmaster::TemplateVersion
      expect(Viewmaster::Config.default_version.name).to be == "v1"
    end

    it "v1 should transitions to v1 and v2" do
      expect(@config.first).to have(1).transitions
      expect(@config.first.can_transition_to?("v2")).to be_true
      expect(@config.first.can_transition_to?("v3")).to be_true
    end

    context "change state" do
      it "should call method on callback class" do
        expect(SomeClass).to receive(:some_method)
        @config.first.change_version_to("v2")
      end

      it "should raise error if cant change version" do
        expect{@config.first.change_version_to("v5")}.to raise_error(RuntimeError)
      end
    end

  end

end