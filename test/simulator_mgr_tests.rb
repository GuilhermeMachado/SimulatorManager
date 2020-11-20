require "test/unit"
require File.expand_path("helper", __dir__)
require File.expand_path("resource_helper", __dir__)
require File.expand_path("stubs/simulators_provider_stub", __dir__)
require File.expand_path("stubs/ui_message_spy", __dir__)
require File.expand_path("stubs/process_runner_spy", __dir__)
require File.expand_path("stubs/process_runner_stub", __dir__)
require File.expand_path("stubs/simctl_query_builder_spy", __dir__)
require File.expand_path("lib/simulator_manager/simulator_mgr")
require File.expand_path("lib/simulator_manager/process_runner")

class SimulatorMgrTests < Test::Unit::TestCase
  attr_accessor :resource_helper

  def setup
    @resource_helper = ResourceHelper.new
  end

  def test_list_devices_given_all_parameter
    file = resource_helper.find_file("mock.json")
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    sut = SimulatorManager.new(simulators_provider_stub)

    devices = sut.list_devices("all")

    assert_equal(23, devices.count)
  end

  def test_list_devices_given_valid_parameter
    file = resource_helper.find_file("mock.json")
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    sut = SimulatorManager.new(simulators_provider_stub)

    devices = sut.list_devices("iPhone")

    assert_equal(10, devices.count)
  end

  def test_list_devices_given_invalid_parameter
    file = resource_helper.find_file("mock.json")
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    sut = SimulatorManager.new(simulators_provider_stub)

    devices = sut.list_devices("xiaomi")

    assert(devices.count.zero?)
  end

  def test_start_device_given_booted_device
    file = resource_helper.find_file("booted_simulator.json")
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    ui_message_spy = UIMessageSpy.new
    sut = SimulatorManager.new(simulators_provider_stub, ui_message_spy)

    sut.start_device("68C69164-A164-4127-8668-E97C18E062C4")

    assert_equal("Simulator already booted", ui_message_spy.show_error_message_passed)
  end

  def test_start_device_give_not_booted_device_should_pass_correct_parameters_to_query_builder
    file = resource_helper.find_file("mock.json")
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    process_runner_spy = ProcessRunnerSpy.new
    ui_message_spy = UIMessageSpy.new
    simctl_query_builder_spy = SimctlQueryBuilderSpy.new

    sut = SimulatorManager.new(simulators_provider_stub, ui_message_spy, simctl_query_builder_spy, process_runner_spy)

    sut.start_device("68C69164-A164-4127-8668-E97C18E062C4")

    assert_equal("boot", simctl_query_builder_spy.command_passed)
    assert_equal("68C69164-A164-4127-8668-E97C18E062C4", simctl_query_builder_spy.arg1_passed)
    assert_nil(simctl_query_builder_spy.arg2_passed)
  end

  def test_start_device_give_not_booted_device_should_pass_correct_command_to_process_runner
    file = resource_helper.find_file("mock.json")
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    process_runner_spy = ProcessRunnerSpy.new
    ui_message_spy = UIMessageSpy.new
    simctl_query_builder = SimctlQueryBuilder.new

    sut = SimulatorManager.new(simulators_provider_stub, ui_message_spy, simctl_query_builder, process_runner_spy)

    sut.start_device("68C69164-A164-4127-8668-E97C18E062C4")

    assert_equal("xcrun simctl boot 68C69164-A164-4127-8668-E97C18E062C4", process_runner_spy.create_process_command_passed)
  end

  def test_start_device_give_not_booted_device_given_process_execution_succeed_should_present_success_message
    file = resource_helper.find_file("mock.json")
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    process_runner_stub = ProcessRunnerStub.new(true)
    ui_message_spy = UIMessageSpy.new
    simctl_query_builder = SimctlQueryBuilder.new

    sut = SimulatorManager.new(simulators_provider_stub, ui_message_spy, simctl_query_builder, process_runner_stub)

    sut.start_device("68C69164-A164-4127-8668-E97C18E062C4")

    assert_equal("Device booted 68C69164-A164-4127-8668-E97C18E062C4", ui_message_spy.show_success_message_passed)
  end

  def test_start_device_give_not_booted_device_given_process_execution_failure_should_present_error_message
    file = resource_helper.find_file("mock.json")
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    process_runner_stub = ProcessRunnerStub.new(false)
    ui_message_spy = UIMessageSpy.new
    simctl_query_builder = SimctlQueryBuilder.new

    sut = SimulatorManager.new(simulators_provider_stub, ui_message_spy, simctl_query_builder, process_runner_stub)

    sut.start_device("68C69164-A164-4127-8668-E97C18E062C4")

    assert_equal("Error while booting the device", ui_message_spy.show_error_message_passed)
  end
end
