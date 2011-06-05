class JamEntrySweeper < ActionController::Caching::Sweeper
  observe JamEntry
  
  def after_create(jam_entry)
    expire_cache_for(jam_entry)
  end
  
  def after_destroy(jam_entry)
    expire_cache_for(jam_entry)
  end

  def after_update(jam_entry)
    expire_cache_for(jam_entry)
  end
  
private

  def expire_cache_for(jam_entry)
    expire_fragment("jam_listing_#{jam_entry.id}")
    expire_fragment(:controller => 'jams', :action => 'index')
  end

end
