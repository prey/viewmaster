module Viewmaster
  class Config

    def self.setup
      @@versions = []
      yield self
    end

    def self.layouts
      versions.map(&:name)
    end

    def self.default_version
      version = @@default_version.is_a?(Proc) ? @@default_version.call : @@default_version
      Config.versions.detect{|o| o.name == version }
    end

    def self.default_version=(version_name)
      @@default_version = version_name
    end

    def self.versions
      @@versions
    end

    def self.add_version(opts={}, &block)
      @@versions << Viewmaster::TemplateVersion.new(opts, &block)
    end

    def self.include?(name)
      self.layouts.include?(name)
    end

  end
end