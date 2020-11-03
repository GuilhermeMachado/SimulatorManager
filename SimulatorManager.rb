require 'pathname'
require 'optimist'
require './Simulator'
require './SimulatorMgr'

#### Main
def showErrorMessage(message)
  puts "❌   #{message}".red
end

def showSuccessMessage(message)
  puts "✅   #{message}".green
end

def showWarningMessage(message)
  puts "⚠️   #{message}".yellow
end

opts = Optimist::options do
  opt :start, "Boot a device with id", :short => :s
  opt :shutdown, "Shutdown a device with id", :short => :w
  opt :install, "Install app into device", :short => :i
  opt :remove, "Remove app from device", :short => :r
  opt :app, "Specify .app path <dir/to/My.app> scaped ", :type => :string
  opt :device, "Specify a device <3D077F6E-C82B-4DCD-A355-8ACA9AC43EF6>", :type => :string
  opt :bundle, "Specify app bundle id <br.com.myapp>", :type => :string
  opt :list, "List all devices", :default => "all"
end

if opts[:list]
  m = SimulatorManager.new
  m.listDevices(opts[:list])
end

if opts[:start]
  if opts[:device] != nil
    m = SimulatorManager.new
    m.startDevice(opts[:device])
  else
    showErrorMessage("Not found required params --device")
  end
end

if opts[:shutdown]
  if opts[:device] != nil
    m = SimulatorManager.new
    m.shutdownDevice(opts[:device])
  else
    showErrorMessage("Not found required params --device")
  end
end

if opts[:install]
  if opts[:app] != nil && opts[:device] != nil
    if opts[:bundle] == nil
      showWarningMessage("Not found bundle param. The application will not be reinstalled")
    end
    m = SimulatorManager.new
    m.installApp(opts[:app], opts[:device], opts[:bundle])
  else
    showErrorMessage("Not found required params --app && --device")
  end
end

if opts[:remove]
  if opts[:device] != nil && opts[:bundle] != nil
    m = SimulatorManager.new
    m.removeApp(opts[:device], opts[:bundle])
  else
    showErrorMessage("Not found required params --device")
  end
end
