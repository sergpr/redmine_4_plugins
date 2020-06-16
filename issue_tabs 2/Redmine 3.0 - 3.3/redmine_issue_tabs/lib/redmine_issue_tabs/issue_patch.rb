module RedmineIssueTabs
  module IssuePatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        attr_accessor :rit_journal_load_skip

        alias_method_chain :journals, :rit
      end
    end

    module InstanceMethods
      def journals_with_rit(*args)
        res = journals_without_rit(*args)

        # just hack to prevent loading a history of issue (true set in issues_controller_patch)
        if self.rit_journal_load_skip
          res = res.where('1 = 0')
          self.rit_journal_load_skip = false
        end

        res
      end
    end
  end
end