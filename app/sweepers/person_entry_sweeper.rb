class PersonEntrySweeper < ActionController::Caching::Sweeper
  observe PersonEntry
  
  def after_create(person_entry)
    expire_cache_for(person_entry)
  end
  
  def after_destroy(person_entry)
    expire_cache_for(person_entry)
  end

  def after_update(person_entry)
    expire_cache_for(person_entry)
  end
  
private

  def expire_cache_for(person_entry)
    expire_fragment("person_listing_#{person_entry.id}")
    expire_fragment(:controller => 'people', :action => 'index')
  end

end
