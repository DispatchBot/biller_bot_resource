class BillerBotResource::Configuration
  attr_accessor :site, :logger, :api_key
  
  def initialize
    self.site = "https://billerbot.com"
  end
end