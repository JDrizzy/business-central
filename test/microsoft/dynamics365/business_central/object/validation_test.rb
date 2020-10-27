# frozen_string_literal: true

require 'test_helper'
# rake test TEST=test/microsoft/dynamics365/business_central/object/validation_test.rb

class Microsoft::Dynamics365::BusinessCentral::Object::ValidationTest < Minitest::Test
  def test_validation_required
    validation_rules = {
      name: {
        required: true
      }
    }
    object_params = {
      name: ''
    }
    assert_raises Microsoft::Dynamics365::BusinessCentral::InvalidObjectException do
      Microsoft::Dynamics365::BusinessCentral::Object::Validation.new(validation_rules, object_params).valid?
    end
  end

  def test_validation_maximum_length
    validation_rules = {
      name: {
        maximum_length: 5
      }
    }
    object_params = {
      name: '123456'
    }
    assert_raises Microsoft::Dynamics365::BusinessCentral::InvalidObjectException do
      Microsoft::Dynamics365::BusinessCentral::Object::Validation.new(validation_rules, object_params).valid?
    end
  end

  def test_validation_inclusive_value
    validation_rules = {
      type: {
        inclusion_of: %w[1 2 3]
      }
    }
    object_params = {
      type: '4'
    }
    assert_raises Microsoft::Dynamics365::BusinessCentral::InvalidObjectException do
      Microsoft::Dynamics365::BusinessCentral::Object::Validation.new(validation_rules, object_params).valid?
    end
  end

  def test_validation_date
    validation_rules = {
      date_due: {
        date: true
      }
    }
    object_params = {
      date_due: ''
    }
    assert_raises Microsoft::Dynamics365::BusinessCentral::InvalidObjectException do
      Microsoft::Dynamics365::BusinessCentral::Object::Validation.new(validation_rules, object_params).valid?
    end
  end
end
