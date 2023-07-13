var stylesheet = {
	"test": {
		"color": c_yellow,
		"background_color": c_blue,
		"background_alpha": 1,
		"border_radius": 10,
		"padding": 20,
		"padding_right": 50,
		"padding_top": 135,
		"margin": 75,
		"margin_bottom": 0
	},
	
	"test2": {
		"color": c_blue,
		"background_color": c_red,
		"background_alpha": .5,
		"border_radius": 10,
		"padding_left": 20,
		"margin_left": 10
	},
	
	"test3": {
		"color": c_yellow,
		
		"selectors": {
			"hover": {
				"background_color": c_blue	
			}
		}
	}
}

var content = [
	{
		"type": "string",
		"content": "asdk lasda kjdas",
		"class": "test",
		"style": {
			"background_color": c_gray,
			"color": c_black,
			"background_alpha": 1,
			"padding_top": 15
		},
		"events": {
			"on_mouse_over": function() {
				if (mouse_check_button_pressed(mb_left)) {
					show_message("deu certo!");	
				}
			}
		}
	},
	{ 
		"type": "container",
		"style": {
			"direction": pawpr_direction.column,
			"align": pawpr_align.at_center
		},
		
		"content": [
			{
				"type": "string",
				"class": "test2",
				"content": "asdk lasda kjdas",
			},
			{
				"type": "string",
				"content": "asdk lasda kjdas",
				"class": "test2 test3",
		
				"style": {
					"padding_left": 20,
					"margin_left": 10,
					"margin_top": 10,
					"padding_top": 30,
					"padding_right": 15,
					"border_alpha": 0.5,
					"expansion": 2,
					"shadow_alpha": .75
				}
			},
			{
				"content": [
					{
						"type": "sprite",
						"content": Sprite1,
						"image_speed": .2,
						
						"style": {
							"margin": 5,
							"padding_right": 10
						} 
					},
					{
						"type": "sprite",
						"content": Sprite1
					}
				]
			}
			
		]
	},
	{
		"type": "string",
		"content": "asdk lasda kjdas",
		"class": "test",
		"style": {
			"background_color": c_gray,
			"color": c_black,
			"background_alpha": 1,
			"padding_top": 15
		},
		"events": {
			"on_mouse_over": function() {
				if (mouse_check_button_pressed(mb_left)) {
					show_message("deu certo!");	
				}
			}
		}
	},
	{
		"type": "container",
		"style": {
			"direction": pawpr_direction.column,
			"align": pawpr_align.at_center
		},
		
		"content": [
			{
				"type": "string",
				"class": "test2",
				"content": "asdk lasda kjdas",
			},
			{
				"type": "string",
				"content": "asdk lasda kjdas",
				"class": "test2 test3",
		
				"style": {
					"padding_left": 20,
					"margin_left": 10,
					"margin_top": 10,
					"padding_top": 30,
					"padding_right": 15,
					"border_alpha": 0.5,
					"expansion": 2,
					"shadow_alpha": .75
				}
			},
			{
				"content": [
					{
						"type": "sprite",
						"content": Sprite1,
						"image_speed": .2,
						
						"style": {
							"margin": 5,
							"padding_right": 10
						} 
					},
					{
						"type": "sprite",
						"content": Sprite1
					}
				]
			}
			
		]
	},
	{
		"type": "string",
		"content": "asdk lasda kjdas",
		"class": "test",
		"style": {
			"background_color": c_gray,
			"color": c_black,
			"background_alpha": 1,
			"padding_top": 15
		},
		"events": {
			"on_mouse_over": function() {
				if (mouse_check_button_pressed(mb_left)) {
					show_message("deu certo!");	
				}
			}
		}
	},
	{
		"type": "container",
		"style": {
			"direction": pawpr_direction.column,
			"align": pawpr_align.at_center
		},
		
		"content": [
			{
				"type": "string",
				"class": "test2",
				"content": "asdk lasda kjdas",
			},
			{
				"type": "string",
				"content": "asdk lasda kjdas",
				"class": "test2 test3",
		
				"style": {
					"padding_left": 20,
					"margin_left": 10,
					"margin_top": 10,
					"padding_top": 30,
					"padding_right": 15,
					"border_alpha": 0.5,
					"expansion": 2,
					"shadow_alpha": .75
				}
			},
			{
				"content": [
					{
						"type": "sprite",
						"content": Sprite1,
						"image_speed": .2,
						
						"style": {
							"margin": 5,
							"padding_right": 10
						} 
					},
					{
						"type": "sprite",
						"content": Sprite1
					}
				]
			}
			
		]
	},
	{
		"type": "string",
		"content": "asdk lasda kjdas",
		"class": "test",
		"style": {
			"background_color": c_gray,
			"color": c_black,
			"background_alpha": 1,
			"padding_top": 15
		},
		"events": {
			"on_mouse_over": function() {
				if (mouse_check_button_pressed(mb_left)) {
					show_message("deu certo!");	
				}
			}
		}
	},
	{
		"type": "container",
		"style": {
			"direction": pawpr_direction.column,
			"align": pawpr_align.at_center
		},
		
		"content": [
			{
				"type": "string",
				"class": "test2",
				"content": "asdk lasda kjdas",
			},
			{
				"type": "string",
				"content": "asdk lasda kjdas",
				"class": "test2 test3",
		
				"style": {
					"padding_left": 20,
					"margin_left": 10,
					"margin_top": 10,
					"padding_top": 30,
					"padding_right": 15,
					"border_alpha": 0.5,
					"expansion": 2,
					"shadow_alpha": .75
				}
			},
			{
				"content": [
					{
						"type": "sprite",
						"content": Sprite1,
						"image_speed": .2,
						
						"style": {
							"margin": 5,
							"padding_right": 10
						} 
					},
					{
						"type": "sprite",
						"content": Sprite1
					}
				]
			}
			
		]
	}	
]

ui = pawpr_create(70, 70, content, stylesheet);

pawpr_build(ui);
show_debug_overlay(true);