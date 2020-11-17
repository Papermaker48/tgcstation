
/mob/New()
	..()
	src.attack_particle = new /obj/particle/attack //don't use pooling for these particles
	src.attack_particle.appearance_flags = TILE_BOUND
	src.attack_particle.filters = filter (type="blur", size=0.2)
	src.attack_particle.filters += filter (type="drop_shadow", x=1, y=-1, size=0.7)

	src.sprint_particle = new /obj/particle/attack/sprint //don't use pooling for these particles


obj/particle/attack

	disposing() //kinda slow but whatever, block that gc ok
		for (var/mob/M in mobs)
			if (M.attack_particle == src)
				M.attack_particle = null
			if (M.sprint_particle == src)
				M.sprint_particle = null
		..()

	sprint
		icon = 'icons/mob/mob.dmi'
		icon_state = "sprint_cloud"
		layer = MOB_LAYER_BASE - 0.1
		appearance_flags = TILE_BOUND

		unpooled()
			..()
			src.alpha = 255

		pooled()
			..()


/mob/var/obj/particle/attack/attack_particle
/mob/var/obj/particle/attack/sprint/sprint_particle


/proc/attack_particle(var/mob/M, var/atom/target)
	if (!M || !target || !M.attack_particle) return
	var/diff_x = target.x - M.x
	var/diff_y = target.y - M.y

	M.attack_particle.invisibility = M.invisibility

	if (target) //I want these to be recent, but sometimes they can be deleted during course of a spawn
		diff_x = target.x - M.x
		diff_y = target.y - M.y

	M.last_interact_particle = world.time

	var/obj/item/I = M.equipped()
	if (I && !isgrab(I))
		M.attack_particle.icon = I.icon
		M.attack_particle.icon_state = I.icon_state
	else
		M.attack_particle.icon = 'icons/mob/mob.dmi'
		M.attack_particle.icon_state = "[M.a_intent]"

	M.attack_particle.alpha = 180
	M.attack_particle.loc = M.loc
	M.attack_particle.pixel_x = 0
	M.attack_particle.pixel_y = 0

	var/matrix/start = matrix()
	start.Scale(0.3,0.3)
	start.Turn(rand(-80,80))
	M.attack_particle.transform = start
	var/matrix/t_size = matrix()

	animate(M.attack_particle, transform = t_size, time = 6, easing = BOUNCE_EASING)
	animate(pixel_x = diff_x*32, pixel_y = diff_y*32, time = 2, easing = BOUNCE_EASING,  flags = ANIMATION_PARALLEL)
	SPAWN_DBG(5)
		M.attack_particle.alpha = 0


/proc/sprint_particle(var/mob/M, var/turf/T = null)
	if (!M || !M.sprint_particle) return
	if (T)
		M.sprint_particle.loc = T
	else
		M.sprint_particle.loc = M.loc

	M.sprint_particle.set_dir(null)
	if (M.sprint_particle.icon_state == "sprint_cloud")
		flick("sprint_cloud",M.sprint_particle)
	M.sprint_particle.icon_state = "sprint_cloud"


	SPAWN_DBG(6)
		if (M.sprint_particle.loc == T)
			M.sprint_particle.loc = null


/proc/sprint_particle_small(var/mob/M, var/turf/T = null, var/direct = null)
	if (!M || !M.sprint_particle) return
	if (T)
		M.sprint_particle.loc = T
	else
		M.sprint_particle.loc = M.loc

	M.sprint_particle.set_dir(direct)
	if (M.sprint_particle.icon_state == "sprint_cloud_small")
		flick("sprint_cloud_small",M.sprint_particle)
	M.sprint_particle.icon_state = "sprint_cloud_small"

	SPAWN_DBG(4)
		if (M.sprint_particle.loc == T)
			M.sprint_particle.loc = null

/proc/sprint_particle_tiny(var/mob/M, var/turf/T = null, var/direct = null)
	if (!M || !M.sprint_particle) return
	if (T)
		M.sprint_particle.loc = T
	else
		M.sprint_particle.loc = M.loc

	M.sprint_particle.set_dir(direct)
	if (M.sprint_particle.icon_state == "sprint_cloud_tiny")
		flick("sprint_cloud_tiny",M.sprint_particle)
	M.sprint_particle.icon_state = "sprint_cloud_tiny"

	SPAWN_DBG(3)
		if (M.sprint_particle.loc == T)
			M.sprint_particle.loc = null