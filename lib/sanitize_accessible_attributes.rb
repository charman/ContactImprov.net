module SanitizeAccessibleAttributes

  require 'sanitize'

  def sanitize_attributes
    return if self.class.accessible_attributes.blank?
    self.class.accessible_attributes.each do |aa|
      v = self.send(aa)
      if !v.blank? && (v.class == String || v.class == IO)
        Sanitize.clean!(v) 
      end
    end
  end

end
