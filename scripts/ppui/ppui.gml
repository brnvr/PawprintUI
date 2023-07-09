enum ppui_align {
	at_start,
	at_center,
	at_end
}

enum ppui_direction {
	row,
	column
}

function ppui_style_get_attribute(style, attribute_name, default_value) {
	var value;
	
	value = variable_struct_get(style, attribute_name);
	
	return is_undefined(value) ? default_value : value;
}

function ppui_element_get_width_default(element, element_width_func) {
	var padding_left, padding_right, padding;
	
	padding = ppui_style_get_attribute(element.style, "padding", 0);
	padding_left = ppui_style_get_attribute(element.style, "padding_left", padding);
	padding_right = ppui_style_get_attribute(element.style, "padding_right", padding);
	
	return padding_left+element_width_func(element)+padding_right;
}

function ppui_element_get_height_default(element, element_height_func) {
	var padding_top, padding_bottom, padding;
	
	padding = ppui_style_get_attribute(element.style, "padding", 0);
	padding_top = ppui_style_get_attribute(element.style, "padding_top", padding);
	padding_bottom = ppui_style_get_attribute(element.style, "padding_bottom", padding);
	
	return padding_top+element_height_func(element)+padding_bottom;
}

function ppui_element_get_xoffset_default(element) {	
	if (is_undefined(element.parent)) return 0;
	
	var parent_direction, parent_align, parent_padding, parent_padding_left, parent_padding_right,
		margin, margin_left;
	
	parent_padding = ppui_style_get_attribute(element.parent.style, "padding", 0);
	parent_padding_left = ppui_style_get_attribute(element.parent.style, "padding_left", parent_padding);
	parent_padding_right = ppui_style_get_attribute(element.parent.style, "padding_right", parent_padding);
	parent_direction = ppui_style_get_attribute(element.parent.style, "direction", ppui_direction.row);
	parent_align = ppui_style_get_attribute(element.parent.style, "align", ppui_align.at_start);
	margin = ppui_style_get_attribute(element.style, "margin", 0);
	margin_left = ppui_style_get_attribute(element.style, "margin_left", margin);
	
	switch (parent_direction) {
		case ppui_direction.row:
			if (is_undefined(element.previous)) {
				return element.parent.xoffset+parent_padding_left+margin_left;
			} else {
				var previous_margin, previous_margin_right;
				
				previous_margin = ppui_style_get_attribute(element.previous.style, "margin", 0);
				previous_margin_right = ppui_style_get_attribute(element.previous.style, "margin_right", previous_margin);
				
				return element.previous.xoffset+element.previous.width+previous_margin_right+margin_left;	
			}
			
		case ppui_direction.column:
			switch (parent_align) {
				case ppui_align.at_start:
					return element.parent.xoffset+parent_padding_left+margin_left;
					
				case ppui_align.at_center:
					return element.parent.xoffset+(element.parent.width-element.width)/2;
					
				case ppui_align.at_end:
					var margin_right;
					
					margin_right = ppui_style_get_attribute(element.style, "margin_right", margin);
					
					return element.parent.xoffset+element.parent.width-parent_padding_right-element.width-margin_right;
					
				default:
					throw "Invalid element alignment";
			}
			
		default:
			throw "Invalid element direction";
	}
}
	
function ppui_element_get_yoffset_default(element) {
	if (is_undefined(element.parent)) return 0;
	
	var parent_direction, parent_align, parent_padding, parent_padding_top, parent_padding_bottom,
		margin, margin_top;
	
	parent_padding = ppui_style_get_attribute(element.parent.style, "padding", 0);
	parent_padding_top = ppui_style_get_attribute(element.parent.style, "padding_top", parent_padding);
	parent_padding_bottom = ppui_style_get_attribute(element.parent.style, "padding_bottom", parent_padding);
	parent_direction = ppui_style_get_attribute(element.parent.style, "direction", ppui_direction.row);
	parent_align = ppui_style_get_attribute(element.parent.style, "align", ppui_align.at_start);
	margin = ppui_style_get_attribute(element.style, "margin", 0);
	margin_top = ppui_style_get_attribute(element.style, "margin_top", margin);
	
	switch (parent_direction) {
		case ppui_direction.column:
			if (is_undefined(element.previous)) {
				return element.parent.yoffset+parent_padding_top+margin_top;
			} else {
				var previous_margin, previous_margin_bottom;
				
				previous_margin = ppui_style_get_attribute(element.previous.style, "margin", 0);
				previous_margin_bottom = ppui_style_get_attribute(element.previous.style, "margin_bottom", previous_margin);
	
				return element.previous.yoffset+element.previous.height+previous_margin_bottom+margin_top;	
			}
			
		case ppui_direction.row:
			switch (parent_align) {
				case ppui_align.at_start:
					return element.parent.yoffset+parent_padding_top+margin_top;
					
				case ppui_align.at_center:
					return element.parent.yoffset+(element.parent.height-element.height)/2;
					
				case ppui_align.at_end:
					var margin_bottom;
					
					margin_bottom = ppui_style_get_attribute(element.style, "margin_bottom", margin);
					
					return element.parent.yoffset+element.parent.height-parent_padding_bottom-element.height-margin_bottom;
					
				default:
					throw "Invalid element alignment";
			}
			
		default:
			throw "Invalid element direction";
	}
}

function ppui_element_draw_default(ui, element, draw_func) {
	var bg_alpha, xstrt, ystrt, xend, yend, padding, padding_left, padding_top, padding_right, padding_bottom;
	
	xstrt = ui.x+element.xoffset;
	ystrt = ui.y+element.yoffset;
	xend = xstrt+element.width;
	yend = ystrt+element.height;
	
	padding = ppui_style_get_attribute(element.style, "padding", 0);
	padding_left = ppui_style_get_attribute(element.style, "padding_left", padding);
	padding_top = ppui_style_get_attribute(element.style, "padding_top", padding);
	padding_right = ppui_style_get_attribute(element.style, "padding_right", padding);
	padding_bottom = ppui_style_get_attribute(element.style, "padding_bottom", padding);	
	bg_alpha = ppui_style_get_attribute(element.style, "background_alpha", 0);

	if (bg_alpha > 0) {
		var bg_color, previous_color, previous_alpha, border_radius;
		
		bg_color = ppui_style_get_attribute(element.style, "background_color", c_black);
		border_radius = ppui_style_get_attribute(element.style, "border_radius", 0);
		previous_color = draw_get_color();
		previous_alpha = draw_get_alpha();
		
			
		
		draw_set_color(bg_color);
		draw_set_alpha(bg_alpha);
		draw_roundrect_ext(xstrt, ystrt, xend, yend, border_radius, border_radius, false);
		draw_set_color(previous_color);
		draw_set_alpha(previous_alpha);
	}
	
	draw_func(element, xstrt+padding_left, ystrt+padding_top, xend-padding_right, yend-padding_bottom);
}

function ppui_element_process_style(ui, element) {
	var class_names, n_classes, element_class;
	
	if (!variable_struct_exists(element, "style")) element.style = {};
	element_class = variable_struct_get(element, "class");
	
	if (is_undefined(element_class)) return;
	
	class_names = struct_get_names(ui.stylesheet);
	n_classes = array_length(class_names);
	
	for (var i = 0; i < n_classes; i++) {
		var class_name;
		
		class_name = class_names[i];
		
		if (class_name == element_class) {
			var class, attribute_names, n_attributes;
			
			class = variable_struct_get(ui.stylesheet, class_name);
			if (!is_struct(class)) throw "Malformed stylesheet: classes must be structs";
			
			attribute_names = struct_get_names(class);
			n_attributes = array_length(attribute_names);
			
			for (var j = 0; j < n_attributes; j++) {
				var attribute_name, attribute_value;
				
				attribute_name = attribute_names[i];
				attribute_value = variable_struct_get(class, attribute_name);
				
				if (!variable_struct_exists(element.style, attribute_name)) {
					variable_struct_set(element.style, attribute_name, attribute_value);	
				}
			}
		}
		
		return;
	}
}

function ppui_create(x, y, horizontal_align, vertical_align, stylesheet, template) {
	if (!is_struct(stylesheet)) throw "Invalid stylesheet";
	if (!is_struct(template)) throw "Invalid template";
	
	return {
		x: x,
		y: y,
		horizontal_align: horizontal_align,
		vertical_align: vertical_align,
		stylesheet: stylesheet,
		template: template,
		content: [],
		element_buffer: [],
		type: "container",
		parent: undefined,
		previous: undefined
	}
}

function ppui_process_cycle_0(ui, element=ui) {
	var type_template;
	
	if (!variable_struct_exists(element, "type")) element.type = "container";
	
	type_template = variable_struct_get(ui.template, element.type);
	if (is_undefined(type_template)) throw "Element type not found in template";

	ppui_element_process_style(ui, element);
	if (element != ui) array_push(ui.element_buffer, element);
	
	if (element.type == "container") {
		var content_length;
		
		if (!is_array(element.content)) throw "The content of a container element must be an array";
		
		content_length = array_length(element.content);
		
		for (var i = 0; i < content_length; i++) {
			element.content[i].parent = element;
			element.content[i].previous = (i == 0) ? undefined : element.content[i-1];
			ppui_process_cycle_0(ui, element.content[i]);
		}
	}
	
	element.width = type_template.get_width(element);
	element.height = type_template.get_height(element);
}

function ppui_process_cycle_1(ui, element=ui) {
	var type_template;

	type_template = variable_struct_get(ui.template, element.type);
	
	element.xoffset = type_template.get_xoffset(element);
	element.yoffset = type_template.get_yoffset(element);
	
	if (element.type == "container") {
		var content_length;
		
		content_length = array_length(element.content);
		
		for (var i = 0; i < content_length; i++) {
			ppui_process_cycle_1(ui, element.content[i]);
		}
	}
}

function ppui_build(ui) {
	ppui_process_cycle_0(ui);
	ppui_process_cycle_1(ui);
}

function ppui_draw(ui) {
	var length;
	
	length = array_length(ui.element_buffer);
	
	for (var i = 0; i < length; i++) {
		var element, type_template;
		
		element = ui.element_buffer[i];
	
		if (!variable_struct_exists(element, "type")) throw "Malformed element: missing type";
	
		type_template = variable_struct_get(ui.template, element.type);
		if (is_undefined(type_template)) throw "Element type not found in template";
		
		type_template.draw(ui, element);
	}
}

function ppui_template_create(custom_types={}) {
	var template, custom_type_names, n_custom_types;
	
	template = {
		"string": {
			draw: function(ui, element) {
				ppui_element_draw_default(ui, element, function(element, x, y) {
					var scale, line_separation, line_width, color, alpha,
						color_previous, alpha_previous, halign_previous, valign_previous;
					
					alpha = ppui_style_get_attribute(element.style, "alpha", 1);
					if (alpha <= 0) return;
					scale = ppui_style_get_attribute(element.style, "scale", 1);
					color = ppui_style_get_attribute(element.style, "color", c_white);			
					line_separation = ppui_style_get_attribute(element.style, "line_separation", -1);
					line_width = ppui_style_get_attribute(element.style, "line_width", -1);
				
					color_previous = draw_get_color();
					alpha_previous = draw_get_alpha();
					halign_previous = draw_get_halign();
					valign_previous = draw_get_valign();
					
					draw_set_color(color);
					draw_set_alpha(alpha);
					draw_set_halign(fa_left);
					draw_set_valign(fa_top);
					
					draw_text_ext_transformed(x, y, element.content, line_separation, line_width, scale, scale, 0);
					
					draw_set_color(color_previous);
					draw_set_alpha(alpha_previous);
					draw_set_halign(halign_previous)
					draw_set_valign(valign_previous);
				});	
			},
			
			get_width: function(element) {
				return ppui_element_get_width_default(element, function(element) {
					var scale, line_separation, line_width;
					
					scale = ppui_style_get_attribute(element.style, "scale", 1);
					line_separation = ppui_style_get_attribute(element.style, "line_separation", -1);
					line_width = ppui_style_get_attribute(element.style, "line_width", -1);
					
					return string_width_ext(element.content, line_separation, line_width)*scale;
				});
			},
			
			get_height: function(element) {
				return ppui_element_get_height_default(element, function(element) {
					var scale, line_separation, line_width;
					
					scale = ppui_style_get_attribute(element.style, "scale", 1);
					line_separation = ppui_style_get_attribute(element.style, "line_separation", -1);
					line_width = ppui_style_get_attribute(element.style, "line_width", -1);
					
					return string_height_ext(element.content, line_separation, line_width)*scale;
				});
			},
			
			get_xoffset: ppui_element_get_xoffset_default,	
			get_yoffset: ppui_element_get_yoffset_default
		},
	
		"sprite": {
			draw: function(ui, element) {
				ppui_element_draw_default(ui, element, function(element, x, y) {
					var scale, color, alpha, subimage;
					
					scale = ppui_style_get_attribute(element.style, "scale", 1);
					color = ppui_style_get_attribute(element.style, "color", c_white);
					alpha = ppui_style_get_attribute(element.style, "alpha", 1);
					subimage = ppui_style_get_attribute(element.style, "subimage", 0);
					
					draw_sprite_ext(element.content, subimage, x, y, scale, scale, 0, color, alpha);
				});
			},
			
			get_width: function(element) {
				return ppui_element_get_width_default(element, function(element) {
					var scale;
					
					scale = ppui_style_get_attribute(element.style, "scale", 1);
					
					return sprite_get_width(element.content)*scale;
				});
			},
			
			get_height: function(element) {
				return ppui_element_get_height_default(element, function(element) {
					var scale;
					
					scale = ppui_style_get_attribute(element.style, "scale", 1);
					
					return sprite_get_height(element.content)*scale;
				});
			},
			
			get_xoffset: ppui_element_get_xoffset_default,	
			get_yoffset: ppui_element_get_yoffset_default
		},
		
		"container": {
			draw: function(ui, element) {
				ppui_element_draw_default(ui, element, function() {});
			},
			
			get_width: function(element) {
				return ppui_element_get_width_default(element, function(element) {
					var dir, content_length, width;
					
					content_length = array_length(element.content);
					width = 0;
					dir = ppui_style_get_attribute(element.style, "direction", ppui_direction.row);
					
					for (var i = 0; i < content_length; i++) {
						var child, child_margin, child_margin_left, child_margin_right, width_partial;
						
						child = element.content[i];
						child_margin = ppui_style_get_attribute(child.style, "margin", 0);
						child_margin_left = ppui_style_get_attribute(child.style, "margin_left", child_margin);
						child_margin_right = ppui_style_get_attribute(child.style, "margin_right", child_margin);
						width_partial = child_margin_left + child.width + child_margin_right;
						
						switch (dir) {
							case ppui_direction.row:
								width += width_partial;
								break;
								
							case ppui_direction.column:
								width = max(width, width_partial);
								break;
								
							default:
								throw "Invalid element direction";
						}
						
					}
					
					return width;
				});
			},
			
			get_height: function(element) {
				return ppui_element_get_height_default(element, function(element) {
					var dir, content_length, height;
					
					content_length = array_length(element.content);
					height = 0;
					dir = ppui_style_get_attribute(element.style, "direction", ppui_direction.row);
					
					for (var i = 0; i < content_length; i++) {
						var child, child_margin, child_margin_top, child_margin_bottom, height_partial;
						
						child = element.content[i];
						child_margin = ppui_style_get_attribute(child.style, "margin", 0);
						child_margin_top = ppui_style_get_attribute(child.style, "margin_top", child_margin);
						child_margin_bottom = ppui_style_get_attribute(child.style, "margin_bottom", child_margin);
						height_partial = child_margin_top + child.height + child_margin_bottom;
						
						switch (dir) {
							case ppui_direction.row:
								height += height_partial;
								break;
								
							case ppui_direction.column:
								height = max(height, height_partial);
								break;
								
							default:
								throw "Invalid element direction";
						}
					}
					
					return height;
				});
			},
			
			get_xoffset: ppui_element_get_xoffset_default,
			get_yoffset: ppui_element_get_yoffset_default
		}
	}
	
	custom_type_names = variable_struct_get_names(custom_types);
	n_custom_types = array_length(custom_type_names);
	
	for (var i = 0; i < n_custom_types; i++) {
		var name;
		
		name = custom_type_names[i];
		
		variable_struct_set(template, name, variable_struct_get(custom_types, name));
	}
	
	return template;
}