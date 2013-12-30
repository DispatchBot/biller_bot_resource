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

      # Propogate to all children too.
      contexts.each do |c|
        c.product_id = product_id
        c.force_persisted
      end
    end

    ##
    # Fetch all the children contexts with the given context type.
    #
    # @param  [String] type The type of context to be searching for
    # @return [Array<BillerBotResource::Product::Context] The matching contexts
    def children_with_type(type)
      matches = contexts.select { |c| (c.type.downcase == type.to_s.downcase) }
    end

    ##
    # Fetch all the child contexts in a flat structure. Also include myself.
    #
    # @return [Array<BillerBotResource::Product::Context>]
    def descendants_with_self
      [self, contexts.map(&:descendants_with_self)].flatten.uniq
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

  def all_contexts
    contexts.map(&:descendants_with_self).flatten
  end

  def context(id)
    context = all_contexts.select { |c| c.id.try(:to_i) == id.try(:to_i) }.first
    raise ActiveResource::ResourceNotFound.new(nil) if context.nil?
    context
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