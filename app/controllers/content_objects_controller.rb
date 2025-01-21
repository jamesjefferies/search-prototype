class ContentObjectsController < ApplicationController

  def index
    # used as landing page during development
    @page_title = 'Examples'
  end

  def show
    @response = SolrQuery.new(object_uri: params[:object]).all_data['response']

    if @response.has_key?('code')
      # error state
      case @response['code']
      when 404
        render template: 'layouts/shared/error/404', locals: { status: @response['code'], message: @response['msg'] }
      when 500
        render template: 'layouts/shared/error/500', locals: { status: @response['code'], message: @response['msg'] }
      when 401
        render template: 'layouts/shared/error/401', locals: { status: @response['code'], message: @response['msg'] }
      else
        raise 'unknown error occurred'
      end
    elsif @response['docs'].blank?
      render template: 'layouts/shared/error/404', locals: { status: 404, message: 'Page not found' }
    else
      object_data = @response['docs'].first

      if object_data.dig('type_ses').blank?
        render template: 'layouts/shared/error/404', locals: { status: 404, message: 'Page not found' }
      else
        @object = ContentObject.generate(object_data)

        associated_object_results = AssociatedObjectsForObjectView.new(@object).data
        @associated_object_data = associated_object_results.dig(:object_data)

        # Combine SES IDs from associated objects if any
        associated_ses_ids = associated_object_results.dig(:ses_ids)
        object_ses_ids = @object.ses_lookup_ids&.pluck(:value)
        all_ses_ids = associated_ses_ids.blank? ? object_ses_ids : object_ses_ids + associated_ses_ids

        # Use SesData class to handle SES retrival from cache / API
        @ses_data = SesData.new(all_ses_ids).combined_ses_data

        @page_title = @object.object_title

        if @ses_data&.has_key?(:error)
          render template: 'layouts/shared/error/500', locals: { status: 500, message: 'There was an error resolving names using the SES service' }
        else
          render template: @object.template, :locals => { :object => @object }
        end
      end
    end

  end
end