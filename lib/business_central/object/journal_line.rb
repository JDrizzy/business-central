# frozen_string_literal: true

module BusinessCentral
  module Object
    class JournalLine < Base
      OBJECT = 'journalLines'

      OBJECT_VALIDATION = {
        account_number: {
          maximum_length: 20
        },
        document_number: {
          maximum_length: 20
        },
        external_document_number: {
          maximum_length: 20
        },
        description: {
          maximum_length: 50
        },
        comment: {
          maximum_length: 250
        }
      }.freeze

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze

      OBJECT_PARENTS = %w[
        journal
      ].freeze

      def initialize(client, parent: 'journal', parent_id:, **args)
        return if !valid_parent?(parent)

        super(client, args)
        @parent_path << {
          path: parent.downcase,
          id: parent_id
        }
      end
    end
  end
end
