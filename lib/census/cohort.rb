module Census
  class Cohort
    attr_reader(
      :id,
      :name,
      :start_date,
      :status
    )

    def initialize(
      id:,
      name:,
      start_date:,
      status:
    )
      @id = id
      @name = name
      @start_date = start_date
      @status = status
    end
  end
end
