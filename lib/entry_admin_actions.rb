module EntryAdminActions
  
  def index
    @total_entries = entry_class.count
    render "shared/admin/entries/index", :locals => { :entry_display_name => entry_display_name }
  end
  
  def list
    @entries = entry_class.find(:all)
    render "shared/admin/entries/list", :locals => { :entry_display_name => entry_display_name }
  end
  
end
