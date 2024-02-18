module main

import gx
import g3
import time
import gg
import math

fn reactive_shape_animation__move_up_on_key(key_code gg.KeyCode) g3.EntityKeyboardAnimationFunction{
	return fn[key_code](mut e &g3.ReactiveShapeEntity, kb_state map[gg.KeyCode]u32) {
		if key_code in kb_state.keys() {
			e.position.y-=e.speed_vector.y
		}
	}
}
fn reactive_shape_animation__move_down_on_key(key_code gg.KeyCode)  g3.EntityKeyboardAnimationFunction{
	return fn[key_code](mut e &g3.ReactiveShapeEntity, kb_state map[gg.KeyCode]u32) {
		if key_code in kb_state.keys() {
			e.position.y+=e.speed_vector.y
		}
	}
}
fn reactive_shape_animation__move_left_on_key(key_code gg.KeyCode)  g3.EntityKeyboardAnimationFunction{
	return fn[key_code](mut e &g3.ReactiveShapeEntity, kb_state map[gg.KeyCode]u32) {
		if key_code in kb_state.keys() {
			e.position.x-=e.speed_vector.x
		}
	}
}
fn reactive_shape_animation__move_right_on_key(key_code gg.KeyCode)  g3.EntityKeyboardAnimationFunction{
	return fn[key_code](mut e &g3.ReactiveShapeEntity, kb_state map[gg.KeyCode]u32) {
		if key_code in kb_state.keys() {
			e.position.x+=e.speed_vector.x
		}
	}
}
type ModifyObjectFunction = fn(mut parent &g3.ReactiveShapeEntity,mut instance &g3.ReactiveShapeEntity)

fn reactive_shape__fire_object_on_key(key_code gg.KeyCode,prototype &g3.ReactiveShapeEntity,modify_fn ModifyObjectFunction) g3.SceneKeyboardAnimationFunction{
	return fn[key_code,prototype,modify_fn](mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32) {
		if key_code in kb_state.keys() {
			mut cp := prototype.copy()
			modify_fn(mut e,mut cp)
			scene.add_entity(mut cp)
		}
	}
}

fn reactive_shape__fire_object(prototype &g3.ReactiveShapeEntity,modify_fn ModifyObjectFunction) g3.SceneKeyboardAnimationFunction{
	return fn[prototype,modify_fn](mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32) {
			mut cp := prototype.copy()
			modify_fn(mut e,mut cp)
			scene.add_entity(mut cp)
	}
}
fn reactive_shape__create_object(e &g3.ReactiveShapeEntity,prototype g3.ReactiveShapeEntity,layer f64,angle_rad f32,mut scene &g3.Scene) {
	mut cp := prototype.copy()
	cp.position=g3.Vector2d{
		x: e.position.x
		y: e.position.y
		z: layer
	}
	cp.speed_vector = e.get_actual_speed().rotated_by(angle_rad)
	scene.add_entity(mut cp)
}

@[live]
fn init_app() &g3.App{
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
			z: 10
		}
		radius: 10.0
		speed_vector: g3.Vector2d{5,5,0}
		color: gx.color_from_string("#CC3300")
		draw_shape:fn(self g3.ReactiveShapeEntity,mut ctx gg.Context,frame time.Time){
			ctx.draw_text(int(self.position.x-2*self.radius),int(self.position.y-2*self.radius-10),"life:${self.life}",gx.TextCfg{color:gx.color_from_string("#333333")})
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
			z: 10
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
	app.scene.add_entity(mut player2)



	mut bullet := &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 80.0
			y: 30.0
			z: 10
		}
		radius: 3.0
		life: 100
		speed_vector: g3.Vector2d{7,1,0}
		color: gx.color_from_string("#333377")
		draw_shape:fn(self g3.ReactiveShapeEntity, mut ctx gg.Context,frame time.Time){
			// ctx.draw_text(int(self.position.x-2*self.radius),int(self.position.y-2*self.radius-10),"life:${self.life}",gx.TextCfg{color:gx.color_from_string("#333333")})
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
			fn(mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context,frame time.Time) {
				e.life=e.life - 1
			}
		]
	}
	mut bomb := &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 80.0
			y: 30.0
			z: 10
		}
		radius: 5.0
		life: 100
		speed_vector: g3.Vector2d{1,1,0}
		color: gx.color_from_string("#333377")
		draw_shape:fn(self g3.ReactiveShapeEntity, mut ctx gg.Context,frame time.Time){
			// ctx.draw_text(int(self.position.x-2*self.radius),int(self.position.y-2*self.radius-10),"life:${self.life}",gx.TextCfg{color:gx.color_from_string("#333333")})
			ctx.draw_circle_filled(f32(self.position.x),f32(self.position.y),f32(self.radius),self.color)
		}
		animations: [
			fn [bullet](mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context,frame time.Time) {
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
				if e.life < 1 {
					for k in 0 .. 8 {
						//// reactive_shape__fire_object(bullet,fn[k](mut parent &g3.ReactiveShapeEntity,mut instance &g3.ReactiveShapeEntity){

						//// 	instance.position=g3.Vector2d{
						//// 		x: parent.position.x
						//// 		y: parent.position.y
						//// 		z: 10
						//// 	}
						//// 	instance.speed_vector = parent.get_actual_speed().rotated_by(2*k*math.pi/8)
						//// })
						reactive_shape__create_object(e,bullet,10,2*k*math.pi/8,mut scene)
					}
				}
			}
			fn(mut e &g3.ReactiveShapeEntity,mut scene &g3.Scene, kb_state map[gg.KeyCode]u32 ,ctx gg.Context,frame time.Time) {
				e.life=e.life - 1
			}
		]
	}
	mut player1 := &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 80.0
			y: 30.0
			z: 30
		}
		radius: 10.0
		speed_vector: g3.Vector2d{7,7,0}
		color: gx.color_from_string("#00CC33")
		draw_shape:fn(self g3.ReactiveShapeEntity, mut ctx gg.Context,frame time.Time){
			ctx.draw_text(int(self.position.x-2*self.radius),int(self.position.y-2*self.radius-10),"life:${self.life}",gx.TextCfg{color:gx.color_from_string("#333333")})
			ctx.draw_circle_filled(f32(self.position.x),f32(self.position.y),f32(self.radius),self.color)
		}
		animations: [
			reactive_shape_animation__move_up_on_key(gg.KeyCode.w),
			reactive_shape_animation__move_down_on_key(gg.KeyCode.s),
			reactive_shape_animation__move_left_on_key(gg.KeyCode.a),
			reactive_shape_animation__move_right_on_key(gg.KeyCode.d),
			//reactive_shape__create_object_on_key(gg.KeyCode.space,bullet,10,2)
			reactive_shape__fire_object_on_key(
				gg.KeyCode.space,
				bullet,
				fn (mut parent &g3.ReactiveShapeEntity,mut instance &g3.ReactiveShapeEntity ) {
					instance.position=g3.Vector2d{
						x: parent.position.x
						y: parent.position.y
						z: 10
					}
					instance.speed_vector = parent.get_actual_speed().multiplied_by(2)
				}),
			reactive_shape__fire_object_on_key(
				gg.KeyCode.left_shift,
				bomb,
				fn (mut parent &g3.ReactiveShapeEntity,mut instance &g3.ReactiveShapeEntity) {
					instance.position=g3.Vector2d{
						x: parent.position.x
						y: parent.position.y
						z: 10
					}
					instance.speed_vector = parent.get_actual_speed().multiplied_by(1.2)
				}),
		]
	}
	app.scene.add_entity(mut player1)
	mut feed := &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 10.0
			y: 10.0
			z: 100
		}
		radius: 10.0
		speed_vector: g3.Vector2d{0,0,0}
		color: gx.color_from_string("#00CC33")
		draw_shape:fn(self g3.ReactiveShapeEntity, mut ctx gg.Context,frame time.Time){
			ctx.draw_text(int(self.position.x),int(self.position.y),"entities:${self.game_ref.entities.len}",gx.TextCfg{color:gx.color_from_string("#333333")})
		}
	}
	app.scene.add_entity(mut feed)
	return app
}

fn main(){
	mut app := init_app()
	app.run()
}

