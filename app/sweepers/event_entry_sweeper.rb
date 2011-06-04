class EventEntrySweeper < ActionController::Caching::Sweeper
  observe EventEntry
  
  def after_create(event_entry)
    expire_cache_for(event_entry)
  end
  
  def after_destroy(event_entry)
    expire_cache_for(event_entry)
  end

  def after_update(event_entry)
    expire_cache_for(event_entry)
  end
  
private

  def expire_cache_for(event_entry)
    expire_fragment("event_listing_#{event_entry.id}")
    expire_fragment(:controller => 'events', :action => 'index')
  end

end
