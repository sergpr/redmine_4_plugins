module UnreadIssues
  module UnreadIssues
    class Hooks < Redmine::Hook::ViewListener
      render_on(:view_layouts_base_html_head, partial: 'hooks/unread_isues/add_css')
      render_on(:view_issues_show_details_bottom, partial: 'hooks/unread_isues/issue_bottom_details')
    end
  end
end