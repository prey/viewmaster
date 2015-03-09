require_dependency "viewmaster/application_controller"

require "request_store"
module Viewmaster
  class LooksController < ApplicationController

    if defined? Doorman
      include Doorman::Controller
    end

    def switch_to
      # check if a different layout was requested.
      # if none so far, then set to 'none' so we can keep track of it
      if logged_in?

        new_layout = nil

        RequestStore.store[:current_user] = current_user

        if Viewmaster::Config.layouts.include?(params[:id]) && get_layout_from_store.can_transition_to?(params[:id])

          new_layout = cookies[:layout] = params[:id]

        elsif current_user.layout.nil?

          new_layout = cookies[:layout] = Viewmaster::Config.default_version.name #'v1' 'none'

        end

        current_template_version = get_layout_from_store

        if new_layout.blank?

          redirect_to( session[:previous_url].blank? ? "/" : session[:previous_url] ) and return

        else new_layout != current_template_version.name
          RequestStore.store[:new_layout]   = new_layout
          current_template_version.change_version_to(new_layout)
        end
      end

      set_layout

      redirect_to( session[:previous_url].blank? ? "/" : session[:previous_url] ) and return
    end

  end
end
