module BusinessCentral
  class Company < Base
    OBJECT = 'companies'.freeze

    def find_all
      get(build_url(child_path: OBJECT))
    end

    def find_by_id(id)
      get(build_url(child_path: OBJECT, child_id: id))
    end
  end
end