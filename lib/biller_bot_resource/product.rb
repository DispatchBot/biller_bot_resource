class BillerBotResource::Product < BillerBotResource::Resource

  class Context < BillerBotResource::Resource
    self.prefix = "/products/:product_id/"

    attr_accessor :product_id

    def prefix_options
      { :product_id => product_id }
    end

    ##
    # ActiveResource treats our nested models as non-persisted models. We make
    # this little hack so that the contexts can be loaded with the product, but
    # saved independently.
    def force_persisted
      @persisted = true
    end
  end

  def initialize(*args)
    super
    contexts.each do |c|
      c.product_id = id
      c.force_persisted # See comments on method
    end
  end

  def contexts
    @attributes[:contexts] ||= []
    @attributes[:contexts]
  end

  ##
  # Fetch the root product context for the given account ID.
  #
  # @param  [Integer] account_id
  # @return [BillerBotResource::ProductContext|nil]
  def root_context_for_account_id(account_id)
    contexts.select { |c| c.type == "AccountProductContext" && c.account_id == account_id }.first
  end
end