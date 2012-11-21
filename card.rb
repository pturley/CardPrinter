class Card

  def initialize(card_doc, estimate_field)
    @title = card_doc.xpath(".//name")[0].text
    @number = card_doc.xpath(".//number")[0].text
    @estimate = ""

    card_doc.xpath(".//properties/property").each do |property|
      if property.xpath(".//name")[0].text == estimate_field
        @estimate = property.xpath(".//value")[0].text
        break
      end
    end
  end

  def title
    @title
  end

  def number
    @number
  end

  def estimate
    @estimate
  end
end