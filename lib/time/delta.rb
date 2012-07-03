# Copyright (C) 2010-2012 Kenichi Kamiya

require 'forwardable'
require 'instancevalue'
require 'striuct'

class Time
  
  # immutable
  class Delta
    
    include Comparable
    include InstanceValue
    
    Units = Striuct.define {
      
    }
    
    class << self
      
      def def_wrapper(method)
        define_method method |other|
          Delta.new(seconds.__send__ method, other)
        end
      end
    
    end
    
    value_reader :seconds
    
    def initialize(seconds)
      raise TypeError unless seconds.respond_to? :to_r

      val :seconds, seconds.to_r
    end

    # @return [Integer]
    def sleep
      Kernel.sleep seconds
    end
    
    # @return [Units]
    def units
    end
    
    def eql?(other)
      seconds == (
        if other.kind_of? Delta
          other.seconds
        else
          if other.kind_of? ::Numeric
            other
          else
            if other.respond_to? :to_int
              other.to_int
            else
              false
            end
          end
        end
      )
    end
    
    alias_method :==, :eql?
    
    # @return [Delta]
    def_wrapper :+, :-, :/, :div, :quo, :*
    
    # @see Rational
    def_delegators(:seconds,
      :to_i, :to_f, :to_r, :remainder, :zero?,
      :nonzero?, :<=>, :step, :coerce, :%, :hash
    )
    
    
    
    
    
    
    
  end
  
end