module AjaxCounters
  class Hooks  < Redmine::Hook::ViewListener
    render_on :view_layouts_base_html_head, partial: 'hooks/ajax_counters/html_head'
  end
end
