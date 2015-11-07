class BillerBotResource::Resource < ActiveResource::Base

  self.include_root_in_json = false
  self.format   = :json

  ##
  # Allow the resource to be configured via block style.
  def self.configure
    yield config

    self.site   = config.site
    self.logger = config.logger if config.logger
    self.timeout = config.timeout
  end

  def self.config
    if defined?(@config)
      @config
    elsif superclass != ActiveResource::Base && superclass.respond_to?(:config) && !superclass.config.nil?
      superclass.config
    else
      @config = BillerBotResource::Configuration.new
      @config
    end
  end

  ##
  # Append the auth token to all of our queries. The easiest way to do this
  # is to override the query string method and inject it.
  def self.query_string(options)
    options ||= {}
    options[:auth_token] = config.api_key
    super(options)
  end

  def self.instantiate_collection(collection, original_params = {}, prefix_options = {})
    return super if collection.is_a? Array
    remote_collection = []
    remote_collection.concat super(collection["results"], original_params, prefix_options)
    # TODO: Add additional keys to the remote collection
    remote_collection
  end

  def initialize(attributes = {}, persisted = false)
    attributes = enrich_attributes(attributes)
    super(attributes, persisted)
  end

  def save(*args)
    @attributes.delete :created_at
    @attributes.delete :updated_at
    super
  end

  def cache_key
    case
    when new_record?
      "#{self.class.name}/new"
    when timestamp = @attributes[:updated_at]
      timestamp = timestamp.utc.to_s(:number)
      "#{self.class.name}/#{id}-#{timestamp}"
    else
      "#{self.class.name}/#{id}"
    end
  end

protected

  ##
  # Convert string values to more complex types such as Time.
  #
  # @return [Hash] The new attributes
  def enrich_attributes(attributes)
    attrs = {}
    attributes.each do |key, value|
      if time_field?(key, value)
        begin
          value = Time.parse(value)
        rescue
          # Ignore
        end
      end

      attrs[key] = value
    end

    attrs
  end

  def time_field?(name, value)
    name =~ /_at$/i && value && value.is_a?(String)
  end
end
