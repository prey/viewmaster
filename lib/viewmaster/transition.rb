module Viewmaster
  class Transition
    attr_accessor :from
    attr_accessor :to
    attr_accessor :callback
    attr_accessor :filter

    def initialize(opts={}, &block)
      @to         = opts[:to]
      @from       = opts[:from]
      @callback   = opts[:do]
      @filter     = opts[:filter]
      yield self
    end

    def run_callback
      callback.call unless callback.blank?
    end
  end
end