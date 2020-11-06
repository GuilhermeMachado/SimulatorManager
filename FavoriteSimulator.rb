require 'json'
require './SimulatorMgr'

begin
    favorite_simulator_json_file = File.read('./favorite_simulator.json')
    
    data_hash = JSON.parse(favorite_simulator_json_file)

    simulator_manager = SimulatorManager.new
    
    simulator = simulator_manager.findSimulatorByUdid(data_hash['udid'])

rescue SystemCallError => e
    puts(e.class)
end