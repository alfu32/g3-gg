module main

import gx
import g3
import time
import math
import gg
fn reactive_shape_animation__move_up_on_key(key_code gg.KeyCode) g3.EntityAnimation{
	return fn[key_code](mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context,frame time.Time) {
		if key_code in kb_state.keys() {
			e.position.y-=e.speed_vector.y
		}
	}
}
fn reactive_shape_animation__move_down_on_key(key_code gg.KeyCode)  g3.EntityAnimation{
	return fn[key_code](mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context,frame time.Time) {
		if key_code in kb_state.keys() {
			e.position.y+=e.speed_vector.y
		}
	}
}
fn reactive_shape_animation__move_left_on_key(key_code gg.KeyCode)  g3.EntityAnimation{
	return fn[key_code](mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context,frame time.Time) {
		if key_code in kb_state.keys() {
			e.position.x-=e.speed_vector.x
		}
	}
}
fn reactive_shape_animation__move_right_on_key(key_code gg.KeyCode)  g3.EntityAnimation{
	return fn[key_code](mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context,frame time.Time) {
		if key_code in kb_state.keys() {
			e.position.x+=e.speed_vector.x
		}
	}
}

fn reactive_shape__create_object_on_key(key_code gg.KeyCode,prototype g3.ReactiveShapeEntity)g3.EntityAnimation{
	return fn[key_code,prototype](mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context,frame time.Time) {
		if key_code in kb_state.keys() {
			mut cp := prototype.copy()
			cp.position=e.position.copy()
			scene.add_entity(mut cp)
		}
	}
}
fn main() {
	mut app:=&g3.App{
		scene: g3.game_create()
	}
	app.init_ctx(
		gx.rgb(174, 198, 255),
		600,
		400,
		'Polygons',
	)
	app.scene.add_entity(mut &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 10.0
			y: 10.0
		}
		radius: 10.0
		speed_vector: g3.Vector2d{5,5,0}
		color: gx.color_from_string("#CC3300")
		draw_shape:fn(self g3.ReactiveShapeEntity,mut ctx gg.Context,frame time.Time){
			ctx.draw_circle_filled(f32(self.position.x),f32(self.position.y),f32(self.radius),self.color)
		}
		animations: [
			fn(mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32,ctx gg.Context,frame time.Time) {
				//e.radius=10.0+5*f64(frame.unix & u8(0x40))/64.0
				e.position.x+=e.speed_vector.x
				if e.position.x < 0 {
					e.position.x=0
					e.speed_vector.x*=-1
				}
				if e.position.x > ctx.width-e.radius {
					e.position.x=ctx.width-e.radius
					e.speed_vector.x*=-1
				}
				e.position.y+=e.speed_vector.y
				if e.position.y < 0 {
					e.position.y=0
					e.speed_vector.y*=-1
				}
				if e.position.y > ctx.height-e.radius {
					e.position.y=ctx.height-e.radius
					e.speed_vector.y*=-1
				}
			}
		]
	})


	mut player2 := &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 80.0
			y: 30.0
		}
		radius: 10.0
		speed_vector: g3.Vector2d{6,6,0}
		color: gx.color_from_string("#0033CC")
		draw_shape:fn(self g3.ReactiveShapeEntity,mut ctx gg.Context,frame time.Time){
			ctx.draw_text(int(self.position.x-2*self.radius),int(self.position.y-2*self.radius-10),"life:${self.life}",gx.TextCfg{color:gx.color_from_string("#333333")})
			ctx.draw_rect_filled(f32(self.position.x-self.radius),f32(self.position.y-self.radius),f32(2*self.radius),f32(2*self.radius),self.color)
		}
		animations: [
			fn(mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context,frame time.Time) {
				//e.radius=10.0+5*f64(frame.unix & u8(0x40))/64.0
				e.position.x+=e.speed_vector.x
				if e.position.x < 0 {
					e.position.x=0
					e.speed_vector.x*=-1
				}
				if e.position.x > ctx.width-e.radius {
					e.position.x=ctx.width-e.radius
					e.speed_vector.x*=-1
				}
				e.position.y+=e.speed_vector.y
				if e.position.y < 0 {
					e.position.y=0
					e.speed_vector.y*=-1
				}
				if e.position.y > ctx.height-e.radius {
					e.position.y=ctx.height-e.radius
					e.speed_vector.y*=-1
				}
			}
		]
	}
	player2.event_listeners['key_down'] = [
		fn(mut e &g3.ReactiveShapeEntity, ev &gg.Event){
			if ev.key_code == gg.KeyCode._8 {
				e.speed_vector.y-=1
			}
			if ev.key_code == gg.KeyCode._2 {
				e.speed_vector.y+=1
			}
			if ev.key_code == gg.KeyCode._4 {
				e.speed_vector.x-=1
			}
			if ev.key_code == gg.KeyCode._6 {
				e.speed_vector.x+=1
			}
		}
	]
	app.scene.add_entity(mut player2)



	mut bullet := &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 80.0
			y: 30.0
		}
		radius: 3.0
		speed_vector: g3.Vector2d{7,1,0}
		color: gx.color_from_string("#333377")
		draw_shape:fn(self g3.ReactiveShapeEntity, mut ctx gg.Context,frame time.Time){
			ctx.draw_rect_filled(f32(self.position.x),f32(self.position.y),f32(10),f32(3),self.color)
		}
		animations: [
			fn(mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context,frame time.Time) {
				e.position.x+=e.speed_vector.x
				if e.position.x < 0 {
					e.position.x=0
					e.speed_vector.x*=-1
				}
				if e.position.x > ctx.width-e.radius {
					e.position.x=ctx.width-e.radius
					e.speed_vector.x*=-1
				}
				e.position.y+=e.speed_vector.y
				if e.position.y < 0 {
					e.position.y=0
					e.speed_vector.y*=-1
				}
				if e.position.y > ctx.height-e.radius {
					e.position.y=ctx.height-e.radius
					e.speed_vector.y*=-1
				}
			}
		]
	}
	mut player1 := &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 80.0
			y: 30.0
		}
		radius: 10.0
		speed_vector: g3.Vector2d{7,7,0}
		color: gx.color_from_string("#00CC33")
		draw_shape:fn(self g3.ReactiveShapeEntity, mut ctx gg.Context,frame time.Time){
			ctx.draw_circle_filled(f32(self.position.x),f32(self.position.y),f32(self.radius),self.color)
		}
		animations: [
			reactive_shape_animation__move_up_on_key(gg.KeyCode.up)
			reactive_shape_animation__move_down_on_key(gg.KeyCode.down)
			reactive_shape_animation__move_left_on_key(gg.KeyCode.left)
			reactive_shape_animation__move_right_on_key(gg.KeyCode.right)
			reactive_shape__create_object_on_key(gg.KeyCode.space,bullet)
		]
	}
	player1.event_listeners['key_down'] = []
	app.scene.add_entity(mut player1)
	app.run()
}

