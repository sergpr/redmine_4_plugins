module RedmineIssueTabs
  module JournalPatch
    def self.included(base)
      base.class_eval do
        has_many :rit_journal_attachments, -> { where("#{JournalDetail.table_name}.property = 'attachment' AND #{JournalDetail.table_name}.value is not null AND #{JournalDetail.table_name}.value <> ''") }, class_name: 'JournalDetail', foreign_key: :journal_id
      end
    end
  end
end