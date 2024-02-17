module g3

import gg
import time


@[heap]
pub struct CollidingEntities{
	pub mut:
	self &Entity
	other &Entity
}

@[heap]
pub struct Scene{
	pub mut:
	entities []&Entity
	life i64 = 1
}

pub fn game_create() &Scene {
	return &Scene{entities: []&Entity{}}
}
pub fn (mut g Scene) render(mut ctx gg.Context,frame time.Time) ! {
	for mut e in g.entities {
		e.render(mut ctx,frame)!
	}
}
pub fn (g Scene) is_finished(ctx gg.Context,frame time.Time) bool { return g.life <= 0 }
pub fn (mut g Scene) animate(ctx gg.Context,kb_state map[gg.KeyCode]u32 ,frame time.Time) ! {
	for mut e in g.entities {
		p  := e.position
		t := e.current_frame
		e.animate(ctx,mut &g,kb_state,frame)!
		e.prev_position = p
		e.prev_frame = t
	}
}
pub fn (g Scene) do_collisions() {
	mut colliding:=[][]int{}
	for i,a in g.entities {
		for j in i+1 .. g.entities.len {
			b:= g.entities[j]
			if a.get_box().intersects(b.get_box()) {
				colliding << [i,j]
			}
		}
	}
	for mut collision in colliding {
		mut a:= g.entities[collision[0]]
		mut b:= g.entities[collision[1]]
		a.on_collision(mut b)
	}
}
pub fn (mut g Scene) collect_dead_entities(ctx gg.Context,frame time.Time) ! {
	mut dead_entities:=[]int{}
	for i,mut e in g.entities {
		if e.is_finished(ctx,frame) {
			dead_entities << i
		}
	}
	for i in dead_entities{
		g.entities.delete(i)
	}
}
pub fn (mut g Scene) add_entity(mut e &Entity) {
	e.game_ref=g
	g.entities << e
}
