require 'helper'

module Mollie
  class Settlement
    class ChargebackTest < Test::Unit::TestCase
      def test_kind_of_chargeback
        chargeback = Mollie::Settlement::Chargeback.new({})
        assert_kind_of Mollie::Chargeback, chargeback
      end

      def test_list_chargebacks
        stub_request(:get, "https://api.mollie.nl/v1/settlements/set-id/chargebacks?count=50&offset=0")
          .to_return(:status => 200, :body => %{{"data" : [{"id":"chg-id", "settlement_id":"set-id"}]}}, :headers => {})

        chargebacks = Chargeback.all(settlement_id: "set-id")

        assert_equal "chg-id", chargebacks.first.id
        assert_equal "set-id", chargebacks.first.settlement_id
      end
    end
  end
end
