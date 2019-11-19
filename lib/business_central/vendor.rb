module BusinessCentral
  class Vendor < Base
    OBJECT = 'vendors'.freeze

    OBJECT_VALIDATION = {
      number: {
        maximum_length: 20
      },
      display_name: {
        maximum_length: 100
      },
      phone_number: {
        maximum_length: 30
      },
      email: {
        maximum_length: 80
      },
      website: {
        maximum_length: 80
      },
      tax_registration_number: {
        maximum_length: 20
      }
    }.freeze

    def initialize(client, company_id)
      @parent_path = [
        {
          path: 'companies',
          id: company_id
        }
      ]
      super(client, company_id)
    end

    def find_all
      get(build_url(parent_path: @parent_path, child_path: OBJECT))
    end

    def find_by_id(id)
      get(build_url(parent_path: @parent_path, child_path: OBJECT, child_id: id))
    end

    def where(query = '')
      get(build_url(parent_path: @parent_path, child_path: OBJECT, filter: query))
    end

    def create(params = {})
      if valid_object?(OBJECT_VALIDATION, params)
        post(build_url(parent_path: @parent_path, child_path: OBJECT), params)
      end
    end
  end
end
