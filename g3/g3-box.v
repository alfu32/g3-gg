module g3


pub struct Box{
	position Vector2d
	size Vector2d
}

pub fn (box Box) corner() Vector2d {
	return Vector2d{
		x: box.position.x+box.size.x
		y: box.position.y+box.size.y
		z: box.position.z+box.size.z
	}
}

pub fn (box Box) corners() []Vector2d {
	c:=box.corner()
	a:=box.position
	return [
		Vector2d{x:a.x,y:a.y,z:a.z},
		Vector2d{x:a.x,y:a.y,z:c.z},
		Vector2d{x:a.x,y:c.y,z:a.z},
		Vector2d{x:a.x,y:c.y,z:c.z},
		Vector2d{x:c.x,y:a.y,z:a.z},
		Vector2d{x:c.x,y:a.y,z:c.z},
		Vector2d{x:c.x,y:c.y,z:a.z},
		Vector2d{x:c.x,y:c.y,z:c.z},
	]
}

pub fn (box Box) contains(p Vector2d) bool {
	c:=box.corner()
	a:=box.position
	return p.x >= a.x && p.x<= c.x && p.y>=a.y && p.y <= c.y && p.z>=a.z && p.z<=c.z
}
pub fn (a Box) intersects(b Box) bool {
	for ca in a.corners() {
		if b.contains(ca) {return true}
	}
	for cb in b.corners() {
		if a.contains(cb) {return true}
	}
	return false
}
