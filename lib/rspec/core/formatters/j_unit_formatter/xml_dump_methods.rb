module RSpec::Core::Formatters::JUnitFormatter::XmlDumpMethods
  def xml
    @xml ||= Builder::XmlMarkup.new :target => output, :indent => 2
  end

  def xml_example(example, &block)
    xml.testcase :classname => example_classname(example), :name => example.full_description, :time => '%.6f' % example.execution_result[:run_time], &block
  end

  def example_classname(example)
    example.file_path.sub(%r{\.[^/]*\Z}, "").gsub("/", ".").gsub(%r{\A\.+|\.+\Z}, "")
  end
end
