# frozen_string_literal: true

module BusinessCentral
  module Object
    class ItemCategory < Base
      OBJECT = 'itemCategories'

      OBJECT_METHODS = %i[
        get
        post
        patch
        delete
      ].freeze
    end
  end
end
