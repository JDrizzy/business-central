require "test_helper"

class BusinessCentral::ValidationTest < Minitest::Test
  def test_validation_required
    validation_rules = {
      name: {
        required: true
      }
    }
    object_params = {
      name: ''
    }
    assert_raises BusinessCentral::InvalidObjectException do
      BusinessCentral::Validation.new(validation_rules, object_params).valid?
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
    assert_raises BusinessCentral::InvalidObjectException do
      BusinessCentral::Validation.new(validation_rules, object_params).valid?
    end
  end

  def test_validation_inclusive_value
    validation_rules = {
      type: {
        inclusion_of: ['1', '2', '3']
      }
    }
    object_params = {
      type: '4'
    }
    assert_raises BusinessCentral::InvalidObjectException do
      BusinessCentral::Validation.new(validation_rules, object_params).valid?
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
    assert_raises BusinessCentral::InvalidObjectException do
      BusinessCentral::Validation.new(validation_rules, object_params).valid?
    end
  end

end