require 'ajax_counters/view_hooks'
require 'ajax_counters/session_store_bypass'

Redmine::Plugin.register :ajax_counters do
  name 'AjaxCounters plugin'
  author 'Danil Kukhlevskiy, Kovalevskiy Vasil'
  description 'This is a plugin for Redmine improving counters'
  version '1.5.1'
  url 'http://rmplus.pro/'
  author_url 'http://rmplus.pro/'

  menu :custom_menu, :ac_update_counters, '#', caption: Proc.new {('<span>'+I18n.t(:label_refresh_ajax_counters)+'</span>').html_safe}, if: Proc.new { User.current.logged? }, html: {class: 'in_link ac_refresh', id: 'refresh_ajax_counters'}
end

Rails.application.config.to_prepare do
  unless ApplicationController.included_modules.include?(AjaxCounters::ApplicationControllerPatch)
    ApplicationController.send(:include, AjaxCounters::ApplicationControllerPatch)
  end

  unless User.included_modules.include?(AjaxCounters::UserPatch)
    User.send(:include, AjaxCounters::UserPatch)
  end
end

Rails.application.config.after_initialize do
  unless IssueQuery.included_modules.include?(AjaxCounters::IssueQueryPatch)
    IssueQuery.send(:include, AjaxCounters::IssueQueryPatch)
  end
end