class CountryName < ActiveRecord::Base
#  has_many :locations
  
  attr_accessible   # No attributes are accessible

  #  The validity of a CountryName object should be checked by calling valid?, and not by
  #   attempting to save the object.
  #  This validation only approves CountryName objects where the english name of the country
  #   is in the database - which effectively prevents us from adding new CountryName objects,
  #   since they will fail validation.  It's something of a Catch-22.  If you need to add a
  #   CountryName, you should do so using MySQL.
  validates_each :english_name do |model, attr, value|
    if !CountryName.find_by_english_name(value)
      model.errors.add_to_base("'#{value}' is not the name of a country in our database")
    end
  end


  def self.find_by_english_name_or_altname(country_name)
    country_name.strip!     #  Remove leading and trailing whitespace
    english_name = self.find_by_english_name(country_name)
    if english_name
      return english_name
    elsif CountryName.is_usa?(country_name)
      return self.find_by_english_name('United States')
    elsif country_name =~ /england|great britain|^uk$|^u\.k\.$/i
      return self.find_by_english_name('United Kingdom')
    elsif country_name =~ /brasil/i
      return self.find_by_english_name('Brazil')
    elsif country_name =~ /Republic of Korea/i
      return self.find_by_english_name('Korea, Republic of')
    else
      return nil
    end
  end

  def self.is_usa?(country_name)
    if country_name =~ /united states|^\s*usa\s*$/i
      return true
    else
      return false
    end
  end

  def self.valid_name?(country_name)
    if self.find_by_english_name_or_altname(country_name)
      return true
    else
      return false
    end
  end

  def english_name_with_underscores
    self.english_name.gsub(' ', '_').gsub(',', '')
  end

  def is_usa?
    return CountryName.is_usa?(self.english_name)
  end
  
end
