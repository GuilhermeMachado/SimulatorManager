require 'test/unit'
require File.dirname(__FILE__) + '/../lib/simulator_manager/simulator_mgr'
require './stubs/simulators_provider_stub'

class SimulatorMgrTests < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def test_list_devices_given_all_parameter
    simulators_provider_stub = SimulatorsProviderStub.new('./resources/mock.json')
    sut = SimulatorManager.new(simulators_provider_stub)

    devices = sut.list_devices('all')

    assert(devices.count == 23)
  end

  def test_list_devices_given_valid_parameter
    simulators_provider_stub = SimulatorsProviderStub.new('./resources/mock.json')
    sut = SimulatorManager.new(simulators_provider_stub)

    devices = sut.list_devices('iPhone')

    assert(devices.count == 10)
  end

  def test_list_devices_given_invalid_parameter
    simulators_provider_stub = SimulatorsProviderStub.new('./resources/mock.json')
    sut = SimulatorManager.new(simulators_provider_stub)

    devices = sut.list_devices('xiaomi')

    assert(devices.count.zero?)
  end
end
