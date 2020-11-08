

# SimulatorManager [![build](https://github.com/GuilhermeMachado/SimulatorManager/workflows/build/badge.svg)](https://github.com/GuilhermeMachado/SimulatorManager/actions)

## Usage

```bash
$ ruby simulator_manager.rb --list
```
List all devices more easily and visibly then $ xcrun simtcl list

```bash
$ ruby simulator_manager.rb --list iPhone
```
Filter by simulator name

```bash
$ ruby simulator_manager.rb --start <simulator udid>
```
Check if the device is offline and start it

```bash
$ ruby simulator_manager.rb --shutdown <simulator udid>
```
Check if the device is online and shut down it

```bash
$ ruby simulator_manager.rb --remove --device <simulator udid> --bundle <application bundle>
```
Search and remove the .app from a specific simulator

```bash
$ ruby simulator_manager.rb --install -app <path to .app> --device <simulator udid> --bundle <application bundle>
```
Install an app on a specific device and shut down it. If there is a bundle param, SimulatorManager will search and remove the app with the same bundle id.

