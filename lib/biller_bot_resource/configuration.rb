class BillerBotResource::Configuration
  attr_accessor :site, :logger, :api_key, :timeout
  
  def initialize
    self.site = "https://billerbot.com"
    self.timeout = 10 # seconds. Low value so we fail fast
  end
end