class Card

  def initialize(card_doc, estimate_field)
    @card_doc = card_doc
    @estimate_field = estimate_field
    @estimate = nil
  end

  def title
    @card_doc.xpath(".//name")[0].text
  end

  def number
    @card_doc.xpath(".//number")[0].text
  end

  def estimate
    unless @estimate
      @card_doc.xpath(".//properties/property").each do |property|
        if property.xpath(".//name")[0].text == @estimate_field
          @estimate = property.xpath(".//value")[0].text
          break
        end
      end
    end
    @estimate
  end
end