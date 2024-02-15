module g3

import gg
import gx
import math
import rand
import time


pub type EventListener = fn(mut self &ReactiveShapeEntity, ev &gg.Event)
pub type EntityAnimation = fn(mut self &ReactiveShapeEntity, ctx gg.Context, frame time.Time)
pub type ShapeDrawer = fn(self ReactiveShapeEntity, ctx gg.Context,frame time.Time)
@[heap]
pub struct ReactiveShapeEntity{
	id string=rand.uuid_v4()
	pub mut:
	game_ref &Scene = unsafe{nil}
	position Vector2d
	radius f64
	color gg.Color
	speed_vector Vector2d
	current_frame time.Time
	animations []EntityAnimation
	event_listeners map[string][]EventListener
	draw_shape ShapeDrawer
}
pub fn (e ReactiveShapeEntity) render(ctx gg.Context,frame time.Time) ! {
	//ctx.draw_circle_filled(f32(e.position.x),f32(e.position.y),f32(e.radius),e.color)
	e.draw_shape(e,ctx,frame)
}
pub fn (e ReactiveShapeEntity) is_finished(ctx gg.Context,frame time.Time) bool { return false }
pub fn (mut e ReactiveShapeEntity) animate(ctx gg.Context,frame time.Time) ! {
	for a in e.animations {
		a(mut &e, ctx, frame)
	}
}
pub fn (e ReactiveShapeEntity) get_box() Box{
	return Box{
		position: Vector2d{
			x: e.position.x-e.radius
			y: e.position.y-e.radius
			z: e.position.z-e.radius
		}
		size: Vector2d{
			x: 2*e.radius
			y: 2*e.radius
			z: 2*e.radius
		}
	}
}
pub fn (mut e ReactiveShapeEntity) dispatch_event(ev &gg.Event){
	listeners:=e.event_listeners[ev.typ.str()] or { []EventListener{} }
	if listeners.len>0 {
		for listener in listeners {
			listener(mut &e,ev)
		}
	}
}
pub fn create_test_ball() &ReactiveShapeEntity {
	return &ReactiveShapeEntity{
		position: Vector2d{
			x: 10.0
			y: 10.0
		}
		radius: 10.0
		speed_vector: Vector2d{1,1,0}
		color: gx.color_from_string("#CC3300")
	}
}
pub fn init_test_ball() ReactiveShapeEntity {
	return ReactiveShapeEntity{
		position: Vector2d{
			x: 0.0
			y: 0.0
		}
		radius: 10
		speed_vector: Vector2d{1,1,0}
		color: gx.color_from_string("#CC3300")
	}
}
