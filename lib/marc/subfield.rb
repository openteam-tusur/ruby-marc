module MARC
  
  # A class that represents an individual  subfield within a DataField. 
  # Accessor attributes include: code (letter subfield code) and value 
  # (the content of the subfield). Both can be empty string, but should 
  # not be set to nil. 

  module SubfieldMixin
    def initialize(icode='' ,ivalue='')
      # can't allow code of value to be nil
      # or else it'll screw us up later on
      self.code = icode == nil ? '' : icode
      self.value = ivalue == nil ? '' : ivalue
    end

    def ==(other)
      if code != other.code
        return false
      elsif value != other.value
        return false
      end
      return true
    end

    def to_s
      return "$#{code} #{value} "
    end
  end
  
  
  # Subfield class must provide:
  #  * code, code=
  #  * value, value=
  
  class Subfield
    attr_accessor :code, :value
    include SubfieldMixin
  end
end
