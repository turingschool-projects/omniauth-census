module Census
  class Invitation
    attr_reader(:id)

    def initialize(id:)
      @id = id
    end
  end
end
