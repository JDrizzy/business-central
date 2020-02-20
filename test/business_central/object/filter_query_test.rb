# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/object/filter_query_test.rb

class BusinessCentral::Object::FilterQueryTest < Minitest::Test
  def setup
    @filter_query = BusinessCentral::Object::FilterQuery
  end

  def test_no_template_values
    test_filter = "displayName eq 'name'"
    filter = @filter_query.sanitize(test_filter)
    assert_equal filter, CGI.escape(test_filter)
  end

  def test_template_filter_value
    filter = @filter_query.sanitize("displayName eq '?'", ['name'])
    assert_equal filter, CGI.escape("displayName eq 'name'")
  end

  def test_multiple_template_filter_value
    filter = @filter_query.sanitize("displayName eq '?' and '?'", %w[name hello])
    assert_equal filter, CGI.escape("displayName eq 'name' and 'hello'")
  end

  def test_template_filter_with_single_quote
    filter = @filter_query.sanitize("displayName eq '?'", ["It's a hard knock life"])
    assert_equal filter, CGI.escape("displayName eq 'It''s a hard knock life'")
  end

  def test_invalid_values_provided_for_templates_defined
    filter = @filter_query.sanitize("displayName eq '?' and ?", ['test1'])
    assert_equal filter, CGI.escape("displayName eq 'test1' and ")
  end
end
