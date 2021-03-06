require 'pathname'
require 'optimist'
require File.expand_path('simulator_manager/simulator', File.dirname(__FILE__))
require File.expand_path('simulator_manager/simulator_mgr', File.dirname(__FILE__))
require File.expand_path('simulator_manager/ui_message', File.dirname(__FILE__))

ui_message = UIMessage.new

opts = Optimist.options do
  opt :start, 'Boot a device with id', short: :s
  opt :shutdown, 'Shutdown a device with id', short: :w
  opt :install, 'Install app into device', short: :i
  opt :remove, 'Remove app from device', short: :r
  opt :app, 'Specify .app path <dir/to/My.app> scaped ', type: :string
  opt :device, 'Specify a device <3D077F6E-C82B-4DCD-A355-8ACA9AC43EF6>', type: :string
  opt :bundle, 'Specify app bundle id <br.com.myapp>', type: :string
  opt :list, 'List all devices', default: 'all'
end

if opts[:list]
  m = SimulatorManager.new
  m.list_devices(opts[:list])
end

if opts[:start]
  if !opts[:device].nil?
    m = SimulatorManager.new
    m.start_device(opts[:device])
  else
    ui_message.show_error_message('Not found required params --device')
  end
end

if opts[:shutdown]
  if !opts[:device].nil?
    m = SimulatorManager.new
    m.shutdown_device(opts[:device])
  else
    ui_message.show_error_message('Not found required params --device')
  end
end

if opts[:install]
  if !opts[:app].nil? && !opts[:device].nil?
    ui_message.show_warning_message('Not found bundle param. The application will not be reinstalled') if opts[:bundle].nil?
    m = SimulatorManager.new
    m.install_app(opts[:app], opts[:device], opts[:bundle])
  else
    ui_message.show_error_message('Not found required params --app && --device')
  end
end

if opts[:remove]
  if !opts[:device].nil? && !opts[:bundle].nil?
    m = SimulatorManager.new
    m.remove_application(opts[:device], opts[:bundle])
  else
    ui_message.show_error_message('Not found required params --device')
  end
end
