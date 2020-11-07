require 'json'

class SimulatorsProvider
  def simulators_json
    JSON.parse `xcrun simctl list -j devices`
  end
end
