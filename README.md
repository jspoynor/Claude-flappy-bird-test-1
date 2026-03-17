# Flappy Bird — Godot 4 Clone

A Flappy Bird clone built entirely with [Claude Code](https://claude.ai/claude-code) (no manual Godot editor use where avoidable). All scenes and scripts are plain text and can be edited directly.

---

## Requirements

| Tool | Version |
|---|---|
| [Godot Engine](https://godotengine.org/download) | 4.6.1 |

No plugins or third-party assets required (all visuals are sprite placeholders).

---

## Running the Game

1. Clone the repo.
2. Open Godot, click **Import**, and select the `project.godot` file.
3. Press **F5** (or the Play button) — the main scene (`MainMenu.tscn`) loads automatically.

**Controls**

| Key | Action |
|---|---|
| `Space` / `Enter` | Flap (in-game), Start (menu), Restart (game over) |

---

## How It Plays

1. **Title screen** — a bird flaps autonomously in the background. Your best score is shown if one exists. Press Space to start.
2. **Waiting state** — the bird is live but pipes haven't spawned yet. The score label shows your high score in gold (or 0 if none).
3. **Playing** — pipes spawn every 1.8 s. Pass through the gap to score. The score label turns gold whenever you beat your high score mid-run.
4. **Game over** — the bird ragdolls on collision. Final score and best score are shown. Press Space to restart.

High scores persist between sessions in `user://highscore.dat`.

---

## Project Structure

```
res://
├── project.godot               ← window (480×720), input map, entry scene = MainMenu.tscn
├── assets/
│   └── sprites/                ← wing-up / wing-down PNG sprites
├── scenes/
│   ├── Game.tscn               ← root game scene (Bird + Ground + PipeSpawner + HUD)
│   ├── entities/
│   │   ├── Bird.tscn           ← CharacterBody2D; sprite, circle collider, "bird" group
│   │   └── Pipe.tscn           ← Node2D; two StaticBody2D pipes + Area2D score zone
│   └── ui/
│       ├── MainMenu.tscn       ← title screen (bird preview + high score label)
│       └── HUD.tscn            ← score label + game-over panel (hidden by default)
└── scripts/
    ├── Game.gd                 ← state machine (WAITING → PLAYING → GAME_OVER)
    ├── Bird.gd                 ← gravity, flap, death detection, ragdoll, auto-flap
    ├── Pipe.gd                 ← scroll left, score signal
    ├── PipeSpawner.gd          ← timer-based spawn at random Y
    ├── HUD.gd                  ← update_score(), show_game_over()
    └── MainMenu.gd             ← reads high score file, transitions to Game.tscn
```

---

## Architecture

### State machine (`Game.gd`)

```
WAITING ──(Space)──► PLAYING ──(bird died)──► GAME_OVER
                                                  │
                              ◄──────(Space/reload_current_scene())─┘
```

- `bird.auto_flap = true` while WAITING keeps the preview alive without player input.
- `spawner.active` is the single gate that enables/disables pipe spawning.
- A 1.5 s delay after Space is pressed gives the player a moment before the first pipe appears.

### Scoring signal chain

```
Pipe.Area2D (ScoreZone)
  └─ body_entered → Pipe._on_score_zone_body_entered()
       └─ emits Pipe.scored signal
            └─ PipeSpawner._on_pipe_scored()
                 └─ Game.on_scored()  →  HUD.update_score()
```

### Death detection (`Bird.gd`)

- `get_slide_collision_count() > 0` after `move_and_slide()` — catches pipe and ground hits.
- `position.y < 0 or position.y > 730` — catches ceiling/floor escape.
- On death: emits `died` signal → `Game._on_bird_died()` transitions to GAME_OVER.

### High score persistence

Stored as a 4-byte unsigned int at `user://highscore.dat` (Godot's user data directory). Read on `_ready()` in both `Game.gd` and `MainMenu.gd`.

---

## Game Constants

| Constant | Value | File |
|---|---|---|
| Gravity | 1200 px/s² | `Bird.gd` |
| Flap force | −400 px/s | `Bird.gd` |
| Auto-flap target Y | 380 px | `Bird.gd` |
| Pipe scroll speed | −200 px/s | `Pipe.gd` |
| Gap size | 150 px | `Pipe.tscn` |
| Spawn interval | 1.8 s | `Game.tscn` SpawnTimer |
| Spawn X | 530 px | `PipeSpawner.gd` |
| Spawn Y range | 200–520 px | `PipeSpawner.gd` |

---

## Editing Tips

- **Scenes (`.tscn`)** and **scripts (`.gd`)** are plain text — edit them directly in any editor.
- `ExtResource` entries in `.tscn` files reference external scenes/scripts by path. `SubResource` entries are inline (shapes, materials).
- The `load_steps` header value in each `.tscn` = number of `ext_resource` + `sub_resource` entries + 1. Keep it accurate or Godot will warn on load.
- No binary assets aside from the two wing sprites — everything else is `ColorRect` / `StaticBody2D` primitives.
- The game cannot be verified without running Godot; after edits, open in Godot and press F5 to test.
