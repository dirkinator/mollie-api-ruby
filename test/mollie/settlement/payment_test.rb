require 'helper'

module Mollie
  class Settlement
    class PaymentTest < Test::Unit::TestCase
      def test_kind_of_payment
        payment = Mollie::Settlement::Payment.new({})
        assert_kind_of Mollie::Payment, payment
      end

      def test_list_payments
        stub_request(:get, "https://api.mollie.nl/v1/settlements/set-id/payments?count=50&offset=0")
          .to_return(:status => 200, :body => %{{"data" : [{"id":"pay-id", "settlement_id":"set-id"}]}}, :headers => {})

        payments = Payment.all(settlement_id: "set-id")

        assert_equal "pay-id", payments.first.id
        assert_equal "set-id", payments.first.settlement_id
      end
    end
  end
end
