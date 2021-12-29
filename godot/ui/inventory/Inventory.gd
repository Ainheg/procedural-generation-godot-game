extends MarginContainer

onready var STR_VAL = $HSplitContainer/ItemsStats/STRMargin/STR/Value
onready var AGI_VAL = $HSplitContainer/ItemsStats/AGIMargin/AGI/Value
onready var PER_VAL = $HSplitContainer/ItemsStats/PERMargin/PER/Value
onready var DEF_VAL = $HSplitContainer/ItemsStats/DEFMargin/DEF/Value
onready var LCK_VAL = $HSplitContainer/ItemsStats/LCKMargin/LCK/Value
onready var CST_VAL = $HSplitContainer/ItemsStats/CSTMargin/CST/Value

onready var STR_BTN = $HSplitContainer/ItemsStats/STRMargin/STR/Add
onready var AGI_BTN = $HSplitContainer/ItemsStats/AGIMargin/AGI/Add
onready var PER_BTN = $HSplitContainer/ItemsStats/PERMargin/PER/Add
onready var DEF_BTN = $HSplitContainer/ItemsStats/DEFMargin/DEF/Add
onready var LCK_BTN = $HSplitContainer/ItemsStats/LCKMargin/LCK/Add
onready var CST_BTN = $HSplitContainer/ItemsStats/CSTMargin/CST/Add

onready var INVENTORY = $HSplitContainer/InventoryVBox/CenterContainer/InventoryGrid.get_children()
onready var EQ_HEADGEAR = $HSplitContainer/ItemsStats/ItemsMargin/Items/HeadgearSlot/HeadgearItem
onready var EQ_ARMOR = $HSplitContainer/ItemsStats/ItemsMargin/Items/ArmorSlot/ArmorItem
onready var EQ_WEAPON = $HSplitContainer/ItemsStats/ItemsMargin/Items/WeaponSlot/WeaponItem
onready var EQ_CHARM = $HSplitContainer/ItemsStats/ItemsMargin/Items/CharmSlot/CharmItem

signal stat_increased(stat_name)
signal equip_item(slot)
signal remove_item(slot)

func _ready():
	connect("stat_increased", Main.PLAYER, "_on_stat_increased")
	Main.PLAYER.connect("stat_increased", self, "_on_stats_update")
	PlayerInventory.connect("inventory_updated", self, "_on_inventory_updated")
	connect("equip_item", PlayerInventory, "_equip_item")
	connect("remove_item", PlayerInventory, "_remove_item")

func refresh_stats():
	var stats = Main.PLAYER.get_stats_with_items()
	var can_add = Main.PLAYER.get_upgrade_count() > 0
	
	STR_VAL.text = str(stats["STR"])
	AGI_VAL.text = str(stats["AGI"])
	PER_VAL.text = str(stats["PER"])
	DEF_VAL.text = str(stats["DEF"])
	LCK_VAL.text = str(stats["LCK"])
	CST_VAL.text = str(stats["CST"])
	
	if !can_add:
		STR_BTN.disabled = true
		AGI_BTN.disabled = true
		PER_BTN.disabled = true
		DEF_BTN.disabled = true
		LCK_BTN.disabled = true
		CST_BTN.disabled = true
	else:
		STR_BTN.disabled = false
		AGI_BTN.disabled = false
		PER_BTN.disabled = false
		DEF_BTN.disabled = false
		LCK_BTN.disabled = false
		CST_BTN.disabled = false

func refresh_items():
	for idx in range(PlayerInventory.backpack.size()):
		var item = PlayerInventory.backpack[idx]
		if item == null:
			INVENTORY[idx].hint_tooltip = ""
			continue
		INVENTORY[idx].hint_tooltip = item.get_tooltip()
	

func _on_show():
	refresh_items()
	refresh_stats()

func _on_stats_update():
	refresh_stats()

func _on_inventory_updated():
	refresh_items()
	refresh_stats()

func _on_STR_Add_pressed():
	emit_signal("stat_increased", "STR")

func _on_AGI_Add_pressed():
	emit_signal("stat_increased", "AGI")

func _on_PER_Add_pressed():
	emit_signal("stat_increased", "PER")

func _on_DEF_Add_pressed():
	emit_signal("stat_increased", "DEF")

func _on_LCK_Add_pressed():
	emit_signal("stat_increased", "LCK")

func _on_CST_Add_pressed():
	emit_signal("stat_increased", "CST")

func _on_ItemSlot_gui_input(event, slot):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				emit_signal("equip_item", slot)
				print("Item in slot " + str(slot) + " equipped")
			BUTTON_RIGHT:
				emit_signal("remove_item", slot)
				print("Item in slot " + str(slot) + " deleted")
