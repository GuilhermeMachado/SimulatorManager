require 'open3'
require 'colorize'

class SimulatorManager

  attr_accessor :simulators

  def initialize()
    @simulators = Array.new
    createSimulators()
  end

  def listDevices()
    @simulators.each do |simulator|
        puts ""
        puts "udid => " + "#{simulator.udid}".green
        puts "name => " + "#{simulator.name}".yellow
        
        if simulator.booted == false 
          puts "booted => " + "#{simulator.booted}".red 
        else
          puts "booted => " + "#{simulator.booted}".green 
        end

        if simulator.booted == false 
          puts "available => " + "#{simulator.available}".red 
        else
          puts "available => " + "#{simulator.available}".green 
        end
    end
  end

  def self.list()
    m = SimulatorManager.new
    m.listDevices()
  end

  def startDevice(udid)

    simulator = findSimulatorByUdid(udid)

    if simulator.booted == true
      showErrorMessage("Simulator already booted")
      exit(1)
    end

    pid = fork { exec("xcrun simctl boot " + udid) }
    puts "Booting device 📲  => " + udid
    _, status = Process.waitpid2(pid)

    unless status.success?
      showErrorMessage("Error while booting the device")
      exit(1)
    else
      showSuccessMessage("Device booted " + udid)
    end

  end

  def shutdownDevice(udid)

    simulator = findSimulatorByUdid(udid)

    if simulator.booted == false
      showWarningMessage("Simulator already offline")
    end

    pid = fork { exec("xcrun simctl shutdown " + udid) }
    puts "Turning off device 📲  => " + udid
    _, status = Process.waitpid2(pid)

    unless status.success?
      showErrorMessage("Error while Turning off the device")
      exit(1)
    else
      showSuccessMessage("Device offline " + udid)
    end

  end

  def installApp(path, udid, bundle)
    puts "SimulatorManager => Path => " + path
    puts "SimulatorManager => udid => " + udid

    simulator = findSimulatorByUdid(udid)

    if simulator.booted == false
      startDevice(simulator.udid)
    end

    if bundle != nil
      puts "SimulatorManager => bundle => " + bundle
      if !findAppInSimulator(simulator.udid, bundle).empty?
        puts showSuccessMessage("App localizado")
        removeAppFromSimulator(simulator.udid, bundle)
      else
        showErrorMessage("App não localizado")
      end
    end
    puts "SimulatorManager => Next command => " + "xcrun simctl install \"" + simulator.udid + "\" \"" + path + "\""
    pid = fork { exec("xcrun simctl install \"" + simulator.udid + "\" \"" + path + "\"") }
    puts "Please wait for the installation 📲 ..."
    _, status = Process.waitpid2(pid)

    unless status.success?
      showErrorMessage("Error while installing the app into simulator.")
      exit(1)
    else
      showSuccessMessage("APPLICATION INSTALLED INTO " + simulator.udid)
      showSuccessMessage(path)
      shutdownDevice(simulator.udid)
    end

  end

  def removeApp(udid, bundle)

    simulator = findSimulatorByUdid(udid)

    if !findAppInSimulator(udid, bundle).empty?
      puts showSuccessMessage("App localizado")
      removeAppFromSimulator(udid, bundle)
    else
      showErrorMessage("App not found into simulator " + udid)
    end

  end

  private

  def createSimulators()

    devices = JSON.parse `xcrun simctl list -j devices`

    devices['devices'].each do |runtime, runtime_devices|
      runtime_devices.each do |device|
        @simulators << Simulator.new(device['name'],device['udid'],device['state'],device['availability'])
      end
    end

  end

  def findSimulatorByUdid(udid)

    simulator = simulators.select {|simulator| simulator.udid == udid}.first

    if simulator == nil
      showErrorMessage("Simulator not found")
      exit(1)
    end

    return simulator

  end

  def findAppInSimulator(udid, bundle)
    stdout, status = Open3.capture2("xcrun simctl get_app_container " + udid + " " + bundle)
    return stdout
  end

  def removeAppFromSimulator(udid, bundle)

    pid = fork { exec("xcrun simctl uninstall " + udid + " " + bundle) }
    puts "Removing app from device 📲  => " + udid
    _, status = Process.waitpid2(pid)

    unless status.success?
      showErrorMessage("Error while removing app")
      exit(1)
    else
      puts "❎   App " + bundle + " removed from " + udid
    end

  end

end
