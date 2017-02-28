# SimulatorManager

## Usage

```bash
$ ./SimulatorManager --list
```
List all devices more easily and visibly then $ xcrun simtcl list

```bash
$ ./SimulatorManager --start <simulator udid>
```
Check if device is offline and start it

```bash
$ ./SimulatorManager --shutdown <simulator udid>
```
Check if device is online and shut down it

```bash
$ ./SimulatorManager --remove --device <simulator udid> --bundle <application bundle>
```
Search and remove the .app from specific simulator

```bash
$ ./SimulatorManager --install -app <path to .app> --device <simulator udid> --bundle <application bundle>
```
Install app on specific device and shut down it. If bundle param existis SimulatorManager will search and remove for app with same bundle id.

