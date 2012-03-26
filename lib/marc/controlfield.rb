require 'set'

module MARC

  # MARC records contain control fields, each of which has a 
  # tag and value. Tags for control fields must be in the
  # 001-009 range or be specially added to the @@control_tags Set

  module ControlFieldClassMixin

    # A tag is a control tag if it is a member of the @@control_tags set
    # as either a string (e.g., 'FMT') or in its .to_i representation
    # (e.g., '008'.to_i == 3 is in @@control_tags by default)
  
    # Initially, control tags are the numbers 1 through 9 or the string '000'
    def self.extended(klass)
      klass.instance_eval 'class << self; attr_accessor :control_tags; end'
      klass.control_tags = Set.new( (1..9).to_a)
      klass.control_tags << '000'
      
      klass.instance_eval %q|
        def self.control_tag?(tag)
          return (@control_tags.include?(tag.to_i) or @control_tags.include?(tag))
        end
      |
    end
 
  end

  module ControlFieldMixin
    def initialize(tag,value='')
      self.tag = tag
      self.value = value
      if not self.class.control_tag?(self.tag)
        raise MARC::Exception.new(), "tag must be in 001-009 or in the control_tags set"
      end
    end

    # Two control fields are equal if their tags and values are equal.

    def ==(other)
      if self.tag != other.tag
        return false 
      elsif self.value != other.value
        return false
      end
      return true
    end

    # turning it into a marc-hash element
    def to_marchash
      return [tag, value]
    end
    
    # Turn the control field into a hash for MARC-in-JSON
    def to_hash
      return {tag=>value}
    end
    
    def to_s
     return "#{tag} #{value}" 
    end

   def =~(regex)
     return self.to_s =~ regex
   end      
 end
  
  
  # ControlField must 'extend ControlFieldClassMixin' and
  # 'include ControlFieldMixin'
  #
  # Additionally, it must provide
  #  - tag, tag=
  #  - value, value=

  class ControlField
    extend  ControlFieldClassMixin
    include ControlFieldMixin
    
    def self.hello
      puts "HELLO!!!!"
    end
    
    # the tag value (007, 008, etc)
    attr_accessor :tag

    # the value of the control field
    attr_accessor :value
    
  end

end
