# Copyright (C) 2010-2012 Kenichi Kamiya

class Time
  
  class << self
    
    Delta::Units.members.each do |unit|
      define_method unit.capitalize do |size|
        Delta.new size * 
      end
    end
    
    def Seconds(size)
    end
    
    def Minutes(size)
    end
    
  end
  
end