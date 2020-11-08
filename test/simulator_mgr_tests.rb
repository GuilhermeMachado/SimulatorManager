require 'test/unit'
require File.expand_path('helper', __dir__)
require File.expand_path('stubs/simulators_provider_stub', __dir__)
require File.expand_path('stubs/ui_message_spy', __dir__)
require 'simulator_manager/simulator_mgr'

class SimulatorMgrTests < Test::Unit::TestCase
  def test_list_devices_given_all_parameter
    file = File.expand_path('resources/mock.json', __dir__)
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    sut = SimulatorManager.new(simulators_provider_stub)

    devices = sut.list_devices('all')

    assert(devices.count == 23)
  end

  def test_list_devices_given_valid_parameter
    file = File.expand_path('resources/mock.json', __dir__)
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    sut = SimulatorManager.new(simulators_provider_stub)

    devices = sut.list_devices('iPhone')

    assert(devices.count == 10)
  end

  def test_list_devices_given_invalid_parameter
    file = File.expand_path('resources/mock.json', __dir__)
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    sut = SimulatorManager.new(simulators_provider_stub)

    devices = sut.list_devices('xiaomi')

    assert(devices.count.zero?)
  end

  def test_start_device_given_booted_device
    file = File.expand_path('resources/booted_simulator.json', __dir__)
    simulators_provider_stub = SimulatorsProviderStub.new(file)
    ui_message_spy = UIMessageSpy.new
    sut = SimulatorManager.new(simulators_provider_stub, ui_message_spy)

    sut.start_device('68C69164-A164-4127-8668-E97C18E062C4')

    assert_equal('Simulator already booted', ui_message_spy.show_error_message_passed)
  end
end
