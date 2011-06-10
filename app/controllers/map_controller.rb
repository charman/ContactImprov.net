class MapController < ApplicationController

  layout "application", :except => [:embed_example]


  def events
    @entry_category = 'events'
    render :action => 'index'
  end

  def feed
    @entry_category = params[:id]

    respond_to do |format|
      format.xml
    end
  end

  def index
    @entry_category = 'combined'
  end

  def jams
    @entry_category = 'jams'
    render :action => 'index'
  end

  def people
    @entry_category = 'people'
    render :action => 'index'
  end

  def organizations
    @entry_category = 'organizations'
    render :action => 'index'
  end

end
