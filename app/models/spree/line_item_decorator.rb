Spree::LineItem.class_eval do
  def tax_cloud_cache_key
    if ActiveRecord::Base.try(:cache_versioning)
      cache_key
    else
      key = "Spree::LineItem #{id}: #{quantity}x<#{variant.cache_key}>@#{total_excluding_vat}#{currency}"
      if order.ship_address
        key << "shipped_to<#{order.ship_address.try(:cache_key)}>"
      elsif order.billing_address
        key << "billed_to<#{order.bill_address.try(:cache_key)}>"
      end
    end
  end

  def tax_cloud_cache_version
    if ActiveRecord::Base.try(:cache_versioning)
      key = "Spree::LineItem #{id}: #{quantity}x<#{variant.cache_version}>@#{total_excluding_vat}#{currency}"
      if order.ship_address
        key << "shipped_to<#{order.ship_address.try(:cache_version)}>"
      elsif order.billing_address
        key << "billed_to<#{order.bill_address.try(:cache_version)}>"
      end
    end
  end

  def price_with_discounts
    round_to_two_places(total_excluding_vat / quantity)
  end

  def round_to_two_places(amount)
    BigDecimal.new(amount.to_s).round(2, BigDecimal::ROUND_HALF_UP)
  end
end
