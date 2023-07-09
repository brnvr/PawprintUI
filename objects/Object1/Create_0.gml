stylesheet = {
	
}

ui = ppui_create(70, 70, ppui_align.at_start, ppui_align.at_start, stylesheet, ppui_template_create());

ui.content = [
	{
		"type": "string",
		"content": "asdk lasda kjdas",
		
		"style": {
			"color": c_yellow,
			"background_color": c_blue,
			"background_alpha": 1,
			"border_radius": 10,
			"padding": 20,
			"padding_right": 50,
			"padding_top": 135,
			"margin": 75AAA
		}
	},
	{
		"type": "container",
		"style": {
			"direction": ppui_direction.column,
			"align": ppui_align.at_center
		},
		
		"content": [
			{
				"type": "string",
				"content": "asdk lasda kjdas",
		
				"style": {
					"color": c_blue,
					"background_color": c_red,
					"background_alpha": .5,
					"border_radius": 10,
					"padding_left": 20,
					"margin_left": 10
				}
			},
			{
				"type": "string",
				"content": "asdk lasda kjdas",
		
				"style": {
					"color": c_blue,
					"background_color": c_red,
					"background_alpha": .5,
					"border_radius": 10,
					"padding_left": 20,
					"margin_left": 10,
					"margin_top": 10,
					"padding_top": 30,
					"padding_right": 15
				}
			}
		]
	}
	
]

ppui_build(ui);