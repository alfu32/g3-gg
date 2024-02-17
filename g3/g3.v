module g3

import gg
import time

@[heap]
pub interface Entity{
	get_box() Box
	mut:
		game_ref &Scene
		position Vector2d
		prev_position Vector2d
		current_frame time.Time
		prev_frame time.Time
		life i64
		on_collision(mut other &Entity)
		is_finished(ctx gg.Context,frame time.Time) bool
		render(mut ctx gg.Context,frame time.Time) !
		animate(ctx gg.Context,mut scene &Scene,kb_state map[gg.KeyCode]u32,frame time.Time) !
		dispatch_event(ev &gg.Event)
}

