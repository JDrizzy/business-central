require "test_helper"
# rake test TEST=test/business_central/object/base_test.rb

class BusinessCentral::Object::BaseTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = BusinessCentral::Client.new
  end

  def test_no_method_supported_for_find_all
    base = BusinessCentral::Object::Base.new(@client, {})
    set_object_method(base, [])
    assert_raises(BusinessCentral::NoSupportedMethod) do
      base.find_all
    end
  end

  def test_no_method_supported_for_find_by_id
    base = BusinessCentral::Object::Base.new(@client, {})
    set_object_method(base, [])
    assert_raises(BusinessCentral::NoSupportedMethod) do
      base.find_by_id('123')
    end
  end

  def test_no_method_supported_for_where_query
    base = BusinessCentral::Object::Base.new(@client, {})
    set_object_method(base, [])
    assert_raises(BusinessCentral::NoSupportedMethod) do
      base.where("displayName eq '123'")
    end
  end

  private

  def set_object_method(base, value)
    base.class.const_set('OBJECT_METHODS', value) if !base.class.const_defined?('OBJECT_METHODS')
  end
end