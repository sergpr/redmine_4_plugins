module AjaxCounters
  module IssueQueryPatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        cattr_accessor :ajc_stored_filter_types
        alias_method_chain :add_available_filter, :ajc
        alias_method_chain :type_for, :ajc
        alias_method_chain :sql_for_custom_field, :ajc
      end
    end

    module InstanceMethods
      def add_available_filter_with_ajc(field, options)
        if field.present? && options[:type].present?
          if self.class.ajc_stored_filter_types.blank?
            self.class.ajc_stored_filter_types = {}
          end
          self.class.ajc_stored_filter_types[field.to_s] = options[:type]
        end
        add_available_filter_without_ajc(field, options)
      end

      def type_for_with_ajc(field)
        if self.class.ajc_stored_filter_types && self.class.ajc_stored_filter_types[field.to_s].present?
          self.class.ajc_stored_filter_types[field.to_s]
        else
          type_for_without_ajc(field)
        end
      end

      def sql_for_custom_field_with_ajc(field, operator, value, custom_field_id)
        if @available_filters.blank?
          @available_filters ||= ActiveSupport::OrderedHash.new
          @available_filters[field] = { field: CustomField.find_by_id(custom_field_id) }
          return nil if @available_filters[field][:field].blank?

          res = sql_for_custom_field_without_ajc(field, operator, value, custom_field_id)
          @available_filters = nil
        else
          res = sql_for_custom_field_without_ajc(field, operator, value, custom_field_id)
        end
        res
      end
    end
  end
end