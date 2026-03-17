# CLAUDE.md — Flappy Bird (Godot 4.6.1)

## Project Overview
Proof-of-concept Flappy Bird clone built entirely via Claude Code (no manual Godot editor use where avoidable).

## Tech Stack
- **Engine:** Godot 4.6.1
- **Language:** GDScript
- **Renderer:** GL Compatibility
- **Window:** 480 × 720 px

## File Structure
```
res://
├── project.godot               ← window size, input map, main scene = MainMenu.tscn
├── scenes/
│   ├── Game.tscn               ← root game scene (Bird + Ground + PipeSpawner + HUD)
│   ├── entities/
│   │   ├── Bird.tscn           ← CharacterBody2D, yellow rect visual, circle collider
│   │   └── Pipe.tscn           ← Node2D, two StaticBody2D pipes + Area2D score zone
│   └── ui/
│       ├── MainMenu.tscn       ← title screen, Space to start
│       └── HUD.tscn            ← score label + game-over panel (hidden by default)
└── scripts/
    ├── Game.gd                 ← state machine: PLAYING / GAME_OVER
    ├── Bird.gd                 ← gravity, flap, death detection
    ├── Pipe.gd                 ← left scroll, score signal
    ├── PipeSpawner.gd          ← 1.8s timer, random y spawn 200–520
    └── HUD.gd                  ← update_score(), show_game_over()
```

## Game Constants
| Constant | Value | Location |
|---|---|---|
| Gravity | 1200 px/s² | Bird.gd |
| Flap force | -400 px/s | Bird.gd |
| Pipe scroll speed | -200 px/s | Pipe.gd |
| Gap size | 150 px | Pipe.tscn (TopBody y=-235, BottomBody y=+235) |
| Spawn interval | 1.8 s | Game.tscn SpawnTimer |
| Spawn X | 530 px | PipeSpawner.gd |
| Spawn Y range | 200–520 px | PipeSpawner.gd |

## Architecture Notes
- **Death detection:** `get_slide_collision_count() > 0` after `move_and_slide()` covers pipe and ground hits; y-bounds check covers ceiling/floor escape.
- **Scoring:** Pipe's `Area2D` ScoreZone fires `body_entered` → checks `is_in_group("bird")` → emits `scored` → PipeSpawner relays to `Game.on_scored()`.
- **State gating:** `Bird.active` and `PipeSpawner.active` booleans are set by `Game.gd` on state transitions.
- **Restart:** `get_tree().reload_current_scene()` in Game.gd GAME_OVER state.

## Input
- **Space / Enter** — flap (in-game), start (menu), restart (game over)
  Configured via Godot's built-in `ui_accept` action.

## Claude Code Workflow Notes
- Edit `.gd` scripts and `.tscn` scene files directly — both are plain text.
- `.tscn` files use `ExtResource` for scene/script refs and `SubResource` for inline shapes. Keep IDs consistent within each file.
- `load_steps` in `.tscn` header = number of ext_resources + sub_resources + 1.
- No binary assets used — all visuals are `ColorRect` placeholders.
- Cannot run the game to verify; user must test in Godot and report errors.

## Commit Discipline
- **Before each prompt:** run `git status`; if there are uncommitted changes, commit them before proceeding.
- **After each prompt:** once the work is complete, create a commit.
