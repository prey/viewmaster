module Viewmaster::Request
  extend ActiveSupport::Concern

  included do
    after_filter :store_last_location
    before_filter :set_layout
    helper_method :user_layout
  end

  # returns either TemplateVersion
  def user_layout
    @stored_layout ||= get_layout
    # @stored_layout ||= logged_in? && current_user.layout
    Viewmaster::Config.include?(@stored_layout) ? Viewmaster::TemplateVersion.find( @stored_layout ) : Viewmaster::Config.default_version
  end

  def set_layout_from_store
    return if current_user.blank?
    cookies[:layout] = current_user.layout || Viewmaster::Config.default_version.name
  end

  def get_layout_from_store
    if t = Viewmaster::TemplateVersion.find( current_user.layout )
      t
    else
      Viewmaster::Config.default_version
    end
  end

  def get_layout
    if Viewmaster::Config.include?(cookies[:layout])
      cookies[:layout]
    else
      cookies[:layout] = Viewmaster::Config.default_version.name
    end
    #logged_in? ? current_user.layout : cookies[:layout]
  end

  private

  def method_missing(method, *args)
    if method.to_s.match(/^is_version_(\w+)[?]$/)
      user_layout.name == $1
    else
      super
    end
  end

  def store_last_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    unless request.xhr? # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def set_layout
    self.view_paths.insert 0, ::ActionView::FileSystemResolver.new(user_layout.template_path)
  end

end
