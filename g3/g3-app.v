module g3

import time
import gg
import datatypes

@[heap]
pub struct App{
	pub mut:
	game &Scene = unsafe{nil}
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

		/// fail_fn: a.fail_fn
		/// on_event: a.on_event
		/// quit_fn: a.quit_fn
		/// keydown_fn: a.keydown_fn
		/// keyup_fn: a.keyup_fn
		/// char_fn: a.char_fn
		/// move_fn: a.move_fn
		/// click_fn: a.click_fn
		/// unclick_fn: a.unclick_fn
		/// leave_fn: a.leave_fn
		/// enter_fn: a.enter_fn
		/// resized_fn: a.resized_fn
		/// scroll_fn: a.scroll_fn
	}
	mut ctx := gg.new_context(cfg2)
	a.ctx=ctx
}

pub fn (mut a App) frame_fn(mut ctx gg.Context) {
	a.current_frame=time.now()
	ctx.begin()
	a.game.animate(ctx,a.current_frame) or {}
	a.game.render(ctx,a.current_frame) or {}
	ctx.end()
}
pub fn (mut a App) event_fn(ev &gg.Event, data voidptr) {
	a.current_frame=time.now()
	match ev.typ.str() {
		"resized" {
			a.ctx.resize(ev.window_width,ev.window_height)
		}
		"key_down" {
			a.key_codes[ev.key_code]=ev.char_code
			//a.global_events_queue.push(ev)
			a.dispatch_event(ev)
		}
		"key_up" {
			a.key_codes.delete(ev.key_code)
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
	for mut ent in a.game.entities {
		ent.dispatch_event(e)
	}
}
pub fn (mut a App) run() {
	a.ctx.run()
}


//////////////////////////////// fn (mut a App) fail_fn(m string, data voidptr){}
//////////////////////////////// fn (mut a App) on_event(data voidptr, ev &gg.Event){}
//////////////////////////////// fn (mut a App) quit_fn(ev &gg.Event,data voidptr){}
//////////////////////////////// fn (mut a App) keydown_fn(key_code gg.KeyCode, modifier gg.Modifier, data voidptr){}
//////////////////////////////// fn (mut a App) keyup_fn(key_code gg.KeyCode, modifier gg.Modifier, data voidptr){}
//////////////////////////////// fn (mut a App) char_fn(chr u32, data voidptr){}
//////////////////////////////// fn (mut a App) move_fn(x f32,y f32, data voidptr){}
//////////////////////////////// fn (mut a App) click_fn(x f32, y f32, mouse_button gg.MouseButton, data voidptr){}
//////////////////////////////// fn (mut a App) unclick_fn(x f32, y f32, mouse_button gg.MouseButton, data voidptr){}
//////////////////////////////// fn (mut a App) leave_fn(ev &gg.Event, data voidptr){}
//////////////////////////////// fn (mut a App) enter_fn(ev &gg.Event, data voidptr){}
//////////////////////////////// fn (mut a App) resized_fn(ev &gg.Event, data voidptr){
//////////////////////////////// 	a.ctx.resize(ev.window_width,ev.window_height)
//////////////////////////////// }
//////////////////////////////// fn (mut a App) scroll_fn(ev &gg.Event, data voidptr){}

