module Arpa
  class ProfilesController < ApplicationController
    before_action :set_profile, only: %i[show edit update remove]

    # GET /profiles
    def index
      @profiles = profile_finder.all
    end

    # GET /profiles/1
    def show; end

    # GET /profiles/new
    def new
      @profile = Arpa::Entities::Profile.new
      all_roles
    end

    # GET /profiles/1/edit
    def edit
      all_roles
    end

    # POST /profiles
    def create
      profile_creator.create({ profile: profile_params },
                             success: redirect_to_index(I18n.t('flash.actions.create_profile.notice')),
                             fail: render_errors(:new))
    end

    # PATCH/PUT /profiles/1
    def update
      profile_updater.update({ profile: profile_params },
                             success: redirect_to_index(I18n.t('flash.actions.update_profile.notice')),
                             fail: render_errors(:edit))
    end

    # DELETE /profiles/1
    def remove
      profile_remover.remove({ profile: @profile },
                             success: redirect_to_index(I18n.t('flash.actions.remove_profile.notice')),
                             fail: redirect_to_index(I18n.t('flash.actions.remove_profile.alert')))
    end

    private

    def redirect_to_index(message)
      lambda do |profile|
        redirect_to profile_path(profile.id), notice: message
      end
    end

    def render_errors(action_to_render)
      lambda do |error|
        @profile = Arpa::Entities::Profile.new(profile_params)
        @error = error
        all_roles
        render action_to_render
      end
    end

    def profile_creator
      @profile_creator ||= Arpa::Services::Profiles::ProfileManagerCreator.new
    end

    def profile_updater
      @profile_updater ||= Arpa::Services::Profiles::ProfileManagerUpdater.new
    end

    def profile_remover
      @profile_remover ||= Arpa::Services::Profiles::ProfileManagerRemover.new
    end

    def profile_finder
      @profile_finder ||= Arpa::Repositories::Profiles::Finder.new
    end

    def role_finder
      @role_finder ||= Arpa::Repositories::Roles::Finder.new
    end

    def all_roles
      @roles = role_finder.all
    end

    def set_profile
      @profile = profile_finder.find(params[:id])
    end

    def profile_params
      permitted_params = %i[id name description entity_id entity_class]

      params.require(:profile)
            .permit(permitted_params, role_ids: [])
            .to_h
    end
  end
end
