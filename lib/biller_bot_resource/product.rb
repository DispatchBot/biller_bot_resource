class BillerBotResource::Product < BillerBotResource::Resource

  class Context < BillerBotResource::Resource
    self.prefix = "/products/:product_id/"

    attr_accessor :product

    def prefix_options
      { :product_id => product.id }
    end

    ##
    # ActiveResource treats our nested models as non-persisted models. We make
    # this little hack so that the contexts can be loaded with the product, but
    # saved independently.
    def force_persisted
      @persisted = true

      # Propogate to all children too.
      contexts.each do |c|
        c.product = product
        c.force_persisted
      end
    end

    ##
    # Fetch all the children contexts with the given context type.
    #
    # @param  [String] type The type of context to be searching for
    # @return [Array<BillerBotResource::Product::Context] The matching contexts
    def children_with_type(type)
      contexts.select { |c| (c.type.downcase == type.to_s.downcase) }
    end

    ##
    # Fetch all the child contexts in a flat structure. Also include myself.
    #
    # @return [Array<BillerBotResource::Product::Context>]
    def descendants_with_self
      [self, contexts.map(&:descendants_with_self)].flatten.uniq
    end

    def parent
      return nil unless product
      product.contexts.each do |c|
        r = c.with_child(self)
        return r if r
      end

      nil
    end

    def with_child(context)
      return self if contexts.include?(context)
      contexts.each do |c|
        result = c.with_child(context)
        return result if result
      end

      nil
    end

    def parent_quantity
      if parent && parent.quantity
        parent.quantity
      else
        99999
      end
    end
  end

  def initialize(*args)
    super
    contexts.each do |c|
      c.product = self
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
    context = all_contexts.select { |c| c.id.try(:to_i) == id.to_i }.first
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