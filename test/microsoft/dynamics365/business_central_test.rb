# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central_test.rb

class Microsoft::Dynamics365::BusinessCentralTest < Minitest::Test
  def test_version_number_exists
    refute_nil Microsoft::Dynamics365::BusinessCentral::VERSION
  end
end
