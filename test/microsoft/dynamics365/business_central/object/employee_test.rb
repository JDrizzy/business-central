# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/employee_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::EmployeeTest < Minitest::Test
  def setup
    @company_id = '123456'
    @client = Microsoft::Dynamics365::BusinessCentral::Client.new
    @employee = @client.employee(company_id: @company_id)
  end

  def test_find_all
    stub_request(:get, %r{/employees})
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'employee1'
            }
          ]
        }.to_json
      )

    response = @employee.find_all
    assert_equal response.first[:display_name], 'employee1'
  end

  def test_find_by_id
    test_id = '09876'
    stub_request(:get, /employees\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          id: test_id,
          displayName: 'employee2'
        }.to_json
      )

    response = @employee.find_by_id(test_id)
    assert_equal response[:display_name], 'employee2'
  end

  def test_where
    test_filter = "displayName eq 'employee3'"
    stub_request(:get, /employees\?\$filter=#{test_filter}/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              displayName: 'employee3'
            }
          ]
        }.to_json
      )

    response = @employee.where(test_filter)
    assert_equal response.first[:display_name], 'employee3'
  end

  def test_create
    stub_request(:post, /employees/)
      .to_return(
        status: 200,
        body: {
          displayName: 'employee4'
        }.to_json
      )

    response = @employee.create(
      display_name: 'employee4'
    )
    assert_equal response[:display_name], 'employee4'
  end

  def test_update
    test_id = '011123'
    stub_request(:get, /employees\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          id: test_id,
          displayName: 'employee5'
        }.to_json
      )

    stub_request(:patch, /employees\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '112',
          id: test_id,
          displayName: 'employee6'
        }.to_json
      )

    response = @employee.update(
      test_id,
      display_name: 'employee6'
    )
    assert_equal response[:display_name], 'employee6'
  end

  def test_delete
    test_id = '0111245'
    stub_request(:get, /employees\(#{test_id}\)/)
      .to_return(
        status: 200,
        body: {
          etag: '113',
          displayName: 'employee7'
        }.to_json
      )

    stub_request(:delete, /employees\(#{test_id}\)/)
      .to_return(status: 204)

    assert @employee.destroy(test_id)
  end

  def test_default_dimension_navigation
    stub_request(:get, /defaultDimensions/)
      .to_return(
        status: 200,
        body: {
          'value': [
            {
              id: 1,
              parentId: '123',
            }
          ]
        }.to_json
      )

    response = @client.employee(company_id: @company_id, id: '123').default_dimension.find_all
    assert_equal response.first[:parent_id], '123'
  end
end
