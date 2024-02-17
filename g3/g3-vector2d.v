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

pub fn(v Vector2d) perpendicular_2d() Vector2d {
	return Vector2d{
		x: v.y
		y: -v.x
		z: v.z
	}
}
pub fn(v Vector2d) multiplied_by(m f64) Vector2d {
	return Vector2d{
		x: v.x*m
		y: v.y*m
		z: v.z*m
	}
}
pub fn(v Vector2d) moved_by(d Vector2d) Vector2d {
	return Vector2d{
		x: v.x + d.x
		y: v.y + d.y
		z: v.z + d.z
	}
}
