# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/business_central/exceptions_test.rb

class BusinessCentral::ExceptionsTest < Minitest::Test
  def test_invalid_client_exception
    exception = BusinessCentral::InvalidClientException.new
    assert_equal('Invalid client setup', exception.message)
  end

  def test_company_not_found_exception
    exception = BusinessCentral::CompanyNotFoundException.new
    assert_equal('Company not found', exception.message)
  end

  def test_unathorized_exception
    exception = BusinessCentral::UnauthorizedException.new
    assert_equal('Unauthorized - The credentials provided are incorrect', exception.message)
  end

  def test_not_found_exception
    exception = BusinessCentral::NotFoundException.new
    assert_equal('Not Found - The URL provided cannot be found', exception.message)
  end

  def test_invalid_object_url_exception
    exception = BusinessCentral::InvalidObjectURLException.new
    assert_equal('Object URL missing for request', exception.message)
  end

  def test_invalid_grant_exception
    exception = BusinessCentral::InvalidGrantException.new('Extra error details')
    assert_equal(
      'The provided grant has expired due to it being revoked, a fresh auth token is needed',
      exception.message
    )
    assert_equal('Extra error details', exception.error_message)
  end
end
