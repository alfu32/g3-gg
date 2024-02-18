module g3

import gg
import gx
import rand
import time


pub type EventListener = fn(mut self &ReactiveShapeEntity, ev &gg.Event)
pub type AnimationFunction = fn(mut self &ReactiveShapeEntity,mut scene &Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context, frame time.Time)
pub type EntityKeyboardAnimationFunction = fn(mut self &ReactiveShapeEntity,kb_state map[gg.KeyCode]u32)
pub type EntityAnimationFunction = fn(mut self &ReactiveShapeEntity, frame time.Time)
pub type ContextAnimationFunction = fn(mut self &ReactiveShapeEntity,ctx gg.Context, frame time.Time)
pub type ContextKeyboardAnimationFunction = fn(mut self &ReactiveShapeEntity,kb_state map[gg.KeyCode]u32,ctx gg.Context, frame time.Time)
pub type SceneAnimationFunction = fn(mut self &ReactiveShapeEntity,mut scene &Scene, frame time.Time)
pub type SceneKeyboardAnimationFunction = fn(mut self &ReactiveShapeEntity,mut scene &Scene,kb_state map[gg.KeyCode]u32)
pub type EntityAnimation = AnimationFunction | EntityKeyboardAnimationFunction | EntityAnimationFunction |
	ContextAnimationFunction | ContextKeyboardAnimationFunction | SceneAnimationFunction |
	SceneKeyboardAnimationFunction
pub type ShapeDrawer = fn(self ReactiveShapeEntity,mut ctx gg.Context,frame time.Time)


@[heap]
pub struct ReactiveShapeEntity{
	id string=rand.uuid_v4()
	pub mut:
	prev_position Vector2d
	position Vector2d
	prev_frame time.Time
	current_frame time.Time
	game_ref &Scene = unsafe{nil}
	radius f64
	color gg.Color
	speed_vector Vector2d
	life i64 = 1000
	animations []EntityAnimation
	event_listeners map[string][]EventListener
	draw_shape ShapeDrawer
}
pub fn (e ReactiveShapeEntity) get_actual_speed() Vector2d{
	a:=e.prev_position
	b:=e.position
	return Vector2d{
		x: b.x-a.x
		y: b.y-a.y
		z: b.z-a.z
	}
}
pub fn (e ReactiveShapeEntity) render(mut ctx gg.Context,frame time.Time) ! {
	//ctx.draw_circle_filled(f32(e.position.x),f32(e.position.y),f32(e.radius),e.color)

	e.draw_shape(e,mut ctx,frame)
}
pub fn (e ReactiveShapeEntity) is_finished(ctx gg.Context,frame time.Time) bool { return e.life < 0 }
pub fn (mut e ReactiveShapeEntity) animate(ctx gg.Context,mut scene &Scene,kb_state map[gg.KeyCode]u32,frame time.Time) ! {
	for a in e.animations {
		match a {
			AnimationFunction {
				a(mut &e,mut scene, kb_state, ctx, frame)
			}
			EntityKeyboardAnimationFunction {
				a(mut &e,kb_state)
			}
			EntityAnimationFunction {
				a(mut &e, frame)
			}
			ContextAnimationFunction {
				a(mut &e,ctx, frame)
			}
			ContextKeyboardAnimationFunction {
				a(mut &e,kb_state, ctx, frame)
			}
			SceneAnimationFunction {
				a(mut &e,mut scene, frame)
			}
			SceneKeyboardAnimationFunction {
				a(mut &e,mut scene, kb_state)
			}
		}
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
pub fn (e ReactiveShapeEntity) copy() &ReactiveShapeEntity{
	return &ReactiveShapeEntity{
		id: rand.uuid_v4()
		game_ref: e.game_ref
		position: e.position.copy()
		radius: e.radius
		color: e.color
		speed_vector: e.speed_vector.copy()
		current_frame: e.current_frame
		animations: e.animations
		event_listeners: e.event_listeners
		draw_shape: e.draw_shape
		life: e.life
	}
}
pub fn (mut e ReactiveShapeEntity) on_collision(mut other &Entity) {
	match other {
		ReactiveShapeEntity{
			tl := e.life
			ol := other.life
			e.life = tl-1
			other.life = ol - 1
		}
		else{

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
