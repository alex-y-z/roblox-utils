# roblox-utils

A mishmash of modules ranging from novelty trinkets to genuinely useful doodads for Roblox development.

I will let fate decide which is which for now.

### Modules

| Module         | Type    | Description                                |
|----------------|---------|--------------------------------------------|
| [Cache]        | Class   | Cache objects across modules               |
| [Rand]         | Class   | [Random] wrapper                           |
| [Semaphore]    | Class   | Manage shared resources                    |
| [StrokeScaler] | Service | Dynamically scale [UIStroke] thickness     |
| [Table]        | Utility | Extension of the [table][tableLib] library |
| [Timer]        | Class   | Track time and schedule events             |
| [Tween]        | Utility | [TweenService] wrapper                     |

### Definitions

- **Class:** object-oriented data type instantiated with a constructor like `.new()`
- **Service:** singleton that imitates a [Roblox service], initialized with `:Start()`
- **Utility:** library of functions 


[Cache]: src/Cache.luau
[Rand]: src/Rand.luau
[Semaphore]: src/Semaphore.luau
[StrokeScaler]: src/ui/StrokeScaler.luau
[Table]: src/Table.luau
[Timer]: src/Timer.luau
[Tween]: src/Tween.luau

[Random]: https://create.roblox.com/docs/reference/engine/datatypes/Random
[UIStroke]: https://create.roblox.com/docs/reference/engine/classes/UIStroke
[tableLib]: https://create.roblox.com/docs/reference/engine/libraries/table
[TweenService]: https://create.roblox.com/docs/reference/engine/classes/TweenService
[Roblox service]: https://create.roblox.com/docs/scripting/services