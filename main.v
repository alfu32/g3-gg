module main

import gx
import g3
import time
import math
import gg

fn main() {
	mut app:=&g3.App{
		game: g3.game_create()
	}
	app.init_ctx(
		gx.rgb(174, 198, 255),
		600,
		400,
		'Polygons',
	)
	app.game.add_entity(mut &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 10.0
			y: 10.0
		}
		radius: 10.0
		speed_vector: g3.Vector2d{10,10,0}
		color: gx.color_from_string("#CC3300")
		draw_shape:fn(self g3.ReactiveShapeEntity, ctx gg.Context,frame time.Time){
			ctx.draw_circle_filled(f32(self.position.x),f32(self.position.y),f32(self.radius),self.color)
		}
		animations: [
			fn(mut e &g3.ReactiveShapeEntity, ctx gg.Context,frame time.Time) {
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
	mut player1 := &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 80.0
			y: 30.0
		}
		radius: 10.0
		speed_vector: g3.Vector2d{10,10,0}
		color: gx.color_from_string("#00CC33")
		draw_shape:fn(self g3.ReactiveShapeEntity, ctx gg.Context,frame time.Time){
			ctx.draw_circle_filled(f32(self.position.x),f32(self.position.y),f32(self.radius),self.color)
		}
		animations: [
			fn(mut e &g3.ReactiveShapeEntity, ctx gg.Context,frame time.Time) {
				e.radius=10.0+math.sin(f64(frame.unix)/1.0)*5.0
			}
		]
	}
	player1.event_listeners['key_down'] = [
		fn(mut e &g3.ReactiveShapeEntity, ev &gg.Event){
			if ev.key_code == gg.KeyCode.up {
				e.position.y-=e.speed_vector.y
			}
			if ev.key_code == gg.KeyCode.down {
				e.position.y+=e.speed_vector.y
			}
			if ev.key_code == gg.KeyCode.left {
				e.position.x-=e.speed_vector.x
			}
			if ev.key_code == gg.KeyCode.right {
				e.position.x+=e.speed_vector.x
			}
		}
	]
	app.game.add_entity(mut player1)


	mut player2 := &g3.ReactiveShapeEntity{
		position: g3.Vector2d{
			x: 80.0
			y: 30.0
		}
		radius: 10.0
		speed_vector: g3.Vector2d{10,10,0}
		color: gx.color_from_string("#0033CC")
		draw_shape:fn(self g3.ReactiveShapeEntity, ctx gg.Context,frame time.Time){
			ctx.draw_rect_filled(f32(self.position.x-self.radius),f32(self.position.y-self.radius),f32(2*self.radius),f32(2*self.radius),self.color)
		}
		animations: [
			fn(mut e &g3.ReactiveShapeEntity, ctx gg.Context,frame time.Time) {
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
	app.game.add_entity(mut player2)
	app.run()
}

