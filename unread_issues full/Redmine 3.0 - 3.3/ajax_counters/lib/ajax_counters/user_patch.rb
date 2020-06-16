module AjaxCounters
  module UserPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        cattr_accessor :ajc_counters
        attr_writer :api_request
      end
    end

    module InstanceMethods
      def ajax_counter(action_name, options={})
        options ||= {}
        options[:css] = options[:css] ? 'ac_counter ' + options[:css].to_s : 'ac_counter'
        options[:period] = options[:period] ? options[:period].to_i : 180
        params = []
        if options[:params].present? && options[:params].is_a?(Hash)
          options[:params].each do |(k, v)|
            params << "#{k}=#{v}" if k.present? && v.present?
          end
        end
        action_md5 = action_name
        if params.present?
          action_md5 += '?' + params.join('&')
        end

        action_md5 = Digest::MD5.hexdigest(action_md5)

        self.class.ajc_counters ||= {}
        self.class.ajc_counters[action_md5] = { action_name: action_name, period: options[:period].to_i, params: options[:params] }

        '<span data-id="' + action_md5 + '" class="' + options[:css] + '"></span>'.html_safe
      end

      def api_request?
        @api_request
      end
    end
  end
end