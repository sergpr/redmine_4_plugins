module AjaxCounters
  module ApplicationControllerPatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        alias_method_chain :find_current_user, :aj
      end
    end

    module InstanceMethods
      def find_current_user_with_aj
        usr = find_current_user_without_aj

        usr.api_request = api_request? if usr
        usr
      end
    end
  end
end