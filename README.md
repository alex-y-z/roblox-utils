# roblox-utils

A mishmash of strictly typed modules ranging from novelty trinkets to genuinely useful doodads for Roblox development.

I will let fate decide which is which for now.

### Modules

| Module         | Type    | Description                                |
|----------------|---------|--------------------------------------------|
| [Bezier]       | Class   | [Bézier curve] representation              |
| [Cache]        | Class   | Cache objects across modules               |
| [Rand]         | Class   | [Random] wrapper                           |
| [Semaphore]    | Class   | Manage shared resources                    |
| [Table]        | Library | Extension of the [table][table*] library   |
| [Timer]        | Class   | Track time and schedule events             |
| [Tween]        | Library | [TweenService] wrapper                     |

### Definitions

- **Class:** object-oriented data type instantiated with a constructor like `.new()`
- **Library:** collection of related functions 
- **Service:** singleton that imitates a [Roblox service], initialized with `:Start()`


[Bezier]: src/Bezier.luau
[Cache]: src/Cache.luau
[Rand]: src/Rand.luau
[Semaphore]: src/Semaphore.luau
[Table]: src/Table.luau
[Timer]: src/Timer.luau
[Tween]: src/Tween.luau

[Bézier curve]: https://en.wikipedia.org/wiki/B%C3%A9zier_curve
[Random]: https://create.roblox.com/docs/reference/engine/datatypes/Random
[table*]: https://create.roblox.com/docs/reference/engine/libraries/table
[TweenService]: https://create.roblox.com/docs/reference/engine/classes/TweenService
[Roblox service]: https://create.roblox.com/docs/scripting/services