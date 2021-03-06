require "open3"
require "colorize"
require File.dirname(__FILE__) + "/simulator"
require File.dirname(__FILE__) + "/ui_message"
require File.dirname(__FILE__) + "/simulators_provider"
require File.dirname(__FILE__) + "/simctl_query_builder"
require File.dirname(__FILE__) + "/process_runner"

class SimulatorManager
  attr_accessor :simulators
  attr_accessor :ui_message
  attr_accessor :simulators_provider
  attr_accessor :simctl_query_builder
  attr_accessor :process_runner

  def initialize(simulators_provider = SimulatorsProvider.new,
    ui_message = UIMessage.new,
    simctl_query_builder = SimctlQueryBuilder.new,
    process_runner = ProcessRunner.new)
    @simulators = []
    @ui_message = ui_message
    @simulators_provider = simulators_provider
    @simctl_query_builder = simctl_query_builder
    @process_runner = process_runner
    create_simulators
  end

  def list_devices(name_filter)
    filtered = simulators

    filtered = simulators.select { |simulator| simulator.name.include? name_filter } if name_filter != "all"

    ui_message.show_error_message("No simulator was found with provided name filter") if filtered.empty?

    filtered.each do |simulator|
      puts ""
      puts "udid => " + simulator.udid.to_s.green
      puts "name => " + simulator.name.to_s.yellow

      if simulator.booted == false
        puts "booted => " + simulator.booted.to_s.red
      else
        puts "booted => " + simulator.booted.to_s.green
      end

      if simulator.booted == false
        puts "available => " + simulator.available.to_s.red
      else
        puts "available => " + simulator.available.to_s.green
      end
    end
  end

  def start_device(udid)
    simulator = find_simulator_by_udid(udid)

    if simulator.booted
      ui_message.show_error_message("Simulator already booted")
    else
      command = simctl_query_builder.build_command("boot", udid)

      process = process_runner.create_process(command)

      succeed = process_runner.wait_process_execution(process)

      if succeed
        ui_message.show_success_message("Device booted " + udid)
      else
        ui_message.show_error_message("Error while booting the device")
      end
    end
  end

  def shutdown_device(udid)
    simulator = find_simulator_by_udid(udid)

    ui_message.show_warning_message("Simulator already offline") if simulator.booted == false

    pid = fork { exec("xcrun simctl shutdown " + udid) }
    puts "Turning off device 📲  => " + udid
    _, status = Process.waitpid2(pid)

    if status.success?
      ui_message.show_success_message("Device offline " + udid)
    else
      ui_message.show_error_message("Error while Turning off the device")
      exit(1)
    end
  end

  def install_app(path, udid, bundle)
    puts "SimulatorManager => Path => " + path
    puts "SimulatorManager => udid => " + udid

    simulator = find_simulator_by_udid(udid)

    start_device(simulator.udid) if simulator.booted == false

    unless bundle.nil?
      puts "SimulatorManager => bundle => " + bundle
      if !find_application_in_simulator(simulator.udid, bundle).empty?
        puts ui_message.show_success_message("Removing application")
        remove_application_from_simulator(simulator.udid, bundle)
      else
        ui_message.show_error_message("Application not found")
      end
    end
    puts "SimulatorManager => Next command => " + 'xcrun simctl install "' + simulator.udid + '" "' + path + '"'
    pid = fork { exec('xcrun simctl install "' + simulator.udid + '" "' + path + '"') }
    puts "Please wait for the installation 📲 ..."
    _, status = Process.waitpid2(pid)

    if status.success?
      ui_message.show_success_message("APPLICATION INSTALLED INTO " + simulator.udid)
      ui_message.show_success_message(path)
      shutdown_device(simulator.udid)
    else
      ui_message.show_error_message("Error while installing the app into simulator.")
      exit(1)
    end
  end

  def remove_application(udid, bundle)
    simulator = find_simulator_by_udid(udid)

    if !find_application_in_simulator(udid, bundle).empty?
      puts ui_message.show_success_message("Removing application")
      remove_application_from_simulator(udid, bundle)
    else
      ui_message.show_error_message("App not found into simulator " + udid)
    end
  end

  def find_simulator_by_udid(udid)
    simulator = simulators.find { |simulator| simulator.udid == udid }

    if simulator.nil?
      ui_message.show_error_message("Simulator not found")
      exit(1)
    end

    simulator
  end

  private

  def create_simulators
    devices = simulators_provider.simulators_json

    devices["devices"].each do |_runtime, runtime_devices|
      runtime_devices.each do |device|
        @simulators << Simulator.new(device["name"], device["udid"], device["state"], device["availability"])
      end
    end
  end

  def find_application_in_simulator(udid, bundle)
    stdout, status = Open3.capture2("xcrun simctl get_app_container " + udid + " " + bundle)
    stdout
  end

  def remove_application_from_simulator(udid, bundle)
    pid = fork { exec("xcrun simctl uninstall " + udid + " " + bundle) }
    puts "Removing app from device 📲  => " + udid
    _, status = Process.waitpid2(pid)

    if status.success?
      puts "❎   App " + bundle + " removed from " + udid
    else
      ui_message.show_error_message("Error while removing app")
      exit(1)
    end
  end
end
