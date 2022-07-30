# frozen_string_literal: true

class String
  def blank?
    empty? || /\A[[:space:]]*\z/.match?(self)
  end

  def present?
    !blank?
  end

  # Convert string to CamelCase
  def to_camel_case(uppercase_first_letter = false)
    string = self
    string = if uppercase_first_letter
               string.sub(/^[a-z\d]*/, &:capitalize)
             else
               string.sub(/^(?:(?=\b|[A-Z_])|\w)/, &:downcase)
             end
    string.gsub(%r{(?:_|(/))([a-z\d]*)}) { "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}" }.gsub('/', '::')
  end

  # Convert string to snake_case
  def to_snake_case
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end

  # Convert to class symbol
  def classify
    to_camel_case(true).to_s.to_sym
  end
end
