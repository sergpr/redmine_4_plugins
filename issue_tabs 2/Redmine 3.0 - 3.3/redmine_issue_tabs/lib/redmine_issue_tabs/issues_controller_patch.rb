module RedmineIssueTabs
  module IssuesControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :show, :rit
        skip_before_filter :authorize, only: [:rit_history]
        before_filter :get_time_entries, only: [:show]
      end
    end

    module InstanceMethods
      def show_with_rit
        if params[:format].blank? || params[:format] == 'html'
          @issue.rit_journal_load_skip = true

          @comments = Journal.visible
                             .preload(:user, :rit_journal_attachments)
                             .where(journalized_id: @issue.id, journalized_type: 'Issue')
                             .where("(#{Journal.table_name}.notes is not null and #{Journal.table_name}.notes <> '')
                                  OR EXISTS(SELECT 1 FROM #{JournalDetail.table_name} jd INNER JOIN #{Attachment.table_name} a on jd.property = 'attachment' and a.id = CAST(jd.prop_key AS DECIMAL(30,0)) WHERE jd.journal_id = #{Journal.table_name}.id and a.container_type = 'Issue' and a.container_id = ?)
                                    ", @issue.id)

          @comments = @comments.order("#{Journal.table_name}.created_on DESC, #{Journal.table_name}.id DESC") if User.current.wants_comments_in_reverse_order?
          @comments = @comments.to_a
        end

        show_without_rit
      end

      def rit_history
        return unless find_issue
        return unless authorize

        if Redmine::Plugin.installed?(:usability)
          @use_static_date_in_history = Setting.plugin_usability['use_static_date_in_history']
        end

        @journals = @issue.journals.visible.preload(:user, :details, :rit_journal_attachments)
        @journals = @journals.order("#{Journal.table_name}.created_on DESC, #{Journal.table_name}.id DESC") if User.current.wants_comments_in_reverse_order?
        @journals = @journals.select { |journal| journal.notes? || journal.visible_details.any? }

        Journal.preload_journals_details_custom_fields(@journals)
      end

      def get_time_entries
        @time_entries = @issue.time_entries.preload(:user, :activity).order("#{TimeEntry.table_name}.spent_on DESC")
        @time_entries_for_table = @issue.time_entries.preload(:user, :activity)
                                      .select('user_id, activity_id, sum(hours) as hours_sum')
                                      .group(:user_id, :activity_id).order(:activity_id)
      end
    end
  end
end
