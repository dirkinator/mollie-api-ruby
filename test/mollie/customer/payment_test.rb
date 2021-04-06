require 'helper'

module Mollie
  class Customer
    class PaymentTest < Test::Unit::TestCase
      def test_kind_of_payment
        payment = Mollie::Customer::Payment.new({})
        assert_kind_of Mollie::Payment, payment
      end


      def test_list_payments
        stub_request(:get, "https://api.mollie.nl/v1/customers/cus-id/payments?count=50&offset=0")
          .to_return(:status => 200, :body => %{{"data" : [{"id":"pay-id", "customer_id":"cus-id"}]}}, :headers => {})

        payments = Payment.all(customer_id: "cus-id")

        assert_equal "pay-id", payments.first.id
        assert_equal "cus-id", payments.first.customer_id
      end
    end
  end
end
