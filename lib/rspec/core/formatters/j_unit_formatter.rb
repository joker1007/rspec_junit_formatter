require 'time'

# Dumps rspec results as a JUnit XML file.
# Based on XML schema: http://windyroad.org/dl/Open%20Source/JUnit.xsd
class RSpec::Core::Formatters::JUnitFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self,
    :start, :example_passed, :example_pending, :example_failed,
    :dump_summary, :close

  require 'rspec/core/formatters/j_unit_formatter/xml_dump_methods'
  include XmlDumpMethods

  def initialize(output)
    super
    @example_notifications = []
  end

  def start(notification)
    @start = Time.now
    super
  end

  def example_passed(notification)
    @example_notifications << notification
  end

  def example_pending(notification)
    @example_notifications << notification
  end

  def example_failed(notification)
    @example_notifications << notification
  end

  def dump_summary(summary)
    xml.instruct!
    testsuite_options = {
      :name => 'rspec',
      :tests => summary.example_count,
      :failures => summary.failure_count,
      :errors => 0,
      :time => '%.6f' % summary.duration,
      :timestamp => @start.iso8601
    }
    xml.testsuite testsuite_options do
      xml.properties
      @example_notifications.each do |notification|
        send :"dump_summary_example_#{notification.example.execution_result[:status]}", notification
      end
    end
  end

  def dump_summary_example_passed(notification)
    xml_example notification.example
  end

  def dump_summary_example_pending(notification)
    xml_example notification.example do
      xml.skipped
    end
  end

  def dump_summary_example_failed(notification)
    exception = notification.exception
    backtrace = notification.formatted_backtrace

    xml_example notification.example do
      xml.failure :message => exception.to_s, :type => exception.class.name do
        xml.cdata! "#{exception.message}\n#{backtrace.join "\n"}"
      end
    end
  end
end
