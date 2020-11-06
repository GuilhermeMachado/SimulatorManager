require 'open3'
require 'colorize'
require './Simulator.rb'

class SimulatorManager
  attr_accessor :simulators

  def initialize
    @simulators = []
    createSimulators
  end

  def listDevices(nameFilter)
    filtered = simulators

    if nameFilter != 'all'
      filtered = simulators.select { |simulator| simulator.name.include? nameFilter }

      if filtered.empty?
        showErrorMessage('No simulator was found with provided name filter')
        exit(1)
      end
    end

    filtered.each do |simulator|
      puts ''
      puts 'udid => ' + simulator.udid.to_s.green
      puts 'name => ' + simulator.name.to_s.yellow

      if simulator.booted == false
        puts 'booted => ' + simulator.booted.to_s.red
      else
        puts 'booted => ' + simulator.booted.to_s.green
      end

      if simulator.booted == false
        puts 'available => ' + simulator.available.to_s.red
      else
        puts 'available => ' + simulator.available.to_s.green
      end
    end
  end

  def startDevice(udid)
    simulator = findSimulatorByUdid(udid)

    if simulator.booted == true
      showErrorMessage('Simulator already booted')
      exit(1)
    end

    pid = fork { exec('xcrun simctl boot ' + udid) }
    puts 'Booting device 📲  => ' + udid
    _, status = Process.waitpid2(pid)

    if status.success?
      showSuccessMessage('Device booted ' + udid)
    else
      showErrorMessage('Error while booting the device')
      exit(1)
    end
  end

  def shutdownDevice(udid)
    simulator = findSimulatorByUdid(udid)

    showWarningMessage('Simulator already offline') if simulator.booted == false

    pid = fork { exec('xcrun simctl shutdown ' + udid) }
    puts 'Turning off device 📲  => ' + udid
    _, status = Process.waitpid2(pid)

    if status.success?
      showSuccessMessage('Device offline ' + udid)
    else
      showErrorMessage('Error while Turning off the device')
      exit(1)
    end
  end

  def installApp(path, udid, bundle)
    puts 'SimulatorManager => Path => ' + path
    puts 'SimulatorManager => udid => ' + udid

    simulator = findSimulatorByUdid(udid)

    startDevice(simulator.udid) if simulator.booted == false

    unless bundle.nil?
      puts 'SimulatorManager => bundle => ' + bundle
      if !findAppInSimulator(simulator.udid, bundle).empty?
        puts showSuccessMessage('App localizado')
        removeAppFromSimulator(simulator.udid, bundle)
      else
        showErrorMessage('App não localizado')
      end
    end
    puts 'SimulatorManager => Next command => ' + 'xcrun simctl install "' + simulator.udid + '" "' + path + '"'
    pid = fork { exec('xcrun simctl install "' + simulator.udid + '" "' + path + '"') }
    puts 'Please wait for the installation 📲 ...'
    _, status = Process.waitpid2(pid)

    if status.success?
      showSuccessMessage('APPLICATION INSTALLED INTO ' + simulator.udid)
      showSuccessMessage(path)
      shutdownDevice(simulator.udid)
    else
      showErrorMessage('Error while installing the app into simulator.')
      exit(1)
    end
  end

  def removeApp(udid, bundle)
    simulator = findSimulatorByUdid(udid)

    if !findAppInSimulator(udid, bundle).empty?
      puts showSuccessMessage('App localizado')
      removeAppFromSimulator(udid, bundle)
    else
      showErrorMessage('App not found into simulator ' + udid)
    end
  end

  def findSimulatorByUdid(udid)
    simulator = simulators.select { |simulator| simulator.udid == udid }.first

    if simulator.nil?
      showErrorMessage('Simulator not found')
      exit(1)
    end

    simulator
  end

  private

  def createSimulators
    devices = JSON.parse `xcrun simctl list -j devices`

    devices['devices'].each do |_runtime, runtime_devices|
      runtime_devices.each do |device|
        @simulators << Simulator.new(device['name'], device['udid'], device['state'], device['availability'])
      end
    end
  end

  def findAppInSimulator(udid, bundle)
    stdout, status = Open3.capture2('xcrun simctl get_app_container ' + udid + ' ' + bundle)
    stdout
  end

  def removeAppFromSimulator(udid, bundle)
    pid = fork { exec('xcrun simctl uninstall ' + udid + ' ' + bundle) }
    puts 'Removing app from device 📲  => ' + udid
    _, status = Process.waitpid2(pid)

    if status.success?
      puts '❎   App ' + bundle + ' removed from ' + udid
    else
      showErrorMessage('Error while removing app')
      exit(1)
    end
  end
end
