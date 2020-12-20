/obj/item/ammo_casing/energy/electrode
	projectile_type = /obj/projectile/energy/electrode
	select_name = "stun"
	fire_sound = 'sound/weapons/taser.ogg'
	e_cost = 200
	harmful = FALSE

/obj/item/ammo_casing/energy/electrode/spec
	e_cost = 100

/obj/item/ammo_casing/energy/electrode/gun
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	e_cost = 100

/obj/item/ammo_casing/energy/electrode/old
	e_cost = 1000

/obj/item/ammo_casing/energy/disabler
	projectile_type = /obj/projectile/beam/disabler
	select_name  = "disable"
	e_cost = 50
	fire_sound = 'sound/weapons/taser2.ogg'
	harmful = FALSE

/obj/item/ammo_casing/energy/disabler/hos
	e_cost = 60

/obj/item/ammo_casing/energy/disabler/shotgun
	projectile_type = /obj/projectile/beam/disabler/shotgun
	e_cost = 200
	fire_sound = 'sound/weapons/laser3.ogg'
	pellets = 6
	variance = 45
	harmful = FALSE

/obj/item/ammo_casing/energy/disabler/shotgun/hos
	e_cost = 250
