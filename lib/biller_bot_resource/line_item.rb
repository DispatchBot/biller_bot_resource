class BillerBotResource::LineItem < BillerBotResource::Resource
  def total_charge
    @attributes[:total_charge] || 0
  end
end