module Arpa
  class ResourcesController < ApplicationController
    before_action :set_resource, only: [:show]

    # GET /resources
    def index
      @resources = resource_finder.all
    end

    # GET /resources/1
    def show; end

    # GET /generate_resources_and_actions
    def generate_resources_and_actions
      Rails.application.eager_load!

      resource_params = {
        resourceables: ApplicationController.descendants,
        except_action_methods: ApplicationController.action_methods
      }
      resource_creator.create(resource_params,
                              success: success_callback,
                              fail: fail_callback)

      redirect_to resources_path
    end

    private

    def success_callback
      lambda do |_resource|
        flash[:notice] = I18n.t('flash.actions.generate_resources_and_actions.notice')
      end
    end

    def fail_callback
      lambda do |_error|
        flash[:alert] = I18n.t('flash.actions.generate_resources_and_actions.alert')
      end
    end

    def resource_creator
      @resource_creator ||= Arpa::Services::Resources::ResourceManagerCreator.new
    end

    def resource_finder
      @resource_finder ||= Arpa::Repositories::Resources::Finder.new
    end

    def set_resource
      @resource = resource_finder.find(params[:id])
    end
  end
end
