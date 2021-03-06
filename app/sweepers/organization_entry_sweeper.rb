class OrganizationEntrySweeper < ActionController::Caching::Sweeper
  observe OrganizationEntry
  
  def after_create(organization_entry)
    expire_cache_for(organization_entry)
  end
  
  def after_destroy(organization_entry)
    expire_cache_for(organization_entry)
  end

  def after_update(organization_entry)
    expire_cache_for(organization_entry)
  end
  
private

  def expire_cache_for(organization_entry)
    expire_fragment("organization_listing_#{organization_entry.id}")
    expire_fragment(:controller => 'organizations', :action => 'index')
    expire_fragment("map_feed_organizations")
    expire_fragment("map_feed_combined")
  end

end
