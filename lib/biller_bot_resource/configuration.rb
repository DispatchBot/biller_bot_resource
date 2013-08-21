class BillerBotResource::Configuration
  attr_accessor :site, :logger, :timeout

  def initialize
    self.site = "https://billerbot.com"
    self.timeout = 7 # seconds. Low value so we fail fast
  end

  ##
  # We store the API key within the context of the thread because this is more
  # likely to change between requests.
  def api_key=(key)
    Thread.current["active.resource.currentthread.api_key"] = key
  end

  def api_key
    Thread.current["active.resource.currentthread.api_key"]
  end
end