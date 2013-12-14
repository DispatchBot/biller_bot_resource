class BillerBotResource::Invoice < BillerBotResource::Resource
  self.include_root_in_json = true

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

  def save(*args)
    line_items = Array.wrap(@attributes.delete(:line_items)).compact
    locations = Array.wrap(@attributes.delete(:locations)).compact
    @attributes[:line_items_attributes] = line_items unless line_items.empty?
    @attributes[:locations_attributes] = locations unless locations.empty?
    super
  end

  def total_charge
    line_items.map(&:total_charge).inject(:+) || 0
  end
end