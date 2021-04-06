require 'helper'

module Mollie
  class MethodTest < Test::Unit::TestCase
    def test_setting_attributes
      attributes = {
        id:          "creditcard",
        description: "Credit card",
        amount:      {
          'minimum' => "0.31",
          'maximum' => "10000.00"
        },
        image:       {
          'normal' => "https://www.mollie.com/images/payscreen/methods/creditcard.png",
          'bigger' => "https://www.mollie.com/images/payscreen/methods/creditcard@2x.png"
        }
      }

      method = Method.new(attributes)

      assert_equal "creditcard", method.id
      assert_equal "Credit card", method.description
      assert_equal BigDecimal("0.31"), method.minimum_amount
      assert_equal BigDecimal("10000.0"), method.maximum_amount
      assert_equal "https://www.mollie.com/images/payscreen/methods/creditcard.png", method.normal_image
      assert_equal "https://www.mollie.com/images/payscreen/methods/creditcard@2x.png", method.bigger_image
    end
  end
end
