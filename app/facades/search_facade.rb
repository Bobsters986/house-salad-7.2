class SearchFacade
  def initialize(state)
    @state = state
  end

  def members
    conn = Faraday.new(url: "https://api.propublica.org") do |faraday|
      faraday.headers["X-API-Key"] = ENV["PROPUBLICA_API_KEY"]
    end

    response = conn.get("/congress/v1/members/house/#{@state}/current.json")

    json = JSON.parse(response.body, symbolize_names: true)
    @members = json[:results].map do |member_data|
      Member.new(member_data)
    end
  end
end