module g3

pub struct Vector2d{
	pub mut:
	x f64
	y f64
	z f64
}

pub fn(v Vector2d) copy() Vector2d {
	return Vector2d{
		x: v.x
		y: v.y
		z: v.z
	}
}
