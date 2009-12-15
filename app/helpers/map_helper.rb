module MapHelper
  
  def javascript_array_for_tabbed_infowindow(markerinfo)
    ja = markerinfo.collect { |info|
      "{mouseover_text:'#{info['mouseover_text']}', " + 
      "infowindow_html:'#{info['infowindow_html']}', " + 
      "entry_class:'#{info['entry_class']}'}"
    }.join(',')
    "[#{ja}]".gsub(/\"/, '\"')
  end
  
end
