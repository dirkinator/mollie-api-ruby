require 'helper'

module Mollie
  class TestObject < Base
    attr_accessor :id, :amount, :my_field

    class NestedObject < Base
      attr_accessor :id, :testobject_id, :amount
    end
  end

  class BaseTest < Test::Unit::TestCase
    def test_resource_name
      assert_equal "testobjects", TestObject.resource_name
    end

    def test_nested_resource_name
      assert_equal "testobjects/object-id/nestedobjects", TestObject::NestedObject.resource_name("object-id")
    end

    def test_setting_attributes
      attributes = { my_field: "my value", extra_field: "extra" }
      object     = TestObject.new(attributes)

      assert_equal "my value", object.my_field
      assert_equal attributes, object.attributes
    end

    def test_get
      stub_request(:get, "https://api.mollie.nl/v1/testobjects/my-id")
        .to_return(:status => 200, :body => %{{"id":"my-id"}}, :headers => {})

      resource = TestObject.get("my-id")

      assert_equal "my-id", resource.id
    end

    def test_nested_get
      stub_request(:get, "https://api.mollie.nl/v1/testobjects/object-id/nestedobjects/my-id")
        .to_return(:status => 200, :body => %{{"id":"my-id", "testobject_id":"object-id"}}, :headers => {})

      resource = TestObject::NestedObject.get("my-id", testobject_id: 'object-id')

      assert_equal "my-id", resource.id
      assert_equal "object-id", resource.testobject_id
    end

    def test_create
      stub_request(:post, "https://api.mollie.nl/v1/testobjects")
        .with(body: %{{"amount":1.95}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "amount":1.00}}, :headers => {})

      resource = TestObject.create(amount: 1.95)

      assert_equal "my-id", resource.id
      assert_equal BigDecimal("1.00"), resource.amount
    end

    def test_nested_create
      stub_request(:post, "https://api.mollie.nl/v1/testobjects/object-id/nestedobjects")
        .with(body: %{{"amount":1.95}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "testobject_id":"object-id", "amount":1.00}}, :headers => {})

      resource = TestObject::NestedObject.create(amount: 1.95, testobject_id: "object-id")

      assert_equal "my-id", resource.id
      assert_equal "object-id", resource.testobject_id
      assert_equal BigDecimal("1.00"), resource.amount
    end

    def test_update
      stub_request(:post, "https://api.mollie.nl/v1/testobjects/my-id")
        .with(body: %{{"amount":1.95}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "amount":1.00}}, :headers => {})

      resource = TestObject.update("my-id", amount: 1.95)

      assert_equal "my-id", resource.id
      assert_equal BigDecimal("1.00"), resource.amount
    end

    def test_update_instance
      stub_request(:post, "https://api.mollie.nl/v1/testobjects/my-id")
        .with(body: %{{"amount":1.95}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "amount":1.00}}, :headers => {})

      resource = TestObject.new(id: "my-id")
      resource.update(amount: 1.95)

      assert_equal "my-id", resource.id
      assert_equal BigDecimal("1.00"), resource.amount
    end

    def test_nested_update
      stub_request(:post, "https://api.mollie.nl/v1/testobjects/object-id/nestedobjects/my-id")
        .with(body: %{{"amount":1.95}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "testobject_id":"object-id", "amount":1.00}}, :headers => {})

      resource = TestObject::NestedObject.update("my-id", amount: 1.95, testobject_id: "object-id")

      assert_equal "my-id", resource.id
      assert_equal "object-id", resource.testobject_id
      assert_equal BigDecimal("1.00"), resource.amount
    end

    def test_nested_update_instance
      stub_request(:post, "https://api.mollie.nl/v1/testobjects/object-id/nestedobjects/my-id")
        .with(body: %{{"amount":1.95}})
        .to_return(:status => 201, :body => %{{"id":"my-id", "testobject_id":"object-id", "amount":1.00}}, :headers => {})

      resource = TestObject::NestedObject.new(id: "my-id", testobject_id: "object-id")
      resource.update(amount: 1.95)

      assert_equal "my-id", resource.id
      assert_equal "object-id", resource.testobject_id
      assert_equal BigDecimal("1.00"), resource.amount
    end

    def test_delete
      stub_request(:delete, "https://api.mollie.nl/v1/testobjects/my-id")
        .to_return(:status => 204, :headers => {})

      resource = TestObject.delete("my-id")

      assert_equal nil, resource
    end

    def test_delete_instance
      stub_request(:delete, "https://api.mollie.nl/v1/testobjects/my-id")
        .to_return(:status => 204, :headers => {})

      resource = TestObject.new(id: "my-id")

      assert_equal nil, resource.delete
    end

    def test_nested_delete
      stub_request(:delete, "https://api.mollie.nl/v1/testobjects/object-id/nestedobjects/my-id")
        .to_return(:status => 204, :headers => {})

      resource = TestObject::NestedObject.delete("my-id", testobject_id: "object-id")

      assert_equal nil, resource
    end

    def test_nested_delete_instance
      stub_request(:delete, "https://api.mollie.nl/v1/testobjects/object-id/nestedobjects/my-id")
        .to_return(:status => 204, :headers => {})

      resource = TestObject::NestedObject.new(id: "my-id", testobject_id: "object-id")

      assert_equal nil, resource.delete
    end

    def test_all
      stub_request(:get, "https://api.mollie.nl/v1/testobjects?count=50&offset=0")
        .to_return(:status => 200, :body => %{{"data":[{"id":"my-id"}]}}, :headers => {})

      resource = TestObject.all

      assert_equal "my-id", resource.first.id
    end

    def test_nested_all
      stub_request(:get, "https://api.mollie.nl/v1/nestedobjects?count=50&offset=0")
        .to_return(:status => 200, :body => %{{"data":[{"id":"my-id"}]}}, :headers => {})

      resource = TestObject::NestedObject.all

      assert_equal "my-id", resource.first.id
    end

    def test_nested_all_scoped
      stub_request(:get, "https://api.mollie.nl/v1/testobjects/object-id/nestedobjects?count=50&offset=0")
        .to_return(:status => 200, :body => %{{"data":[{"id":"my-id"}]}}, :headers => {})

      resource = TestObject::NestedObject.all(testobject_id: 'object-id')

      assert_equal "my-id", resource.first.id
    end
  end
end
