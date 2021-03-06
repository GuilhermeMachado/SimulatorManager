require 'json'
require File.dirname(__FILE__) + '/simulator_mgr'

begin
  favorite_simulator_json_file = File.read('./favorite_simulator.json')

  data_hash = JSON.parse(favorite_simulator_json_file)

  simulator_manager = SimulatorManager.new

  simulator = simulator_manager.find_simulator_by_udid(data_hash['udid'])
rescue SystemCallError => e
  puts(e.class)
end
