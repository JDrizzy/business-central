# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/company_information_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::CompanyInformationTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @company_information = @client.company_information(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, /companyInformation/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'business1'
            }
          ]
        }.to_json
      )

    response = @company_information.find_all
    assert_equal response.first[:display_name], 'business1'
  end

  def test_find_by_id
    test_company_id = '123'
    stub_request(:get, /companyInformation\(#{test_company_id}\)/)
      .to_return(
        status: 200,
        body: {
          displayName: 'business2'
        }.to_json
      )

    response = @company_information.find_by_id(test_company_id)
    assert_equal response[:display_name], 'business2'
  end

  def test_create
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @company_information.create({})
    end
  end

  def test_update
    test_company_id = '123'
    stub_request(:get, /companyInformation\(#{test_company_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          displayName: 'business3'
        }.to_json
      )

    stub_request(:patch, /companyInformation\(#{test_company_id}\)/)
      .to_return(
        status: 200,
        body: {
          displayName: 'business4'
        }.to_json
      )

    response = @company_information.update(
      test_company_id,
      display_name: 'business4'
    )
    assert_equal response[:display_name], 'business4'
  end

  def test_delete
    assert_raises Microsoft::Dynamics365::BusinessCentral::NoSupportedMethod do
      @company_information.destroy('123')
    end
  end
end
