# zork-godot

This is an implementation of the 1980 interactive fiction game Zork I built on the [Godot game engine](https://godotengine.org).

The ZIL (Zork Implementation Language) code [published by historicalsource](https://github.com/historicalsource/zork1) in 2019 served as a significant inspiration and source of reference. This project is not intended to be a direct port of that source, rather it serves as a proof of concept for building full-scale interactive fiction games using Godot.

The [ZIL Manual](https://archive.org/details/Learning_ZIL_Steven_Eric_Meretzky_1995/) published by Steven Eric Meretzky in 1995 and uploaded to the Internet Archive also served as a key source of reference.

## How Does It Work

### Game Loop
The `Game` scene functions as the primary entry point. It contains the entire game world, all UI elements, and the command parser. There is no main game loop. Instead all game logic is initiated by the `Prompt` scene firing a `command_submitted` event which it does in response to the `text_submitted` event from the standard `LineEdit` control.

From here the `Game` scene will pass the input text into the `CommandParser.parse_input` function along with a reference to the player. This function handles all tokenization and parsing logic and ultimately produces an array of `Command`s that represent a series of actions the player wishes to take. The `Game` will then execute each `Command` in turn and add the resulting response to the `ResponseHistory` interface. Finally, the `Game` will clear the previous input from the `Prompt` and await the player's next input.

### Command Execution
All matters of language processing are handled by the auto-loaded `Vocabulary` script. Upon initialization, this script will dynamically load all Command resources in the `res://commands` directory and populate a lookup map using the metadata defined on those resources. This metadata defines the surrounding structure of the input text required for this command (What prepositions are allowed, how many object references does this command need, etc). When the `CommandParser` produces a collection of commands, it does so by analyzing the player's input text and finding commands whose metadata define a matching structure.

In order to execute a command, the `Game` will get that command's Request Chain. A Request Chain is an array of `Callable` handlers that each have the opportunity to handle the command execution. In order, these handlers are:

1. `Player.action`
2. `Room.on_begin_command`
3. `Command.preaction`
4. First<sup>*</sup> Indirect Object `Thing.action`
5. First<sup>*</sup> Direct Object `Thing.action`
6. `Command.action`

<sub>* Additional objects after the first are ignored.</sub>

Each handler returns a response string. If that response is empty, execution passes to the next handler. If the response is not empty execution of the chain halts. After the chain has been processed, `Room.on_end_command` is called as a final handler before the response is returned and appended to the `ResponseHistory`.

:warning: When creating a new `Command` resource, make sure to update the `Script` reference in the inspector to point to the proper script in the `res://command_scripts` directory. Otherwise the default empty implementations of `Command.preaction` and `Command.action` will be called when the command is executed.

## License

Distributed under the MIT License. See [LICENSE.md](./LICENSE.md) for more information.
