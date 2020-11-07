require 'json'

class SimulatorsProviderStub
  attr_accessor :json_string

  def initialize(json_string)
    @json_string = json_string
  end

  def simulators_json
    JSON.parse(File.read(json_string))
  end
end
