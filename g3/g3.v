module g3

import gg
import time

@[heap]
pub interface Entity{
	mut:
		game_ref &Scene
		is_finished(ctx gg.Context,frame time.Time) bool
		render(ctx gg.Context,frame time.Time) !
		animate(ctx gg.Context,frame time.Time) !
		dispatch_event(ev &gg.Event)
		get_box() Box
}

