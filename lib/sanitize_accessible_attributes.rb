module SanitizeAccessibleAttributes

  require 'htmlentities'
  require 'sanitize'

  def decode_html_entities_of_attributes!
    return if self.class.accessible_attributes.blank?
    self.class.accessible_attributes.each do |aa|
      v = self.send(aa)
      coder = HTMLEntities.new
      if !v.blank? && (v.class == String || v.class == IO)
        # TODO: Isn't there a better way to do this than using eval?
        eval("self.#{aa} = coder.decode('#{v}')")
      end
    end
  end

  def sanitize_attributes
    return if self.class.accessible_attributes.blank?
    self.class.accessible_attributes.each do |aa|
      v = self.send(aa)
      if !v.blank? && (v.class == String || v.class == IO)
        Sanitize.clean!(v)

        #  The regex below fixes a problem where Sanitize interferes with RedCLoth
        #
        #  Textile allows you to specify URL's using:
        #     "craig":http://craigharman.net   ->   <a href="http://craigharman.net">craig</a>
        #   but Sanitize converts all quotation marks into the corresponding HTML entities, e.g.:
        #    "foo"   ->   &quot;foo&quot;
        #  The regex below converts the HTML entities for quotation marks back into quotation
        #   marks, iff the quotation marks surround a string with and are immediately followed
        #   by a colon and 'http'
        #
        #  TODO: This regex probably opens us back up to some Client-Side Scripting exploits...
        v.gsub!(/&quot;(.*?)&quot;:([http|\/|\.])/, '"\1":\2')
      end
    end
  end

end
