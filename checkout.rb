require "test/unit"

# http://codekata.com/kata/kata09-back-to-the-checkout/

#  Rules:
#  Item   Unit      Special
#         Price     Price
# --------------------------
#   A     50       3 for 130
#   B     30       2 for 45
#   C     20
#   D     15

class CheckOut
  
  attr_accessor :total

  def initialize(rules)
    @@rules = rules
    @individual_items = Hash.new(0)
  end

  def scan(item)
    @individual_items[item] += 1
  end

  def total
    # return the total price using only the hash
   sum = 0
   
    @individual_items.each do |key, value|
      array = @@rules[key].sort.reverse
      item =  array.select{ |a| value>= a[0].to_i  }.max #calculate the maxiumum unit size
      sum += value/item[0].to_i * item[1].to_i 
      remaining =  value%item[0].to_i
      if(remaining > 0)
        remainder =  array.select{ |a| remaining >= a[0].to_i  }.max
        sum += remaining/remainder[0].to_i * remainder[1]
      end
    end
    return sum
  end
end






class TestPrice < Test::Unit::TestCase
  RULES = { "A" => {"1" => 50, "3" => "130"},  
            "B" => {"1" => 30, "2" => "45"}, 
            "C" => {"1" => 20}, 
            "D" => {"1" => 15}
          }
          #reverse it here.
  def price(goods)
    
    
    co = CheckOut.new(RULES)

    goods.split(//).each { |item| co.scan(item) }
    co.total
  end

  def test_totals
    assert_equal(  0, price(""))
    assert_equal( 50, price("A"))
    assert_equal( 80, price("AB"))
    assert_equal(115, price("CDBA"))

    assert_equal(100, price("AA"))
    assert_equal(130, price("AAA"))
    assert_equal(180, price("AAAA"))
    assert_equal(230, price("AAAAA"))
    assert_equal(260, price("AAAAAA"))

    assert_equal(160, price("AAAB"))
    assert_equal(175, price("AAABB"))
    assert_equal(190, price("AAABBD"))
    assert_equal(190, price("DABABA"))
  end

  def test_incremental
    co = CheckOut.new(RULES)
    assert_equal(  0, co.total)
    co.scan("A");  assert_equal( 50, co.total)
    co.scan("B");  assert_equal( 80, co.total)
    co.scan("A");  assert_equal(130, co.total)
    co.scan("A");  assert_equal(160, co.total)
    co.scan("B");  assert_equal(175, co.total)
  end
end