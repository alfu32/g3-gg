module g3

pub fn entity_init() {
	b := init_test_ball()
	mut g:= Scene{}
	mut e:= Entity(b)
	g.add_entity(mut &e)

	assert g.entities.len == 1
	println(b)
	println(e)
	println(g)
	assert g.entities.len == 1
}

pub fn entity_interface_casting() {
	b := init_test_ball()
	e:= Entity(b)
	println(b)
	println(e)
}
