require "HashEx/version"

module HashEx
  class Base < Hash
  protected
    alias_method :regular_writer, :[]= unless method_defined?(:regular_writer)
    alias_method :regular_update, :update unless method_defined?(:regular_update)

  public
    def initialize(constructor = {})
      if constructor.respond_to?(:to_hash)
        super()
        update(constructor)

        hash = constructor.to_hash
        self.default = hash.default if hash.default
        self.default_proc = hash.default_proc if hash.default_proc
      else
        super(constructor)
      end
    end

    def self.[](*args)
      new.merge!(Hash[*args])
    end

    def method_missing(method, *args, &block)
      key = method.to_s
      if key[-1] == '='
        self[key.chop] = args[0]
      else
        self[key]
      end
    end

    def key?(key)
      super(convert_key(key))
    end

    alias_method :include?, :key?
    alias_method :has_key?, :key?
    alias_method :member?, :key?

    def [](key)
      super(convert_key(key))
    end

    def fetch(key, *extras)
      super(convert_key(key), *extras)
    end

    def []=(key, value)
      regular_writer(convert_key(key), convert_value(value))
    end

    alias_method :store, :[]=

    def update(other_hash)
      if other_hash.is_a? self.class
        super(other_hash)
      else
        other_hash.to_hash.each_pair do |key, value|
          if block_given? && key?(key)
            value = yield(convert_key(key), self[key], value)
          end
          regular_writer(convert_key(key), convert_value(value))
        end
        self
      end
    end

    alias_method :merge!, :update

    if Hash.method_defined?(:dig)
      def dig(*args)
        args[0] = convert_key(args[0]) if args.size > 0
        super(*args)
      end
    end

    def default(*args)
      super(*args.map { |arg| convert_key(arg) })
    end

    def values_at(*indices)
      indices.collect { |key| self[convert_key(key)] }
    end

    if Hash.method_defined?(:fetch_values)
      def fetch_values(*indices, &block)
        indices.collect { |key| fetch(key, &block) }
      end
    end

    def merge(hash, &block)
      dup.update(hash, &block)
    end

    def reverse_merge(other_hash)
      super(self.class.new(other_hash))
    end

    def reverse_merge!(other_hash)
      super(self.class.new(other_hash))
    end

    def replace(other_hash)
      super(self.class.new(other_hash))
    end

    def delete(key)
      super(convert_key(key))
    end

    def select(*args, &block)
      return to_enum(:select) unless block_given?
      dup.tap { |hash| hash.select!(*args, &block) }
    end

    def reject(*args, &block)
      return to_enum(:reject) unless block_given?
      dup.tap { |hash| hash.reject!(*args, &block) }
    end

    def transform_keys(*args, &block)
      return to_enum(:transform_keys) unless block_given?
      dup.tap { |hash| hash.transform_keys!(*args, &block) }
    end

    def transform_values(*args, &block)
      return to_enum(:transform_values) unless block_given?
      dup.tap { |hash| hash.transform_values!(*args, &block) }
    end

    def slice(*keys)
      keys.map! { |key| convert_key(key) }
      self.class.new(super)
    end

    def slice!(*keys)
      keys.map! { |key| convert_key(key) }
      super
    end

    def compact
      dup.tap(&:compact!)
    end

    def to_h
      h = Hash.new
      set_defaults(h)

      each do |key, value|
        h[key] = convert_value(value, revert: true)
      end
      h
    end

  protected
    def convert_key(key)
      raise "Method #convert_key must be rewritten"
    end

    def convert_value(value, revert: false)
      if value.is_a? Hash
        if revert
          value.to_h
        else
          value.is_a?(self.class) ? value : self.class.new(value)
        end
      elsif value.is_a? Array
        value.map { |e| convert_value(e) }
      else
        value
      end
    end
  end

  class JsObject < Base
  protected
    def convert_key(key)
      key.kind_of?(Symbol) ? key.to_s : key
    end
  end
end
