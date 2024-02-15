module g3

import gg
import time

@[heap]
pub interface Entity{
	mut:
		game_ref &Game
		is_finished(ctx gg.Context,frame time.Time) bool
		render(ctx gg.Context,frame time.Time) !
		animate(ctx gg.Context,frame time.Time) !
		dispatch_event(ev &gg.Event)
		get_box() Box
}

@[heap]
pub struct Game{
	pub mut:
	entities []&Entity
}

pub fn game_create() &Game {
	return &Game{entities: []&Entity{}}
}
pub fn (mut g Game) render(ctx gg.Context,frame time.Time) ! {
	for mut e in g.entities {
		e.render(ctx,frame)!
	}
}
pub fn (g Game) is_finished(ctx gg.Context,frame time.Time) bool { return false }
pub fn (mut g Game) animate(ctx gg.Context,frame time.Time) ! {
	for mut e in g.entities {
		e.animate(ctx,frame)!
	}
}
pub fn (mut g Game) collect_dead_entities(ctx gg.Context,frame time.Time) ! {
	mut new_entities:=[]&Entity{}
	for mut e in g.entities {
		if ! e.is_finished(ctx,frame) {
			new_entities << e
		}
	}
	g.entities=new_entities
}
pub fn (mut g Game) add_entity(mut e &Entity) {
	e.game_ref=g
	g.entities << e
}
