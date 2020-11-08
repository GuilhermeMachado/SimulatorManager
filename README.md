[![test](https://github.com/GuilhermeMachado/SimulatorManager/workflows/test/badge.svg)](https://github.com/GuilhermeMachado/SimulatorManager/actions)

# SimulatorManager

## Usage

```bash
$ ruby SimulatorManager.rb --list
```
List all devices more easily and visibly then $ xcrun simtcl list

```bash
$ ruby SimulatorManager.rb --list iPhone
```
Filter by simulator name

```bash
$ ruby SimulatorManager.rb --start <simulator udid>
```
Check if device is offline and start it

```bash
$ ruby SimulatorManager.rb --shutdown <simulator udid>
```
Check if device is online and shut down it

```bash
$ ruby SimulatorManager.rb --remove --device <simulator udid> --bundle <application bundle>
```
Search and remove the .app from specific simulator

```bash
$ ruby SimulatorManager.rb --install -app <path to .app> --device <simulator udid> --bundle <application bundle>
```
Install app on specific device and shut down it. If bundle param existis SimulatorManager will search and remove for app with same bundle id.

