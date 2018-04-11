module Census
  class User
    attr_reader(
      :cohort_name,
      :email,
      :first_name,
      :git_hub,
      :groups,
      :id,
      :image_url,
      :last_name,
      :roles,
      :slack,
      :stackoverflow,
      :twitter
    )

    def initialize(
      cohort_name:,
      email:,
      first_name:,
      git_hub:,
      groups:,
      id:,
      image_url:,
      last_name:,
      roles:,
      slack:,
      stackoverflow:,
      twitter:
    )
      @cohort_name = cohort_name
      @email = email
      @first_name = first_name
      @git_hub = git_hub
      @groups = groups
      @id = id
      @image_url = image_url
      @last_name = last_name
      @roles = roles
      @slack = slack
      @stackoverflow = stackoverflow
      @twitter = twitter
    end
  end
end
