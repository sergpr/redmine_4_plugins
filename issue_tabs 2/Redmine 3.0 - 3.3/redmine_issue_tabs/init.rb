Redmine::Plugin.register :redmine_issue_tabs do
  name 'Redmine Issue Tabs plugin'
  author 'Pitin Vladimir, Alexey Glukhov, Kovalevskiy Vasil'
  description 'Plugin enhances issue interface by adding several useful tabs: timelog, time spent, code commits, history'
  version '1.2.3'
  url 'http://rmplus.pro/redmine/plugins/issue_tabs'
  author_url 'http://rmplus.pro/'

  p = Redmine::AccessControl.permission(:view_issues)
  if p && p.project_module == :issue_tracking
    p.actions << 'issues/rit_history'
  end
end

require 'redmine_issue_tabs/view_hooks'

Rails.application.config.to_prepare do
  Issue.send(:include, RedmineIssueTabs::IssuePatch) unless Issue.included_modules.include?(RedmineIssueTabs::IssuePatch)
  Journal.send(:include, RedmineIssueTabs::JournalPatch) unless Journal.included_modules.include?(RedmineIssueTabs::JournalPatch)
  if Redmine::VERSION.to_s >= '3.2.0'
    JournalsHelper.send(:include, RedmineIssueTabs::JournalsHelperPatch) unless JournalsHelper.included_modules.include?(RedmineIssueTabs::JournalsHelperPatch)
  end
  IssuesController.send(:include, RedmineIssueTabs::IssuesControllerPatch) unless IssuesController.included_modules.include?(RedmineIssueTabs::IssuesControllerPatch)
end

