# frozen_string_literal: true
module Upgrow
  # A read-only Object. An Immutable Object is initialized with its attributes
  # and subsequent state changes are not permitted.
  class ImmutableObject
    @attribute_names = []

    class << self
      attr_reader :attribute_names

      # Specify an attribute for the Immutable Object. This enables the object
      # to be instantiated with the attribute, as well as creates an attribute
      # reader for it.
      #
      # @param name [Symbol] the name of the attribute.
      def attribute(name)
        @attribute_names << name
        attr_reader(name)
      end

      private

      def inherited(subclass)
        super
        subclass.instance_variable_set(:@attribute_names, @attribute_names.dup)
      end
    end

    # Initializes a new Immutable Object with the given member values.
    #
    # @param args [Hash<Symbol, Object>] the list of values for each attribute
    #   of the Immutable Object.
    #
    # @raise [ArgumentError] if the given argument is not an attribute.
    def initialize(**args)
      absent_attributes = args.keys - self.class.attribute_names

      if absent_attributes.any?
        raise ArgumentError, "Unknown attribute #{absent_attributes}"
      end

      args.each do |name, value|
        instance_variable_set("@#{name}", value)
      end

      freeze
    end
  end
end
