require 'test/unit'
require File.expand_path('helper', __dir__)
require 'simulator_manager/simctl_query_builder'

class SimctlQueryBuilderTests < Test::Unit::TestCase
  def test_build_command_given_required_parameter
    sut = SimctlQueryBuilder.new

    command = sut.build_command('boot')

    assert_equal('xcrun simctl boot', command)
  end

  def test_build_command_given_required_and_first_optional_parameter
    sut = SimctlQueryBuilder.new

    command = sut.build_command('boot', '140EF738-51B7-42EB-A7EC-A5139F73DD79')

    assert_equal('xcrun simctl boot 140EF738-51B7-42EB-A7EC-A5139F73DD79', command)
  end

  def test_build_command_given_all_parameters
    sut = SimctlQueryBuilder.new

    command = sut.build_command('install', '140EF738-51B7-42EB-A7EC-A5139F73DD79', 'path')

    assert_equal('xcrun simctl install 140EF738-51B7-42EB-A7EC-A5139F73DD79 path', command)
  end
end
