# frozen_string_literal: true

module BusinessCentral
  module Object
    class GeneralLedgerEntry < Base
      OBJECT = 'generalLedgerEntries'

      OBJECT_METHODS = %i[
        get
      ].freeze
    end
  end
end
