module WWMD
  class ViewState
    # complex types
    def pair(t=nil)
      dlog t,"next = #{next_type}"
      VSStubs::VSPair.new(self.deserialize_value,self.deserialize_value)
    end

    def triplet(t=nil)
      dlog t,"next = #{next_type}"
      VSStubs::VSTriplet.new(self.deserialize_value,self.deserialize_value,self.deserialize_value)
    end

    def type(t=nil)
      typeref,typeval = self.deserialize_type
      dlog(t,"typeref = 0x#{typeref.to_s(16)} typeval = #{typeval}")
      VSStubs::VSType.new(typeref,typeval)
    end

    def string_formatted(t=nil)
      typeref,typeval = self.deserialize_type
      str = self.read_string
      dlog(t,"typeref = 0x#{typeref.to_s(16)} typeval = #{typeval} string = #{str}")
      VSStubs::VSStringFormatted.new(typeref,typeval,str)
    end

    def int_enum(t=nil)
      typeref,typeval = self.deserialize_type
      index = self.read_7bit_encoded_int
      dlog(t,"typeref = 0x#{typeref.to_s(16)} typeval = #{typeval} index = #{index}")
      VSStubs::VSIntEnum.new(typeref,typeval,index)
    end

    def binary_serialized(t=nil)
      count = self.read_7bit_encoded_int
      dlog(t,count)
      bin = self.read(count)
      me = VSStubs::VSBinarySerialized.new()
      me.set(bin)
      return me
    end

    def sparse_array(t=nil)
      typeref,typeval = self.deserialize_type
      size  = read_7bit_encoded_int
      elems = read_7bit_encoded_int
      dlog(t,"typeref = 0x#{typeref.to_s(16)} typeval = #{typeval} size = #{size} elems = #{elems}")
      me = VSStubs::VSSparseArray.new(typeref,typeval,size,elems)
      if elems > size
        raise "Invalid sparse_array"
      end
      (1..elems).each do |i|
        idx = read_7bit_encoded_int
        me.add(idx,self.deserialize_value)
      end
      return me
    end

    def hashtable(t=nil)
      len = read_7bit_encoded_int
      dlog(t,"len = #{len}")
      me = VSStubs::VSHashtable.new()
      (1..len).each do |i|
        me.add(self.deserialize_value,self.deserialize_value)
      end
      return me
    end

    def hybrid_dict(t=nil)
      len = read_7bit_encoded_int
      dlog(t,"len = #{len}")
      me = VSStubs::VSHybridDict.new()
      (1..len).each do |i|
        me.add(self.deserialize_value,self.deserialize_value)
      end
      return me
    end

    def array(t=nil)
      typeref,typeval = self.deserialize_type
      len = read_7bit_encoded_int
      dlog(t,"typeref = 0x#{typeref.to_s(16)} typeval = #{typeval} len = #{len}")
      me = VSStubs::VSArray.new(typeref,typeval)
      (1..len).each do |i|
        me.add(self.deserialize_value)
      end
      return me
    end

    def string_array(t=nil)
      len = read_7bit_encoded_int
      dlog(t,"len = #{len}")
      me = VSStubs::VSStringArray.new()
      (1..len).each do |i|
        str = self.read_string
        me.add(str)
        dlog(t,"string_array_elem: #{str}")
      end
      return me
    end

    def list(t=nil)
      len = read_7bit_encoded_int
      dlog(t,"len = #{len}")
      me = VSStubs::VSList.new()
      (1..len).each do |i|
        me.add(self.deserialize_value)
      end
      return me
    end

    def unit(t=nil)
      s1 = read_double
      s2 = read_int32
      dlog(t,"#{s1.to_s(16).rjust(16,"0")},#{s2.to_s(16).rjust(8,"0")}")
      VSStubs::VSUnit.new(s1,s2)
    end

    def indexed_string(t=nil)
      str = self.read_string
      @indexed_strings << str
      dlog(t,"idx = #{@indexed_strings.size - 1} val = #{str}")
      VSStubs::VSIndexedString.new(str)
    end

    def indexed_string_ref(t=nil)
      ref = self.read_int
      dlog(t,"ref = #{ref} val = #{@indexed_strings[ref]}")
      VSStubs::VSIndexedStringRef.new(ref)
    end

    def string(t=nil)
      str = self.read_string
      dlog(t,str)
      VSStubs::VSString.new(str)
    end

    # VSStubs::VSReadValue types
    def color(t=nil)
      val = self.read_int32
      dlog(t,val.to_s(16))
      VSStubs::VSColor.new(val)
    end

    def known_color(t=nil)
      index = self.read_7bit_encoded_int
      dlog(t,"index = #{index.to_s(16)}")
      VSStubs::VSKnownColor.new(index)
    end

    def int16(t=nil)
      val = read_short
      dlog(t,val)
      VSStubs::VSInt16.new(val)
    end

    def int32(t=nil)
      val = self.read_7bit_encoded_int
      dlog(t,val)
      VSStubs::VSInt32.new(val)
    end

    def byte(t=nil)
      val = self.read_byte
      dlog(t,val)
      VSStubs::VSByte.new(val)
    end

    def char(t=nil)
      val = self.read_byte
      dlog(t,val)
      VSStubs::VSChar.new(val)
    end

    def date_time(t=nil)
      val = self.read_double
      dlog(t,val)
      VSStubs::VSDateTime.new(val)
    end

    def double(t=nil)
      val = self.read_double
      dlog(t,val)
      VSStubs::VSDouble.new(val)
    end

    def single(t=nil)
      val = self.read_single
      dlog(t,val)
      VSStubs::VSSingle.new(val)
  end

    # VSStubs::VSValue types
    def null(t=nil);        dlog(t,nil); return VSStubs::VSValue.new(t); end
    def empty_byte(t=nil);  dlog(t,nil); return VSStubs::VSValue.new(t); end
    def zeroint32(t=nil);   dlog(t,nil); return VSStubs::VSValue.new(t); end
    def bool_true(t=nil);   dlog(t,nil); return VSStubs::VSValue.new(t); end
    def bool_false(t=nil);  dlog(t,nil); return VSStubs::VSValue.new(t); end
    def empty_color(t=nil); dlog(t,nil); return VSStubs::VSValue.new(t); end
    def empty_unit(t=nil);  dlog(t,nil); return VSStubs::VSValue.new(t); end

    # deserialize_value
    def deserialize_value
      @last_offset = self.offset
      token = self.read_byte # self.read_raw_byte
      if not (tsym = VIEWSTATE_TYPES[token])
        STDERR.puts "TOKEN: [0x#{token.to_s(16)}] at #{last_offset}"
        STDERR.puts @bufarr.slice(0..31).join("").hexdump
        raise "Invalid Type [0x#{token.to_s(16)}] at #{last_offset}" if not (tsym = VIEWSTATE_TYPES[token])
      end
      nobj = self.send(tsym,token)
      raise "Invalid Class Returned #{nobj.class}" if not VIEWSTATE_TYPES.include?(nobj.opcode)
      return nobj
    end

  end
end
