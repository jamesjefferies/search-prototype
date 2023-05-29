require 'open-uri'

class SearchController < ApplicationController
  
  def form
    @page_title = 'Search'
    
    # We create a new form object.
    @form = Form.new
    
    # We construct the URL to grab the data from.
    uri = "#{BASE_API_URI}form"
    
    # We load the data.
    json = JSON.load( URI.open( uri ) )
    
    # We grab the attributes from the data.
    @form.title = json['title']
    @form.description = json['description']
  end
end
