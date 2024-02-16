module g3

import gg
import time



@[heap]
pub struct Scene{
	pub mut:
	entities []&Entity
	life u8 = 1
}

pub fn game_create() &Scene {
	return &Scene{entities: []&Entity{}}
}
pub fn (mut g Scene) render(mut ctx gg.Context,frame time.Time) ! {
	for mut e in g.entities {
		e.render(mut ctx,frame)!
	}
}
pub fn (g Scene) is_finished(ctx gg.Context,frame time.Time) bool { return g.life == 0 }
pub fn (mut g Scene) animate(ctx gg.Context,kb_state map[gg.KeyCode]u32 ,frame time.Time) ! {
	for mut e in g.entities {
		e.animate(ctx,mut &g,kb_state,frame)!
	}
}
pub fn (mut g Scene) collect_dead_entities(ctx gg.Context,frame time.Time) ! {
	mut new_entities:=[]&Entity{}
	for mut e in g.entities {
		if ! e.is_finished(ctx,frame) {
			new_entities << e
		}
	}
	g.entities=new_entities
}
pub fn (mut g Scene) add_entity(mut e &Entity) {
	e.game_ref=g
	g.entities << e
}
