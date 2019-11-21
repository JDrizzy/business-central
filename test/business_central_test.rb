require "test_helper"

class BusinessCentralTest < Minitest::Test
  def test_version_number_exists
    refute_nil BusinessCentral::VERSION
  end
end
