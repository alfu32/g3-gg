module g3

import time
import gg
import datatypes

@[heap]
pub struct App{
	pub mut:
	scene &Scene = unsafe{nil}
	ctx &gg.Context = unsafe{nil}
	current_frame time.Time
	key_codes map[gg.KeyCode]u32
	global_events_queue datatypes.Queue[gg.Event] = datatypes.Queue[gg.Event]{}
	targeted_events_queue datatypes.Queue[gg.Event] = datatypes.Queue[gg.Event]{}
}
pub fn (mut a App) init_ctx(
	bg_color gg.Color,
	width i32,
	height i32,
	window_title string
){
	cfg2:=gg.Config{
		bg_color : bg_color
		width : width
		height : height
		window_title : window_title
		frame_fn: a.frame_fn
		event_fn: a.event_fn
		ui_mode: false

	}
	mut ctx := gg.new_context(cfg2)
	a.ctx=ctx
}

pub fn (mut a App) frame_fn(mut ctx gg.Context) {
	a.current_frame=time.now()
	ctx.begin()
	a.scene.animate(ctx,a.key_codes,a.current_frame) or {}
	a.scene.do_collisions()
	a.scene.render(mut ctx,a.current_frame) or {}
	a.scene.collect_dead_entities(ctx,a.current_frame) or {}
	ctx.end()
}
pub fn (mut a App) event_fn(ev &gg.Event, data voidptr) {
	a.current_frame=time.now()
	match ev.typ.str() {
		"resized" {
			a.ctx.resize(ev.window_width,ev.window_height)
		}
		"key_down" {
			println("${ev.typ}{x:${ev.mouse_x},y:${ev.mouse_x},key_code:${ev.key_code},char_code:${ev.char_code},}")
			a.key_codes[ev.key_code]=ev.char_code
			println(a.key_codes)
			//a.global_events_queue.push(ev)
			a.dispatch_event(ev)
		}
		"key_up" {
			println("${ev.typ}{x:${ev.mouse_x},y:${ev.mouse_x},key_code:${ev.key_code},char_code:${ev.char_code},}")
			a.key_codes.delete(ev.key_code)
			println(a.key_codes)
			//a.global_events_queue.push(ev)
			a.dispatch_event(ev)
		}
		"mouse_down" {
			println("${ev.typ}{x:${ev.mouse_x},y:${ev.mouse_x},key_code:${ev.key_code},char_code:${ev.char_code},}")
			//a.targeted_events_queue.push(ev)
			a.dispatch_event(ev)
		}
		"mouse_up" {
			println("${ev.typ}{x:${ev.mouse_x},y:${ev.mouse_x},key_code:${ev.key_code},char_code:${ev.char_code},}")
			//a.targeted_events_queue.push(ev)
			a.dispatch_event(ev)
		}
		"mouse_move" {
			println("${ev.typ}{x:${ev.mouse_x},y:${ev.mouse_x},key_code:${ev.key_code},char_code:${ev.char_code},}")
			//a.targeted_events_queue.push(ev)
			a.dispatch_event(ev)
		}
		else{
			println("${ev.typ}{x:${ev.mouse_x},y:${ev.mouse_x},key_code:${ev.key_code},char_code:${ev.char_code},}")
		}
	}
}

pub fn (mut a App) dispatch_event(e &gg.Event) {
	for mut ent in a.scene.entities {
		ent.dispatch_event(e)
	}
}
pub fn (mut a App) run() {
	a.ctx.run()
}

