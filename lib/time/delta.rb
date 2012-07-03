# Copyright (C) 2010-2012 Kenichi Kamiya

require 'forwardable'
#~ require 'time/unit'
require 'instancevalue'
require 'striuct'

class Time
  
  class Unit
    attr_reader :radix
    
    def initialize(radix)
      @radix = radix
    end
  end
  
  MINUTE = Unit.new 60
  SECOND = Unit.new 1
  MILLISECOND = Unit.new Rational(1, 1000)
  
  
  
  # immutable
  class Delta
    
    include Comparable
    include InstanceValue
    
    Units = Striuct.define {
      member :weeks, AND(Integer, ->n{n >= 0})
      member :days, AND(Integer, 0..7)
      member :hours, AND(Integer, 0..23)
      member :minutes, AND(Integer, 0..59)
      member :seconds, AND(Integer, 0..59)
      member :milliseconds, AND(Integer, 0..999)
      alias_member :msecs, :milliseconds
      member :microseconds, AND(Integer, 0..999)
      member :nanoseconds, AND(Integer, 0..999)
      member :picoseconds, AND(Integer, 0..999)
    
      members.each do |unit|
        default unit, 0
      end
    }
    
    class << self
      
      def def_new_object(method)
        define_method method |other|
          Delta.new(seconds.__send__ method, other)
        end
      end

      def def_new_objects(*methods)
        methods.each do |method|
          def_new_object method
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
    def_new_objects :+, :-, :/, :div, :quo, :*
    
    # @see Rational
    def_delegators(:seconds,
      :to_i, :to_f, :to_r, :remainder, :zero?,
      :nonzero?, :<=>, :step, :coerce, :%, :hash
    )
    
    
    
    
    
    
    
  end
  
  class << self
    
    def units
      [DAY, HOUR]
    end
    
    units.each do |unit|
      define_method unit.capitalize do |size|
        Delta.new size * unit.radix
      end
    end
    
    # @param [Time] time1
    # @param [Time] time2
    # @return [Delta]
    def Delta(time1, time2)
      Seconds(time1 - time2)
    end
    
    alias_method :diff, :Delta
    
  end
  
end