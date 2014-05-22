require 'builder'
require 'rspec'

require 'rspec/core/formatters/base_formatter'
require 'rspec/core/formatters/j_unit_formatter'
require 'rspec/core/formatters/legacy_j_unit_formatter'

# Make it easier to use
require 'rspec/core/version'
version = RSpec::Core::Version::STRING

if version >= "3" && version !~ /3\.0\.0\.beta/
  formatter = RSpec::Core::Formatters::JUnitFormatter
else
  formatter = RSpec::Core::Formatters::LegacyJUnitFormatter
end
RspecJunitFormatter = RSpecJUnitFormatter = formatter
