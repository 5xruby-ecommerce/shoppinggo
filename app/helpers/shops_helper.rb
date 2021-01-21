# frozen_string_literal: true

module ShopsHelper

  def coupon_TimeWithZone_convert(timewithzone)
    timewithzone.strftime('%Y/%m/%d')
  end
end
