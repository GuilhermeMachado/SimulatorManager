require 'test/unit'
require '../lib/simulator_mgr'
require './simulator_mgr/simulators_provider_stub'

class SimulatorMgrTests < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def test_list_devices_given_all_parameter
    simulators_provider_stub = SimulatorsProviderStub.new('./simulator_mgr/mock.json')
    sut = SimulatorManager.new(simulators_provider_stub)
    devices = sut.list_devices('all')
    assert(!devices.nil?)
    assert(devices.count == 2)
  end
end