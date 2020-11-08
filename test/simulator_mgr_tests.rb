require 'test/unit'
require File.expand_path('helper', __dir__)
require File.expand_path('stubs/simulators_provider_stub', __dir__)
require 'simulator_manager/simulator_mgr'

class SimulatorMgrTests < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

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
end
