$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require "narray_miss"
require "test/unit"

class NArrayMissTest < Test::Unit::TestCase

  def assert_equal(expected, actual, message=nil)
    if expected.kind_of?(Float)
      assert((expected-actual)/expected < 1.0e-10, message || <<EOF)
<#{expected}> expected but was
<#{actual}>.
EOF
    else
      super(expected, actual, message)
    end
  end

  def setup
    @n = 4
    @m = 3
    @mask = NArray.byte(@n,@n)
    @mask[true,0] = 1
    @mask[1..-1,1] = 1
    @mask[-1,2] = 1
    @float = NArrayMiss.float(@n,@n).indgen; @float.set_mask(@mask)
    @int = NArrayMiss.int(@n,@n).indgen; @int.set_mask(@mask)
    @float3d = NArrayMiss.float(@n,@m,@n).indgen
=begin
     @float #=>
NArrayMiss.dfloat(4,4):
 [ [ 0.0, 1.0, 2.0,  3.0 ], 
   [  - , 5.0, 6.0,  7.0 ], 
   [  - ,  - ,  - , 11.0 ], 
   [  - ,  - ,  - ,   -  ]
 ]
=end
  end

  def test_valid?
    assert_equal([true,true,true,true,false,true,true,true,false,false,false,true,false,false,false,false], @int.valid?)
    assert_equal([true,true,true,true], @int.valid?(true,0))
    assert_equal([false,true,true,true], @int.valid?(true,1))
    assert_equal([true,true,true,false], @int.valid?(3,true))
    assert_equal(true, @int.valid?[7])
    assert_equal(false, @int.valid?[10])
  end

  def test_add
    ary = NArrayMiss.float(@n,@n)
    ary[true,0] = [0, 2, 4, 6]
    ary[1..-1,1] = [10, 12, 14]
    ary[-1,2] = 22
    a1 = @float.dup
    a2 = @int.dup
    assert_equal(ary, a1 + a2)
    assert_equal(@float, a1)
    assert_equal(@int, a2)
  end

  def test_sum
    assert_equal(35.0, @float.sum)
    assert_equal(35, @int.sum)

    assert_equal(NArrayMiss.to_nam([6.0,18.0,11.0,0.0],[1,1,1,0]), @float.sum(0))
    assert_equal(NArrayMiss.to_nam([6,18,11,0],[1,1,1,0]), @int.sum(0))

    assert_equal(NArrayMiss.to_nam([6.0,18.0,0.0,0.0],[1,1,0,0]), @float.sum(0, "min_count"=>2))

    assert_equal(NArrayMiss.to_nam([0.0,6.0,8.0,21.0],[1,1,1,1]), @float.sum(1))
    assert_equal(NArrayMiss.to_nam([0,6,8,21],[1,1,1,1]), @int.sum(1))

    assert_equal(NArrayMiss.to_nam([0.0,6.0,8.0,21.0],[0,1,1,1]), @float.sum(1, "min_count"=>2))
  end

  def test_mean
    assert_equal(4.375, @float.mean)
    assert_equal(4.375, @int.mean)

    ary = [1.5, 6, 11, 0]
    assert_equal(NArrayMiss.to_nam(ary,[1,1,1,0]), @float.mean(0))
    assert_equal(NArrayMiss.to_nam(ary,[1,0,0,0]), @float.mean(0, "min_count"=>4))

    ary = [0.0, 3, 4, NArray[3,7,11].mean]
    assert_equal(NArrayMiss.to_nam(ary,[1,1,1,1]), @float.mean(1))
    assert_equal(NArrayMiss.to_nam(ary,[0,0,0,1]), @float.mean(1, "min_count"=>3))
  end

  def test_stddev
    assert_equal(3.62284418654736, @float.stddev)
    assert_equal(3.62284418654736, @int.stddev)

    ary = [NArray[0,1,2,3].stddev, NArray[5,6,7].stddev, 0, 0]
    assert_equal(NArrayMiss.to_nam(ary,[1,1,0,0]), @float.stddev(0))
    assert_equal(NArrayMiss.to_nam(ary,[1,0,0,0]), @float.stddev(0, "min_count"=>4))

    ary = [0, NArray[1,5].stddev, NArray[2,6].stddev, NArray[3,7,11].stddev]
    assert_equal(NArrayMiss.to_nam(ary,[0,1,1,1]), @float.stddev(1))
    assert_equal(NArrayMiss.to_nam(ary,[0,0,0,1]), @float.stddev(1, "min_count"=>3))

    assert_equal(NArrayMiss.to_nam(NArray.float(@n,@m,@n).indgen.stddev(-1)), @float3d.stddev(-1))
  end

  def test_rms
    assert_equal(5.53398590529466, @float.rms)
    assert_equal(5.53398590529466, @int.rms)

    ary = [NArray[0,1,2,3].rms, NArray[5,6,7].rms, 11, 0]
    assert_equal(NArrayMiss.to_nam(ary,[1,1,1,0]), @float.rms(0))
    assert_equal(NArrayMiss.to_nam(ary,[1,0,0,0]), @float.rms(0, "min_count"=>4))

    ary = [0.0, NArray[1,5].rms, NArray[2,6].rms, NArray[3,7,11].rms]
    assert_equal(NArrayMiss.to_nam(ary,[1,1,1,1]), @float.rms(1))
    assert_equal(NArrayMiss.to_nam(ary,[0,0,0,1]), @float.rms(1, "min_count"=>3))
  end

  def test_rmsdev
    assert_equal(3.38886042793149, @float.rms)
    assert_equal(3.38886042793149, @int.rmsdev)

    ary = [NArray[0,1,2,3].rmsdev, NArray[5,6,7].rmsdev, 0, 0]
    assert_equal(NArrayMiss.to_nam(ary,[1,1,1,0]), @float.rmsdev(0))
    assert_equal(NArrayMiss.to_nam(ary,[1,0,0,0]), @float.rmsdev(0, "min_count"=>4))

    ary = [0.0, NArray[1,5].rmsdev, NArray[2,6].rmsdev, NArray[3,7,11].rmsdev]
    assert_equal(NArrayMiss.to_nam(ary,[1,1,1,1]), @float.rmsdev(1))
    assert_equal(NArrayMiss.to_nam(ary,[0,0,0,1]), @float.rmsdev(1, "min_count"=>3))
  end

  def test_covariance
    x = @float
    ary = NArray.float(@n,@n).indgen(0,2)
    mask = NArray.byte(@n,@n).fill(1)
    mask[-1,0] = 0
    y = NArrayMiss.to_nam(ary,mask)
=begin
y #=>
NArrayMiss.float(4,4)
[ [  0.0,  2.0,  4.0,   -  ], 
  [  8.0, 10.0, 12.0, 14.0 ], 
  [ 16.0, 18.0, 20.0, 22.0 ], 
  [ 24.0, 26.0, 28.0, 30.0 ]
]
NArrayMiss.dfloat(4,4):
 [ [ 0.0, 1.0, 2.0,  3.0 ], 
   [  - , 5.0, 6.0,  7.0 ], 
   [  - ,  - ,  - , 11.0 ], 
   [  - ,  - ,  - ,   -  ]
 ]
=end
    assert_equal(NMath.covariance(NArray[0,1,2,4,5,7,11],NArray[0,2,4,10,12,14,22]), NMMath.covariance(x,y))

    ary = Array.new(@n)
    ary[0] = 0.0
    ary[1] = NMath.covariance(NArray[1,5],NArray[2,10])
    ary[2] = NMath.covariance(NArray[2,6],NArray[4,12])
    ary[3] = NMath.covariance(NArray[7,11],NArray[14,22])
    assert_equal(NArrayMiss.to_nam(ary,[0,1,1,1]), NMMath.covariance(x,y,1))
    assert_equal(NArrayMiss.to_nam(ary,[0,0,0,0]), NMMath.covariance(x,y,1,"min_count"=>3))
  end
end
