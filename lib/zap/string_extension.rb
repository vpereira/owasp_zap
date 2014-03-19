module Zap
    # extending String instance
    module StringExtension
        # from camel_case to snake_case: ie: fooBar to foo_bar
        def snake_case
          return downcase if match(/\A[A-Z]+\z/)
          gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z])([A-Z])/, '\1_\2').
          downcase
        end
        # from snake_case to camel_case: ie: foo_bar to fooBar
        def camel_case
          self.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        end
    end
end
