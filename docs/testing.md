# Testing

## Game
- [ ] game.tscn loads as first scene

## UI
- [ ] By default, loads main menu
- [ ] Contains a state machine, representing different screens of ui (main menu, lobby, in-game, etc)
- [ ] On request, Has a way to allow the state to be changed
- [ ] When state is changed, ui state updates to reflect change
- [ ] By default, Debug log loads

### Debug Log
- [ ] By default, loads minimized
- [ ] On click, the debug log button toggles the log
- [ ] The debug log reflects all Log.* entries

### Main Menu
- [ ] By default, Host Server button loads
- [ ] By default, Connect to Server loads
- [ ] By default, IP box loads
- [ ] By default, IP in config.ini is loaded

#### Host Server Button
- [ ] By default, Loads as enabled
- [ ] On click, signals to start new server as host

#### Connect to Server Button
- [ ] By default, loads as enabled
- [ ] On click, sends contents of ip box in signal to connect to server

### Lobby
- [ ] When connection status changes, Player title reflects player connection status for connected players
- [ ] When connection status changes, player title reflects which player the client is connected to
- [ ] When connection status changes, Client player's color picker is enabled and others are disabled
- [ ] When color picker is changed, signal player's new color
- [ ] When connection status changes, Client player's ready button is enabled and others are disabled
- [ ] On click, the ready button signals the player's ready status
- [ ] When ready status changes, the ready buttons should reflect player ready status
- [ ] When disconnect button is clicked, the request is signalled

## Server
- [ ] By default, sets the mp peer to null
- [ ] On request, can connect to a remote server, given ip address
- [ ] On successful connection, broadcasts success signal
- [ ] On failed connection, broadcasts failure signal
- [ ] On request, can create a new server as host and connect to it
- [ ] On request, can disconnect to a connected server

## LocalSettings
- [ ] By default, loads the existing config file from user://
- [ ] if no existing file is found, create a default file
- [ ] On request, exposes config values
- [ ] On request, allows changes to config values
- [ ] On value change, config values are saved to file
