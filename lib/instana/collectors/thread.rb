module Instana
  module Collector
    class Thread

      def initialize
        @last_report = {}
        @this_count = {}
      end

      ##
      # collect
      #
      # To collect thread count
      #
      def collect
        @this_count[:count] = ::Thread.list.count

        ::Instana.agent.payload.delete(:thread)
        @this_count = ::Instana::Util.enforce_deltas(@this_count, @last_report)

        unless @this_count.empty?
          ::Instana.agent.payload[:thread] = @this_count
          @last_report.merge!(@this_count)
        end
      rescue => e
        ::Instana.logger.debug "#{__method__}:#{File.basename(__FILE__)}:#{__LINE__}: #{e.message}"
        ::Instana.logger.debug e.backtrace.join("\r\n")
      end
    end
  end
end

# Register the metrics collector if enabled
if ::Instana.config[:metrics][:thread][:enabled]
  ::Instana.collectors << ::Instana::Collector::Thread.new
end
