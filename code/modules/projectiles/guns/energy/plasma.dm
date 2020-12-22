obj/item/gun/energy/plasma
    name = "plasma rifle"
    desc = "An effective but unstable experimental weapon based on the plasma found abundantly near the station. From the many hazard stripes you can assume excessive use is a bad idea."
    icon_state = "laser"
    inhand_icon_state = "laser"
    w_class = WEIGHT_CLASS_NORMAL
    ammo_type = list(/obj/item/ammo_casing/energy/plasma)

/obj/item/gun/energy/plasma/examine(mob/user)
	. = ..()
	if(cell)
		. += "<span class='notice'>[src] is [round(cell.percent())]% charged.</span>"

/obj/item/gun/energy/plasma/attackby(obj/item/I, mob/user)
	var/charge_multiplier = 0 //2 = Refined stack, 1 = Ore
	if(istype(I, /obj/item/stack/sheet/mineral/plasma))
		charge_multiplier = 2
	if(istype(I, /obj/item/stack/ore/plasma))
		charge_multiplier = 1
	if(charge_multiplier)
		if(cell.charge == cell.maxcharge)
			to_chat(user, "<span class='notice'>You try to insert [I] into [src], but it's fully charged.</span>") //my cell is round and full
			return
		I.use(1)
		cell.give(500*charge_multiplier)
		to_chat(user, "<span class='notice'>You insert [I] in [src], recharging it.</span>")
	else
		..()

/obj/item/gun/energy/plasma/cutter
	name = "plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off xenos! Or, you know, mine stuff."
	icon_state = "plasmacutter"
	inhand_icon_state = "plasmacutter"
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = list(/obj/item/ammo_casing/energy/plasma)
	flags_1 = CONDUCT_1
	attack_verb_continuous = list("attacks", "slashes", "cuts", "slices")
	attack_verb_simple = list("attack", "slash", "cut", "slice")
	force = 12
	sharpness = SHARP_EDGED
	can_charge = FALSE

	heat = 3800
	usesound = list('sound/items/welder.ogg', 'sound/items/welder2.ogg')
	tool_behaviour = TOOL_WELDER
	toolspeed = 0.7 //plasmacutters can be used as welders, and are faster than standard welders
	var/charge_weld = 25 //amount of charge used up to start action (multiplied by amount) and per progress_flash_divisor ticks of welding

/obj/item/gun/energy/plasma/cutter/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 25, 105, 0, 'sound/weapons/plasma_cutter.ogg')
	AddElement(/datum/element/update_icon_blocker)
	AddElement(/datum/element/tool_flash, 1)

// Can we weld? Plasma cutter does not use charge continuously.
// Amount cannot be defaulted to 1: most of the code specifies 0 in the call.
/obj/item/gun/energy/plasma/cutter/tool_use_check(mob/living/user, amount)
	if(QDELETED(cell))
		to_chat(user, "<span class='warning'>[src] does not have a cell, and cannot be used!</span>")
		return FALSE
	// Amount cannot be used if drain is made continuous, e.g. amount = 5, charge_weld = 25
	// Then it'll drain 125 at first and 25 periodically, but fail if charge dips below 125 even though it still can finish action
	// Alternately it'll need to drain amount*charge_weld every period, which is either obscene or makes it free for other uses
	if(amount ? cell.charge < charge_weld * amount : cell.charge < charge_weld)
		to_chat(user, "<span class='warning'>You need more charge to complete this task!</span>")
		return FALSE

	return TRUE

/obj/item/gun/energy/plasma/cutter/use(amount)
	return (!QDELETED(cell) && cell.use(amount ? amount * charge_weld : charge_weld))

/obj/item/gun/energy/plasma/cutter/use_tool(atom/target, mob/living/user, delay, amount=1, volume=0, datum/callback/extra_checks)
	if(amount)
		. = ..()
	else
		. = ..(amount=1)

/obj/item/gun/energy/plasma/cutter/adv
	name = "advanced plasma cutter"
	icon_state = "adv_plasmacutter"
	inhand_icon_state = "adv_plasmacutter"
	force = 15
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv)
