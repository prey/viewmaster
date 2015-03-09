module Viewmaster
  class TemplateVersion
    attr_accessor :template_path
    attr_accessor :name
    attr_reader   :transitions

    def initialize(opts={}, &block)
      @template_path = opts[:template_path]
      @name          = opts[:name]
      @transitions   = []
      @filter        = opts[:filter]
      yield self if block_given?
    end

    def transition(opts={})
      @transitions << Transition.new do |t|
        t.from        = name
        t.to          = opts[:to]
        t.callback    = opts[:do]
        t.filter      = opts[:filter]
      end
    end

    def self.find(name)
      Config.versions.detect{|o| o.name == name}
    end

    def can_transition_to?(transition_name)

      #includes current transition name to the whitelist
      tt = ([transitions.map(&:to).uniq] + [name]).flatten

      transition = transitions.detect{ |t| t.to.include? transition_name}
      can_transition = tt.include?(transition_name)
      if (!transition.nil? && transition.filter.is_a?(Proc))
        return can_transition && transition.filter.call(transition_name)
      else
        return can_transition
      end
    end

    def change_version_to(transition_name)
      unless can_transition_to?(transition_name)
        raise "Can't transition to #{transition_name} from #{self.name}"
      end
      # @block_transition_before_change
      transitions.each{ |o| o.run_callback }
      # @block_transition_after_change
    end

  end
end
