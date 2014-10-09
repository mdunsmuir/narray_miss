# -*- coding: utf-8 -*-
=begin
= NArrayMiss Class

NArrayMiss is a additional class processing of missing value with to
((<NArray|URL:http://www.ruby-lang.org/en/raa-list.rhtml?name=NArray>))
for Ruby.

To use NArrayMiss class, you need invoking "require 'narray_miss.rb'" in your script.

== Index

* ((<Class Constants>))
* ((<Class Methods>))
* ((<Class Instance Methods>))
  * ((<NArrayMiss information>))
  * ((<Slicing Array>))
  * ((<Filling values>))
  * ((<Arithmetic operator>))
  * ((<Bitwise operator|Bitwise operator (only for byte, sint and int)>))
  * ((<Comparison>))
  * ((<Statistics>))
  * ((<Sort>))
  * ((<Transpose>))
  * ((<Changing Shapes of indices>))
  * ((<Type conversion>))
  * ((<Iteration>))
  * ((<Boolean and mask related|Boolean and mask related (only for byte, sint and int)>))
  * ((<Complex compound number|Complex compound number (only for scomplex and complex)>))
  * ((<Byte swap>))
  * ((<Mask and missing value>))
  * ((<Others>))


=end

require 'narray'


class NArrayMiss

=begin
== Class Constants
--- NArrayMiss::BYTE
     type code for 1 byte unsigned integer.
--- NArrayMiss::SINT
     type code for 2 byte signed integer.
--- NArrayMiss::INT
     type code for 4 byte signed integer.
--- NArrayMiss::SFLOAT
     type code for single precision float.
--- NArrayMiss::FLOAT
     type code for double precision float.
--- NArrayMiss::SCOMPLEX
     type code for single precision complex.
--- NArrayMiss::COMPLEX
     type code for double precision complex.
--- NArrayMiss::OBJECT
     type code for Ruby object.

go back to ((<Index>))
=end

  BYTE = NArray::BYTE
  SINT = NArray::SINT
  INT = NArray::INT
  SFLOAT = NArray::SFLOAT
  FLOAT = NArray::FLOAT
  SCOMPLEX = NArray::SCOMPLEX
  COMPLEX = NArray::COMPLEX
  OBJECT = NArray::OBJECT

  class << self
    alias :__new__ :new
    private :__new__
  end

  def initialize(array, mask)
    if array.shape!=mask.shape
      raise "array and mask must have the same shape"
    end
    @array = array
    @mask = mask
  end
  private :initialize

=begin
== Class Methods
--- NArrayMiss.new(typecode, size, ...)
     create (({NArrayMiss})) of ((|typecode|)).
     All elements are initialized with 0.
--- NArrayMiss.byte(size, ...)
     same as NArrayMiss.new(NArrayMiss::BYTE, ((|size|)), ...).
--- NArrayMiss.sint(size, ...)
     same as NArrayMiss.new(NArrayMiss::SINT, ((|size|)), ...).
--- NArrayMiss.int(size, ...)
     same as NArrayMiss.new(NArrayMiss::INT, ((|size|)), ...).
--- NArrayMiss.sfloat(size, ...)
     same as NArrayMiss.new(NArrayMiss::SFLOAT, ((|size|)), ...).
--- NArrayMiss.float(size, ...)
     same as NArrayMiss.new(NArrayMiss::FLOAT, ((|size|)), ...).
--- NArrayMiss.scomplex(size, ...)
     same as NArrayMiss.new(NArrayMiss::SCOMPLEX, ((|size|)), ...).
--- NArrayMiss.complex(size, ...)
     same as NArrayMiss.new(NArrayMiss::COMPLEX, ((|size|)), ...).
--- NArrayMiss.object(size, ...)
     same as NArrayMiss.new(NArrayMiss::OBJECT, ((|size|)), ...).
--- NArrayMiss[](value, ...)
     create (({NArrayMiss})) form [((|value|)), ...].
--- NArrayMiss.to_nam(array [,mask])
     create (({NArrayMiss})) from ((|array|)).
     ((|array|)) must be (({Numeric})) (({Array})) or (({NArray})).
--- NArrayMiss.to_nam_no_dup(array [,mask])
     convert from ((|array|)) to (({NArrayMiss})).

go back to ((<Index>))
=end

  def self.new(*arg)
    array = NArray.new(*arg)
    mask = NArray.byte(*arg[1..-1])
    __new__(array, mask)
  end
  def self.byte(*arg)
    NArrayMiss.new(BYTE,*arg)
  end
  def self.sint(*arg)
    NArrayMiss.new(SINT,*arg)
  end
  def self.int(*arg)
    NArrayMiss.new(INT,*arg)
  end
  def self.sfloat(*arg)
    NArrayMiss.new(SFLOAT,*arg)
  end
  def self.float(*arg)
    NArrayMiss.new(FLOAT,*arg)
  end
  def self.scomplex(*arg)
    NArrayMiss.new(SCOMPLEX,*arg)
  end
  def self.complex(*arg)
    NArrayMiss.new(COMPLEX,*arg)
  end
  def self.object(*arg)
    NArrayMiss.new(OBJECT,*arg)
  end
  def self.[](*arg)
    NArrayMiss.to_nam(NArray[*arg])
  end
  def self.to_nam_no_dup(*arg)
    if arg.length > 2 || arg.length==0 then
      raise("NArrayMiss.to_nar( array [,mask]] )")
    end

    array = arg[0]
    if Numeric===array then array = NArray[array] end
    if Array===array then array = NArray.to_na(array) end
    if !array.is_a?(NArray) then
      raise("argument must be Numeric, NArray or Array")
    end

    if arg.length==2 then
      mask = arg[1]
      if Numeric===mask then mask = array.ne(mask) end
      if Array===mask then
	mask = NArray.to_na(mask).ne(0)
      end
      if mask.class == FalseClass then
	mask = NArray.byte(*array.shape)
      end
      if mask.class == TrueClass then
	mask = NArray.byte(*array.shape).fill(1)
      end
      if !(NArray===mask && mask.typecode==BYTE) then
	  raise("mask must be Numeric, Array, true, false or NArray(byte)")
      end
      if mask.length!=array.length
        raise "mask.length must be same as array.length"
      end
    else
      mask = NArray.byte(*array.shape).fill(1)
    end
    __new__(array,mask)
  end
  def self.to_nam(*arg)
    if !(Numeric===arg[0]) && !(Array===arg[0]) && !arg[0].is_a?(NArray)
      raise "first argument must be Numeric, NArray or Array"
    end
    arg[0] = arg[0].dup if !(Numeric===arg[0])
    if arg.length==2 && !(Numeric===arg[1]) && arg[1].class!=TrueClass && arg[1].class!=FalseClass then
      arg[1] = arg[1].dup
    end
    NArrayMiss.to_nam_no_dup(*arg)
  end


=begin
== Class Instance Methods
=end


=begin
=== NArrayMiss information
--- NArrayMiss#dim
     return the dimension which is the number of indices.
--- NArrayMiss#rank
     same as (({NArrayMiss#dim})).
--- NArrayMiss#shape
     return the (({Array})) of sizes of each index.
--- NArrayMiss#size
     return the number of total elements.
--- NArrayMiss#total
     alias to size
--- NArrayMiss#length
     alias to size
--- NArrayMiss#rank_total
     return the number of total of the shape.
--- NArrayMiss#typecode
     return the typecode.
=end

  def dim
    @array.dim
  end
  def rank
    @array.rank
  end
  def shape
    @array.shape
  end
  def size
    @array.size
  end
  alias :total :size
  alias :length :size

  def rank_total(*arg)
    @array.rank_total(*arg)
  end

  def typecode
    @array.typecode
  end


=begin
=== Slicing Array
--- NArrayMiss#[](index)
     return the value at [((|index|))].
     ((|index|)) must be (({Integer, Range, Array, true})).
     Index order is FORTRAN type.
--- NArrayMiss#slice(index)
     same as (({NArrayMiss#[]})) but keeps the rank of original array by not elimiting dimensions whose length became equal to 1 (which (({NArrayMiss#[]})) dose).
     This is not the case with the 1-dimensional indexing and masking.
--- NArrayMiss#set_without_validation(index,value)
     replace elements at ((|index|)) by ((|value|)).
--- NArrayMiss#[]=(index, value)
     replace elements at ((|index|)) by ((|value|)) and
     make replaced elements valid.     
=end

  def [](*arg)
    if arg[0].class == NArrayMiss && arg[0].typecode == BYTE
      obj = @array[arg[0].to_na(0)]
      if Numeric===obj
        return obj
      else
        return NArrayMiss.to_nam_no_dup(obj)
      end
    else
      obj = @array[*arg]
      if Numeric===obj
        return obj
      else
        return NArrayMiss.to_nam_no_dup(obj,@mask[*arg])
      end
    end
  end
  def slice(*arg)
    NArrayMiss.to_nam_no_dup(@array.slice(*arg),@mask.slice(*arg))
  end

  def set_without_validation(*arg)
    if arg.length==1 then
      if !arg[0] then
	@mask[] = 0
      elsif arg[0].class == NArrayMiss then
	@array[] = arg[0].get_array!
	@mask[] = arg[0].get_mask!
      else
	@array[] = arg[0]
      end
    else
      if !arg[-1] then
	@mask[*arg[0..-2]] = 0
      elsif arg[-1].class == NArrayMiss then
	@array[*arg[0..-2]] = arg[-1].get_array!
	@mask[*arg[0..-2]] = arg[-1].get_mask!
      else
	@array[*arg[0..-2]] = arg[-1]
      end
    end
    return self
  end

  def []=(*arg)
    if arg.length == 2 && arg[0].class == NArrayMiss && arg[0].typecode == BYTE
      idx = arg[0].to_na(0)
      self.set_without_validation(idx,arg[-1])
      if arg[-1].class != NArrayMiss && arg[-1] then
        @mask[idx] = 1
      end
    else
      self.set_without_validation(*arg)
      if arg[-1].class != NArrayMiss && arg[-1] then
        if arg.length==1 then
          @mask=1
        else
          @mask[*arg[0..-2]] = 1
        end
      end
    end
    return self
  end


=begin
=== Filling values
--- NArrayMiss#indgen!([start[,step]])
     set values from ((|start|)) with ((|step|)) increment.
--- NArrayMiss#indgen([start[,step]])
     same as (({NArrayMiss#indgen!})) but create new object.
--- NArrayMiss#fill!(value)
     fill elements with ((|value|)).
--- NArrayMiss#fill(value)
     same as (({NArrayMiss#fill!})) but create new object.
--- NArrayMiss#random!(max)
     set random values between 0<=x<((|max|)).
--- NArrayMiss#random(max)
     same as (({NArrayMiss#random!})) but create new object.
--- NArrayMiss#randomn(max)
     set normally distributed random values with mean=0, dispersion=1 (Box-Muller)
=end

  for operator in ["indgen","fill","random","randomn"]
    eval(<<-EOL,nil,__FILE__,__LINE__+1)
    def #{operator}(*arg)
      obj = self.dup
      obj.#{operator}!(*arg)
      obj
    end
    def #{operator}!(*arg)
      @array = @array.#{operator}!(*arg)
      @mask[true] = 1
      self
    end
    EOL
  end


=begin
=== Arithmetic operator
--- NArrayMiss#-@
--- NArrayMiss#+(other)
--- NArrayMiss#-(other)
--- NArrayMiss#*(other)
--- NArrayMiss#/(other)
--- NArrayMiss#%(other)
--- NArrayMiss#**(other)
--- NArrayMiss#abs
--- NArrayMiss#add!(other)
--- NArrayMiss#sbt!(other)
--- NArrayMiss#mul!(other)
--- NArrayMiss#div!(other)
--- NArrayMiss#mod!(other)
--- NArrayMiss#mul_add(other, dim, ...)
=end

  def -@
    array = @array.dup
    array[@mask] = -@array[@mask]
    NArrayMiss.to_nam_no_dup(array, @mask.dup)
  end
  def +(arg)
    binary_operation(arg, 0){|t1, t2| t1 + t2}
  end
  def -(arg)
    binary_operation(arg, 0){|t1, t2| t1 - t2}
  end
  def *(arg)
    binary_operation(arg, 1){|t1, t2| t1 * t2}
  end
  def /(arg)
    binary_operation(arg, 1){|t1, t2| t1 / t2}
  end
  def %(arg)
    binary_operation(arg, 1){|t1, t2| t1 % t2}
  end
  def **(arg)
    binary_operation(arg, 1){|t1, t2| t1 ** t2}
  end

  def abs
    array = @array.dup
    array[@mask] = @array[@mask].abs
    NArrayMiss.to_nam_no_dup(array, @mask.dup)
  end

  def add!(arg)
    binary_operation(arg, 0){|t1, t2| t1.add!(t2)}
  end
  def sbt!(arg)
    binary_operation(arg, 0){|t1, t2| t1.sbt!(t2)}
  end
  def mul!(arg)
    binary_operation(arg, 1){|t1, t2| t1.mul!(t2)}
  end
  def div!(arg)
    binary_operation(arg, 1){|t1, t2| t1.div!(t2)}
  end
  def mod!(arg)
    binary_operation(arg, 1){|t1, t2| t1.mod!(t2)}
  end

  def mul_add(*arg)
    if arg.length==1 then
      return (self*arg[0]).sum
    else
      return (self*arg[0]).sum(*arg[1..-1])
    end
  end


=begin
=== Bitwise operator (only for byte, sint and int)
--- NArrayMiss#~@
--- NArrayMiss#&(other)
--- NArrayMiss#|(other)
--- NArrayMiss#^(other)
=end

  def ~@
    NArrayMiss.to_nam_to_dup(~@array, @mask.dup)
  end
  def &(arg)
    binary_operation(arg, 1){|t1, t2| t1 & t2}
  end
  def |(arg)
    binary_operation(arg, 0){|t1, t2| t1 | t2}
  end
  def ^(arg)
    binary_operation(arg, 1){|t1, t2| t1 ^ t2}
  end


=begin
=== Comparison
--- NArrayMiss#eq(other)
--- NArrayMiss#ne(other)
--- NArrayMiss#gt(other)
--- NArrayMiss#ge(other)
--- NArrayMiss#lt(other)
--- NArrayMiss#le(other)
--- NArrayMiss#>(other)
--- NArrayMiss#>=(other)
--- NArrayMiss#<(other)
--- NArrayMiss#<=(other)
--- NArrayMiss#and(other)
--- NArrayMiss#or(other)
--- NArrayMiss#xor(other)
--- NArrayMiss#not(other)
=end

  def eq(arg)
    binary_operation(arg, 0){|t1, t2| t1.eq t2}
  end
  def ne(arg)
    binary_operation(arg, 0){|t1, t2| t1.ne t2}
  end
  def gt(arg)
    binary_operation(arg, 0){|t1, t2| t1.gt t2}
  end
  def ge(arg)
    binary_operation(arg, 0){|t1, t2| t1.ge t2}
  end
  def lt(arg)
    binary_operation(arg, 0){|t1, t2| t1.lt t2}
  end
  def le(arg)
    binary_operation(arg, 0){|t1, t2| t1.le t2}
  end

  def and(arg)
    binary_operation(arg, 1){|t1, t2| t1.and t2}
  end
  def or(arg)
    binary_operation(arg, 0){|t1, t2| t1.or t2}
  end
  def xor(arg)
    binary_operation(arg, 1){|t1, t2| t1.xor t2}
  end

  def not
    NArrayMiss.to_nam_no_dup(@array.not, @mask.dup)
  end

  def ==(arg)
    if arg.kind_of?(NArrayMiss) then
      @mask==arg.get_mask! && @array[@mask]==arg.get_array![@mask]
    else
      false
    end
  end


=begin
=== Statistics
--- NArrayMiss#sum(dim, ... ["min_count"=>i])
     return summation of elements in specified dimensions.
     Elements at which the number of elements for summation is less than ((|i|)) is invalid.
--- NArrayMiss#accum(dim, ...)
     same as (({NArrayMiss#sum})) but not elimiting dimensions whose length became equal to 1.
--- NArrayMiss#min(dim, ...)
     return minimum in specified dimensions.
     Elements at which the number of valid elements in the dimension is less than ((|i|)) is invalid.
--- NArrayMiss#max(dim, ...)
     return maximum in specified dimensions.
     Elements at which the number of valid elements in the dimension is less than ((|i|)) is invalid.
--- NArrayMiss#median(dim, ...)
     return median in specified dimensions.
     Elements at which the number of valid elements in the dimension is less than ((|i|)) is invalid.
--- NArrayMiss#mean(dim, ...)
     return mean of elements in specified dimensions.
     Elements at which the number of elements for then mean is less than ((|i|)) is invalid.
--- NArrayMiss#stddev(dim, ...)
     return standard deviation of elements in specified dimensions.
     Elements at which the number of elements for calculation the standard deviation is less than ((|i|)) is invalid.
--- NArrayMiss#rms(dim, ...)
     return root mean square of elements in specified dimensions.
     Elements at which the number of elements for calculation the RMS is less than ((|i|)) is invalid.
--- NArrayMiss#rmsdev(dim, ...)
     return root mean square deviation of elements in specified dimensions.
     Elements at which the number of elements for calculation the RMS deviation is less than ((|i|)) is invalid.
=end

  def accum(*arg)
    if @mask.count_true == 0 then
      return nil
    else
      array = @array.dup
      array[@mask.not] = 0
      return NArrayMiss.to_nam_no_dup(array.accum(*arg),
			       @mask.to_type(NArray::INT).accum(*arg).ne(0))
    end
  end

  def sum(*dims)
    min_count = NArrayMiss.check_options(dims, 1)
    # 欠損値に 0 を入れて普通に sum する
    ary0 = @array.dup
    ary0[@mask.not] = 0
    NArrayMiss.reduction(@mask, rank, min_count, dims, false, typecode) do
      ary0.sum(*dims)
    end
  end
  def min(*dims)
    min_count = NArrayMiss.check_options(dims, 1)
    # 欠損値に最大値を入れて普通に min する
    # byte,sint,int,sfloat,float の MAX の値を入れるように変更すべき
    ary0 = @array.dup
    ary0[@mask.not] = @array.max
    NArrayMiss.reduction(@mask, rank, min_count, dims, false, typecode) do
      ary0.min(*dims)
    end
  end
  def max(*dims)
    min_count = NArrayMiss.check_options(dims, 1)
    # 欠損値に最小値を入れて普通に max する
    # byte,sint,int,sfloat,float の MIN の値を入れるように変更すべき
    ary0 = @array.dup
    ary0[@mask.not] = @array.min
    NArrayMiss.reduction(@mask, rank, min_count, dims, false, typecode) do
      ary0.max(*dims)
    end
  end

  def mean(*dims)
    min_count = NArrayMiss.check_options(dims, 1)
    # 整数型の場合は浮動小数型へ変換
    ary0 = self.integer? ? self.to_type(NArray::DFLOAT) : self
    NArrayMiss.reduction(@mask, rank, min_count, dims, true, typecode) do |count_sum, count_accum|
      ary0.sum(*dims)/count_sum
    end
  end
  def stddev(*dims)
    min_count = NArrayMiss.check_options(dims, 2)
    # 整数型の場合は浮動小数型へ変換
    ary0 = self.integer? ? self.to_type(NArray::DFLOAT) : self
    NArrayMiss.reduction(@mask, rank, min_count, dims, true, typecode) do |count_sum, count_accum|
      ary0 = ary0 - ary0.accum(*dims)/count_accum
      ary0 = ary0.abs if ary0.complex?
      ary0 = (ary0**2).sum(*dims) / (count_sum-1)
      NMMath.sqrt(ary0)
    end
  end
  def rms(*dims)
    min_count = NArrayMiss.check_options(dims, 1)
    # 整数型の場合は浮動小数型へ変換
    ary0 = self.integer? ? self.to_type(NArray::DFLOAT) : self
    NArrayMiss.reduction(@mask, rank, min_count, dims, true, typecode) do |count_sum, count_accum|
      ary0 = ary0.abs if ary0.complex?
      ary0 = (ary0**2).sum(*dims) / count_sum
      NMMath.sqrt(ary0)
    end
  end
  def rmsdev(*dims)
    min_count = NArrayMiss.check_options(dims, 1)
    # 整数型の場合は浮動小数型へ変換
    ary0 = self.integer? ? self.to_type(NArray::DFLOAT) : self
    NArrayMiss.reduction(@mask, rank, min_count, dims, true, typecode) do |count_sum, count_accum|
      ary0 = ary0 - ary0.accum(*dims)/count_accum
      ary0 = ary0.abs if ary0.complex?
      ary0 = (ary0**2).sum(*dims) / count_sum
      NMMath.sqrt(ary0)
    end
  end

  def median(*arg)
    if arg.length==0 then
      return @array[@mask].median
    else
      nshape = NArray.to_na(@array.shape)
      nshape[arg]=1
      nslice = nshape[nshape.ne(1).where]
      index = NArray.object(@mask.rank)
      index[nshape.eq(1).where] = true
      obj = NArrayMiss.new(@array.typecode,*nslice.to_a)
      total = 1
      nslice.each{|n| total *= n}
      for i in 0...total
        index[nshape.ne(1).where] = pos(i,nslice)
        mask = NArray.byte(*@array.shape).fill(0)
        mask[*index] = 1
        mask = @mask&mask
        if mask.count_true != 0 then
          obj[*pos(i,nslice)] = @array[mask].median
        end
      end
      return obj
    end
  end


=begin
=== Sort
--- NArrayMiss#sort(dim)
     sort in the 0..((|dim|)) (All dimensions if omitted)
--- NArrayMiss#sort_index(dim)
     return index of sort result.
=end

  for operator in ["sort","sort_index"]
    eval(<<-EOL,nil,__FILE__,__LINE__+1)
    def #{operator}(*arg)
      obj=NArrayMiss.new(@array.typecode,*@array.shape)
      if arg.length==0 then
	obj[@mask] = @array[@mask].#{operator}
        return obj
      else
        nshape = NArray.to_na(@array.shape)
        nshape[arg]=1
        nslice = nshape[nshape.ne(1).where]
        index = NArray.object(@mask.rank)
        index[nshape.eq(1).where] = true
        obj = NArrayMiss.new(@array.typecode,*@array.shape)
        total = 1
        nslice.each{|n| total *= n}
        for i in 0...total
          index[nshape.ne(1).where] = pos(i,nslice)
          mask = NArray.byte(*@array.shape).fill(0)
          mask[*index] = 1
          mask = @mask&mask
          if mask.count_true != 0 then
	    obj[mask] = @array[mask].#{operator}
	  end
	end
	return obj
      end
    end
    EOL
  end


=begin
=== Transpose
--- NArrayMiss#transpose(dim0, dim1, ...)
     transpose array. The 0-th dimension goes to the ((|dim0|))-th dimension of new array.
=end

  def transpose(*arg)
    obj = self.dup
    shape = arg.collect{|i| obj.shape[i]}
    obj.reshape!(*shape)
    obj.set_without_validation( @array.transpose(*arg) )
    obj.set_mask(@mask.transpose(*arg))
    obj
  end


=begin
=== Changing Shapes of indices
--- NArrayMiss#reshape!(size, ...)
     change shape of array.
--- NArrayMiss#reshape(size, ...)
     same as (({NArrayMiss#reshape!})) but create new object.
--- NArrayMiss#shape=(size, ...)
     same as (({NArrayMiss#reshape!})).
--- NArrayMiss#newdim!(dim)
     insert new dimension with size=1
--- NArrayMiss#newdim(dim)
     same as (({NArrayMiss#newdim!})) but create new object.
--- NArrayMiss#rewrank!(dim)
     same as (({NArrayMiss#newdim!})).
--- NArrayMiss#rewrank=(dim)
     same as (({NArrayMiss#newdim!})).
=end

  def reshape!(*arg)
    @array = @array.reshape!(*arg)
    @mask = @mask.reshape!(*arg)
    self
  end
  def reshape(*arg)
    obj = self.dup
    obj.reshape!(*arg)
  end
  alias :shape= :reshape!
  def newdim!(*arg)
    @array = @array.newdim!(*arg)
    @mask = @mask.newdim!(*arg)
    self
  end
  alias :rewrank! :newdim!
  alias :rewrank= :newdim!
  def newdim(*arg)
    obj = self.dup
    obj.newdim!(*arg)
  end
  alias :rewrank :newdim


=begin
=== Type conversion
--- NArrayMiss#floor
     return (({NArrayMiss})) of integer whose elements processed (({floor})).
--- NArrayMiss#ceil
     return (({NArrayMiss})) of integer whose elements processed (({ceil})).
--- NArrayMiss#round
     return (({NArrayMiss})) of integer whose elements processed (({round})).
--- NArrayMiss#to_i
     return (({NArrayMiss})) of integer whose elements processed (({to_i})).
--- NArrayMiss#to_f
     return (({NArrayMiss})) of float whose elements processed (({to_f})).
--- NArrayMiss#to_type(typecode)
     return (({NArrayMiss})) of ((|typecode|)).
--- NArrayMiss#to_a
     convert (({NArrayMiss})) to (({Array})).
--- NArrayMiss#to_na!([missing_value])
     convert (({NArrayMiss})) to (({NArray})).
     if there is argument, set missing_value for invalid elements.
--- NArrayMiss#to_na([missing_value])
     convert (({NArrayMiss})) to (({NArray})).
     if there is argument, set missing_value for invalid elements.
--- NArrayMiss#to_s
     convert (({NArrayMiss})) to (({String})) as a binary data.
--- NArrayMiss#to_string
     create (({NArrayMiss})) of object whose elements are processed (({to_s}))
=end

  def floor
    NArrayMiss.to_nam_no_dup(@array.floor, @mask.dup)
  end
  def ceil
    NArrayMiss.to_nam_no_dup(@array.ceil, @mask.dup)
  end
  def round
    NArrayMiss.to_nam_no_dup(@array.round, @mask.dup)
  end
  def to_i
    NArrayMiss.to_nam_no_dup(@array.to_i, @mask.dup)
  end
  def to_f
    NArrayMiss.to_nam_no_dup(@array.to_f, @mask.dup)
  end

  def to_type(typecode)
    NArrayMiss.to_nam_no_dup(@array.to_type(typecode), @mask.dup)
  end
  def to_a
    @array.to_a
  end
  def to_na!(*arg)
    if arg.length==0
      return @array
    elsif arg.length==1 then
      self.set_missing_value!(arg[0])
      return @array
    else
      raise(ArgumentError, "Usage: NArray#to_na([missing_value])")
    end
  end
  def to_na(*arg)
    return self.dup.to_na!(*arg)
  end
  def to_s
    @array.to_s
  end
  def to_string
    obj = NArrayMiss.obj(*@array.shape)
    obj.set_without_validation( @array.to_string )
    obh.set_mask(@mask)
    obj
  end


=begin
=== Iteration
--- NArrayMiss#each{|x| ...}
--- NArrayMiss#each_valid{|x| ...}
--- NArrayMiss#each_valid_with_index{|x,i| ...}
--- NArrayMiss#collect{|x| ...}
--- NArrayMiss#collect!{|x| ...}
=end

  def each
    for i in 0..self.total-1
      yield(@array[i])
    end
  end
  def each_valid
    for i in 0..self.total-1
      yield(@array[i]) if @mask[i]
    end
  end
  def each_valid_with_index
    for i in 0..self.total-1
      yield(@array[i],i) if @mask[i]
    end
  end
  def collect!
    for i in 0..self.total-1
      self[i] = yield(self[i])
    end
    self
  end
  def collect(&blk)
    self.dup.collect!(&blk)
  end


=begin
=== Boolean and mask related (only for byte, sint and int)
--- NArrayMiss#count_false
     return the number of elements whose value==0 and valid.
--- NArrayMiss#count_true
     return the number of elements whose value!=0 and valid.
--- NArrayMiss#mask(mask)
     return (({NArrayMiss#get_mask!&((|mask|))})).
--- NArrayMiss#all?
     return true if all the valid elements are not 0, else false.
--- NArrayMiss#any?
     return true if any valid element is not 0, else false.
--- NArrayMiss#none?
     return true if none of the valid elements is not 0, else false.
--- NArrayMiss#where
     return (({NArray})) of indices where valid elements are not 0.
--- NArrayMiss#where2
     return (({Array})) including two (({NArray}))s of indices,
     where valid elements are not 0, and 0, respectively.
=end

  def count_false
    if @array.typecode==BYTE then
      return @array.count_false-@mask.count_false
    else
      raise("cannot count_true NArrayMiss except BYTE type")
    end
  end
  def count_true
    if @array.typecode==BYTE then
      return (@array&@mask).count_true
    else
      raise("cannot count_true NArrayMiss except BYTE type")
    end
  end
  def mask(arg)
    obj = self.dup
    if arg.class==NArrayMiss then
      arg = arg.get_array!&arg.get_mask!
    end
    obj.set_mask(@mask&arg)
  end

  def all?
    @array[@mask].all?
  end
  def any?
    @array[@mask].any?
  end
  def none?
    @array[@mask].none?
  end

  def where
    (@array&@mask).where
  end
  def where2
    self.where-@mask.where
  end




=begin
=== Complex compound number (only for scomplex and complex)
--- NArrayMiss#real
--- NArrayMiss#imag
--- NArrayMiss#conj
--- NArrayMiss#angle
--- NArrayMiss#imag=(other)
--- NArrayMiss#im
=end

  def real
    NArrayMiss.to_nam_no_dup(@array.real,@mask)
  end
  def imag
    NArrayMiss.to_nam_no_dup(@array.imag,@mask)
  end
  def conj
    NArrayMiss.to_nam_no_dup(@array.conj,@mask)
  end
  def angle
    NArrayMiss.to_nam_no_dup(@array.angle,@mask)
  end
  def imag=(arg)
    @array.image=(arg)
    self
  end
  def im
    NArrayMiss.to_nam_no_dup(@array.im,@mask)
  end


=begin
=== Byte swap
--- NArrayMiss#swap_byte
     swap byte order.
--- NArrayMiss#hton
     convert to network byte order.
--- NArrayMiss#ntoh
     convert from network byte order.
--- NArrayMiss#htov
     convert to VAX byte order.
--- NArrayMiss#vtoh
     convert from VAX byte order.
=end

  def swap_byte
    obj = self.dup
    obj.set_without_validation(@array.swap_byte)
    obj
  end
  def hton
    NArrayMiss.to_nam(@array.hton,@mask.hton)
  end
  alias :ntoh :hton
  def htov
    NArrayMiss.to_nam(@array.htov,@mask.htov)
  end
  alias :vtoh :htov


=begin
=== Mask and missing value
--- NArrayMiss#set_valid(index)
     validate element at ((|index|)).
     ((|index|)) must be (({Integer, Range, Array, or ture})).
--- NArrayMiss#validation(index)
     alias to set_valid
--- NArrayMiss#set_invalid(index)
     invaliadate element at ((|index|)).
     ((|index|)) must be (({Integer, Range, Array, or ture})).
--- NArrayMiss#invalidation(index)
     alias to set_invalid
--- NArrayMiss#all_valid
     set all elements valid
--- NArrayMiss#all_invalid
     set all elements invalid
--- NArrayMiss#set_mask(mask)
     masking by ((|mask|))
--- NArrayMiss#set_missing_value(value)
     replace invalid elements by ((|value|)).
--- NArrayMiss#get_mask!
     return (({NArray})) of byte as mask.
--- NArrayMiss#get_mask
     return (({NArray})) of byte as mask.
--- NArrayMiss#get_array!
     return (({NArray})) as data.
--- NArrayMiss#get_array
     return (({NArray})) as data.
--- NArrayMiss#valid?(index)
     return (({Array})) whose elements are true or false, 
     or (({True}))/(({False})) corresponding to validity of the specified element(s) by the ((|index|))
--- NArrayMiss#all_valid?
     return true if all elements are valid, else false.
--- NArrayMiss#none_valid?
     return true if all elements are invalid, else false.
--- NArrayMiss#all_invalid?
     alias to none_valid?
--- NArrayMiss#any_valid?
     return true if any elements are valid, else false.
     
--- NArrayMiss#count_valid
     return the number of valid elements.
--- NArrayMiss#count_invalid
     return the number of invalid elements.
=end

  def set_valid(*pos)
    @mask[*pos] = 1
    self
  end
  alias validation set_valid
  def set_invalid(*pos)
    @mask[*pos] = 0
    self
  end
  alias invalidation set_invalid
  def all_valid
    @mask[true]=1
    self
  end
  def all_invalid
    @mask[true]=0
    self
  end
  def set_mask(mask)
    if mask.class == Array then
      tmp = NArray.byte(*@mask.shape)
      tmp[true] = mask
      mask = tmp
    end
    if mask.class == NArrayMiss then
      mask = mask.to_na(0)
    end
    if mask.class == NArray then
      if mask.typecode != BYTE then
	raise("mask must be NArrayMiss.byte, NArray.byte or Array")
      end
      if @array.shape != mask.shape then
	raise("mask.shape must be same as array")
      end
      @mask = mask.dup
      return self
    else
      raise("mask must be NArray.byte or Array")
    end
  end

  def set_missing_value!(val)
    @array[@mask.not] = val
    self
  end
  def set_missing_value(val)
    obj = self.dup
    obj.set_missing_value!(val)
  end

  def get_mask!
    @mask
  end
  def get_mask
    @mask.dup
  end
  def get_array!
    @array
  end
  def get_array
    @array.dup
  end

  def valid?(*arg)
    if arg.any?
      # For the subset specified by the argument(s) (in the same way as for []).
      # Returns true or false if a single value is specified.
      # Otherwise, returns an Array of true of false
      mask = @mask[*arg]
      if mask.is_a?(Numeric)
        return mask == 1  # true if mask (==1); false if not
      end
    else
      # no argument
      mask = @mask
    end
    ary = mask.to_a
    ary.flatten!
    ary.map!{|i| i==1}  # true if element == 1; false if not
    return ary
  end
  def all_valid?
    @mask.all?
  end
  def none_valid?
    @mask.none?
  end
  alias :all_invalid? :none_valid?
  def any_valid?
    @mask.any?
  end

  def count_valid(*arg)
    if arg.length==0 then
      return @mask.count_true
    else
      return @mask.to_type(NArray::INT).sum(*arg)
    end    
  end
  def count_invalid(*arg)
    if arg.length==0 then
      return @mask.count_false
    else
      return NArray.int(*@mask.shape).fill(1).sum(*arg)-
	     @mask.to_type(NArray::INT).sum(*arg)
    end
  end


=begin
=== Others
--- NArrayMiss#integer?
     return true if (({NArrayMiss})) is byte, sint or int, else false.
--- NArrayMiss#complex?
     return true if (({NArrayMiss})) is scomplex or complex, else false.
--- NArrayMiss#dup
--- NArrayMiss#coerce(object)
--- NArrayMiss#inspect

go back to ((<Index>))
=end

  def integer?
    @array.integer?
  end
  def complex?
    @array.complex?
  end


  def dup
    NArrayMiss.to_nam(@array,@mask)
  end

  alias __clone__ clone
  def clone
    obj = __clone__
    obj.set_array(@array.clone)
    obj.set_mask(@mask.clone)
    return obj
  end

  def coerce(x)
    if Numeric===x then
      return [NArrayMiss.new(NArray[x].typecode,*self.shape).fill(x),self]
    elsif x.class==Array || x.class==NArray then
      return [NArrayMiss.to_nam(x), self]
    else
      raise("donnot know how to cange #{x.class} to NArrayMiss")
    end
  end


  def inspect
#    "array -> " + @array.inspect + "\nmask  -> " + @mask.inspect
    count_line = 0
    max_line = 10
    max_col = 80
    sep = ", "
    const = Hash.new
    NArray.constants.each{|c| const[NArray.const_get(c)] = c}
    str_ret = "NArrayMiss."+const[typecode].to_s.downcase+"("+shape.join(",")+"):"
    if rank == 0 then
      str_ret << " []"
      return str_ret
    else
       str_ret << "\n"
    end
    str = ""
    index = Array.new(rank,0)
    index[0] = true
    i = 1
    (rank-1).times{ str_ret << "[ " }
    while(true)
      i.times{ str_ret << "[ " }

      str = @array[*index].inspect
      ary = str[str.index("[")+1..str.index("]")-1].strip.split(/\s*,\s*/)
      miss = @mask[*index].where2[1]
      miss = miss[miss<ary.length].to_a
      if ary[-1]=="..." && miss[-1]==ary.length-1 then miss.pop end
      for j in miss
	ary[j] = "-"
      end
      while ( rank*4+ary.join(", ").length > max_col )
        ary.pop
        ary[-1] = "..."
      end
      str_ret << ary.join(", ")
      i = 1
      while (i<rank)
	if index[i]<shape[i]-1 then
	  str_ret << " ]" << sep << "\n"
	  count_line += 1
	  index[i] += 1
	  break
	else
	  str_ret << " ]"
	  index[i] = 0
	  i += 1
	end
      end

      if i>=rank then
	str_ret << " ]"
	return str_ret
      elsif count_line>=max_line then
	str_ret << " ..."
	return str_ret
      end

      (rank-i).times{ str_ret << "  " }
    end
    return str_ret
  end


  def _dump(limit)
    Marshal::dump([@array._dump(nil),@mask._dump(nil)])
  end
  def self._load(o)
    ary, mask = Marshal::load(o)
    ary = NArray._load(ary)
    mask = NArray._load(mask)
    NArrayMiss.to_nam_no_dup(ary,mask)
  end




#  private
  private
  def pos(n,shape)
    rank = shape.length
    result = NArray.int(rank)
    m=n
    for i in 0..rank-2
      j = rank-1-i
      result[j] = m/shape[j-1]
      m = m%shape[j-1]
    end
    result[0] = m
    result
  end
  def binary_operation(arg, dummy)
    # arg: 第2項目のオブジェクト
    # dummy: 演算を行っても結果に影響を与えない特別な値。(欠損部分に代入する)
    flag=true
    case arg
    when Numeric
      term1 = @array
      term2 = arg
      mask = @mask
    when Array, NArray
      term1 = @array.dup
      term1[@mask.not] = dummy # 欠損部分に dummy を代入
      term2 = arg.kind_of?(NArray) ? arg : NArray.to_na(arg) # Array -> NArray
      mask = NArray.byte(*term2.shape).fill(1) # 2項目は欠損無し
      mask = @mask & mask
    when NArrayMiss
      term1 = @array.dup
      term1[@mask.not] = dummy
      mask = arg.get_mask!
      term2 = arg.get_array
      term2[mask.not] = dummy
      mask = @mask & mask
    else
      term1, term2 = arg.coerce(self)
      # 演算を arg のクラスに任せるため、yield の結果をそのまま返す
      flag = false
    end
    result = yield(term1, term2)
    result = NArrayMiss.to_nam_no_dup(result, mask) if flag
    result
  end


  def self.reduction(mask, rank, min_count, dims, flag, typecode)
    # flag: リダクションを行う次元方向の有効な値の個数で、割り算を行うかどうかのフラグ
    count_sum = mask.to_type(NArray::LINT).sum(*dims)
    # 返り値が配列か、スカラーかによって分岐
    if count_sum.kind_of?(NArray)
      mask = count_sum.ge(min_count)
      # すべての要素が欠損値にならないかチェック
      if mask.any?
        count_accum = NArray.ref(count_sum)
        dims.collect{|d|d<0 ? d+rank : d}.sort.each do |d|
          count_accum.newdim!(d)
        end
        # 割り算を行う場合は、先に count_sum を NArrayMiss 化
        #   yield の戻り値は NArrayMiss
        # 割り算を行わない場合は、後で NArrayMiss 化
        #   yield の戻り値は NArray
        count_sum = NArrayMiss.to_nam_no_dup(count_sum,mask) if flag
        ary = yield(count_sum, count_accum)
        ary = NArrayMiss.to_nam_no_dup(ary, mask) unless flag
      else
        # すべての要素が欠損値の NArrayMiss を返す
        na = NArray.new(typecode, *mask.shape)
        ary = NArrayMiss.to_nam_no_dup(na, false)
      end
    else
      # 有効な要素数があるかチェック
      if count_sum >= min_count
        count_accum = NArray.int(*([1]*mask.rank)).fill!(count_sum)
        ary = yield(count_sum, count_accum)
      else
        # 有効な要素数が足りない場合は nil を返す
        return nil
      end
    end
    return ary
  end

    
  # 引数にオプション (Hash) が指定されているかチェックし、
  # されている場合は、オプションを取得し戻り値として返す。
  # 現時点では、オプションは "min_count" のみ
  def self.check_options(arg, default_mincount)
    min_count = default_mincount
    options = %w(min_count)
    if arg.length!=0 && arg[-1].kind_of?(Hash)
      option = arg.pop
      option.each_key{|key|
	if !options.index(key) then
	  raise(ArgumentError,key+" option is not exist")
	end
      }
      min_count = option["min_count"] || default_mincount
      min_count = min_count.to_i
      if min_count < default_mincount
        raise(ArgumentError, "min_count must be >= #{default_mincount}")
      end
    end
    return min_count
  end
end



module NMMath


  func1 =  ["sqrt","exp","log","log10","log2",
            "sin","cos","tan","sinh","cosh","tanh",
            "asin","acos","atan","asinh","acosh","atanh",
            "csc", "sec", "cot", "csch", "sech", "coth",
            "acsc", "asec", "acot", "acsch", "asech", "acoth",
           ]
  func2 = ["atan2"]

  for operator in func1
    eval <<-EOL,nil,__FILE__,__LINE__+1
    def #{operator}(x)
      case x
      when Numeric, Array, NArray
	NMath::#{operator}(x)
      when NArrayMiss
	obj = NArrayMiss.new(x.typecode,*x.shape)
	mask = x.get_mask!
	obj[mask] = NMath::#{operator}(x.get_array![mask])
	obj[mask.not] = x[mask.not]
	obj.set_mask(mask)
        obj
      else
        raise ArgumentError, "argument is invalid class: \#{x.class}"
      end
    end
    module_function :#{operator}
    EOL
  end

  for operator in func2
    eval <<-EOL,nil,__FILE__,__LINE__+1
    def #{operator}(x,y)
      obj = nil
      case x
      when Numeric, Array, NArray
	mask1 = nil
      when NArrayMiss
	obj = NArrayMiss.new(x.typecode,*x.shape)
	mask1 = x.get_mask!
      else
        raise ArgumentError, "argument is invalid class"
      end
      case y
      when Numeric, Array, NArray
	mask2 = nil
      when NArrayMiss
	obj ||= NArrayMiss.new(y.typecode,*y.shape)
	mask2 = y.get_mask!
      else
        raise ArgumentError, "argument is invalid class"
      end
      if mask2.nil? then
	if mask1.nil? then
	  return NMath::#{operator}(x,y)
	else
	  obj[mask1] = NMath::#{operator}(x.get_array![mask1],y)
	  obj[mask1.not] = x[mask1.not]
	  obj.set_mask(mask1)
	  return obj
	end
      else
        if mask1.nil? then
          obj[mask2] = NMath::#{operator}(x,y.get_array![mask2])
          obj[mask2.not] = y[mask2.not]
          obj.set_mask(mask2)
          return obj
        else
          obj[mask1&mask2] = NMath::#{operator}(x.get_array![mask1],y.get_array![mask2])
          obj[(mask1&mask2).not] = x[(mask1&mask2).not]
          return obj
        end
      end
    end
    module_function :#{operator}
    EOL
  end

  methods = Hash.new
  methods["covariance"] = {:min_count => 2, :post => <<-EOL}
    mean0 = ary0.accum(*dims) / count_accum
    mean1 = ary1.accum(*dims) / count_accum
    ary = ((ary0-mean0)*(ary1-mean1)).sum(*dims)
    ary / (count_sum-1)
  EOL
  methods.each do |name, hash|
    eval <<-EOL,nil,__FILE__,__LINE__+1
      def #{name}(ary0,ary1,*dims)
        min_count = NArrayMiss.check_options(dims, 2)
        case ary0
        when Numeric, Array, NArray
          mask0 = nil
        when NArrayMiss
          mask0 = ary0.get_mask!
        else
          raise ArgumentError, "argument is invalid class"
        end
        case ary1
        when Numeric, Array, NArray
          mask1 = nil
        when NArrayMiss
          mask1 = ary1.get_mask!
        else
          raise ArgumentError, "argument is invalid class"
        end
        if mask1.nil? then
          if mask0.nil? then
            return NMath.#{name}(ary0, ary1, *dims)
          else
            ary1 = NArrayMiss.to_nam_no_dup(ary1, true)
          end
        else
          if mask0.nil?
            ary0 = NArrayMiss.to_nam_no_dup(ary0, true)
          end
        end
        if ary1.shape != ary1.shape
          raise "shape is different"
        end
        ary0 = ary0.to_type(NArray::DFLOAT)
        ary1 = ary1.to_type(NArray::DFLOAT)
        mask = mask0.nil? ? mask1 : mask1.nil? ? mask0 : mask0&mask1
        ary0.set_mask(mask)
        ary1.set_mask(mask)
        NArrayMiss.reduction(mask, ary0.rank, min_count, dims, true, NArray::DFLOAT) do |count_sum, count_accum|
          #{hash[:post]}
        end
      end
      module_function :#{name}
    EOL
  end

  for operator in func1+func2+["covariance"]
    eval <<-EOL,nil,__FILE__,__LINE__+1
    def #{operator}(*x)
      x = [self]+x if NArrayMiss===self
      NMMath.#{operator}(*x)
    end
    EOL
  end

end

class NArrayMiss
  include NMMath
end
