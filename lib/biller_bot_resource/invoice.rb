class BillerBotResource::Invoice < BillerBotResource::Resource
  
  class Status < BillerBotResource::Resource
    def display_name
      @attributes[:name].try(:capitalize)
    end
  end

  def locations
    @attributes[:locations] ||= []
    @attributes[:locations]
  end
  
  def line_items
    @attributes[:line_items] ||= []
    @attributes[:line_items]
  end
  
  def save
    @attributes[:line_items_attributes] = @attributes.delete :line_items
    @attributes[:locations_attributes] = @attributes.delete :locations
    super
  end
end