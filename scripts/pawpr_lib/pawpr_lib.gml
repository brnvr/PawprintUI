enum pawpr_align {
	at_start,
	at_center,
	at_end
}

enum pawpr_direction {
	row,
	column
}

enum pawpr_types {
	container,
	string,
	sprite
}

enum pawpr {
	padding,
	padding_left,
	padding_top,
	padding_right,
	padding_bottom,
	
	margin,
	margin_left,
	margin_top,
	margin_right,
	margin_bottom,
	
	align,
	direction,
	
	scale,
	color,
	alpha,
	expansion,
	
	font,
	line_width,
	line_separation,
	
	background_color,
	background_alpha,
	
	border_radius,
	border_color,
	border_alpha,
	
	shadow_xdistance,
	shadow_ydistance,
	shadow_color,
	shadow_alpha
}

function pawpr_style_get_property(element, property_name, default_value, use_selectors = true) {
	var value;
	
	if (use_selectors && variable_struct_exists(element, "ui")) {
		var selectors;
		
		selectors = variable_struct_get(element.style, "selectors");
		
		if (!is_undefined(selectors)) {
			var selector_names, n_selectors;
			
			var selector_names = variable_struct_get_names(selectors);
			n_selectors = array_length(selector_names);
			
			for (var i = 0; i < n_selectors; i++) {
				var selector_name, selector_predicate;
				
				selector_name = selector_names[i];
				
				selector_predicate = variable_struct_get(element.ui.style_selectors, selector_name);
				
				if (is_undefined(selector_predicate)) throw "Style selector not found in Element UI.";
				
				if (selector_predicate(element)) {
					var selector_style;
				
					selector_style = variable_struct_get(selectors, selector_name);
					
					value = variable_struct_get(selector_style, property_name);
					
					if (is_undefined(value)) break;
					
					return value;
				}
			}
		}
	}
		
	value = variable_struct_get(element.style, property_name);
	
	return is_undefined(value) ? default_value : value;
}

function pawpr_element_get_width_default(element, element_width_func) {
	var padding_left, padding_right, padding;
	
	padding = pawpr_style_get_property(element, "padding", 0);
	padding_left = pawpr_style_get_property(element, "padding_left", padding);
	padding_right = pawpr_style_get_property(element, "padding_right", padding);
	
	return padding_left+element_width_func(element)+padding_right;
}

function pawpr_element_get_height_default(element, element_height_func) {
	var padding_top, padding_bottom, padding;
	
	padding = pawpr_style_get_property(element, "padding", 0);
	padding_top = pawpr_style_get_property(element, "padding_top", padding);
	padding_bottom = pawpr_style_get_property(element, "padding_bottom", padding);
	
	return padding_top+element_height_func(element)+padding_bottom;
}

function pawpr_draw_text_ext_transformed_shadow(x, y, str, sep, w, xscale, yscale, angle, shadow_color, shadow_alpha, shadow_xdist, shadow_ydist) {
	var color_previous, alpha_previous;
	
	color_previous = draw_get_color();
	alpha_previous = draw_get_alpha();
	
	if (shadow_alpha > 0) {
		draw_set_color(shadow_color);
		draw_set_alpha(shadow_alpha*alpha_previous);
		draw_text_ext_transformed(x+shadow_xdist, y+shadow_ydist, str, sep, w, xscale, yscale, angle);
	}
	
	draw_set_color(color_previous);
	draw_set_alpha(alpha_previous);
	
	if (alpha_previous > 0) draw_text_ext_transformed(x, y, str, sep, w, xscale, yscale, angle);
}

function pawpr_element_get_xoffset_default(element) {	
	if (is_undefined(element.parent)) return 0;
	
	var parent_direction, parent_align, parent_padding, parent_padding_left, parent_padding_right,
		margin, margin_left;
	
	parent_padding = pawpr_style_get_property(element.parent, "padding", 0);
	parent_padding_left = pawpr_style_get_property(element.parent, "padding_left", parent_padding);
	parent_padding_right = pawpr_style_get_property(element.parent, "padding_right", parent_padding);
	parent_direction = pawpr_style_get_property(element.parent, "direction", pawpr_direction.row);
	parent_align = pawpr_style_get_property(element.parent, "align", pawpr_align.at_start);
	margin = pawpr_style_get_property(element, "margin", 0);
	margin_left = pawpr_style_get_property(element, "margin_left", margin);
	
	switch (parent_direction) {
		case pawpr_direction.row:
			if (is_undefined(element.previous)) {
				return element.parent.xoffset+parent_padding_left+margin_left;
			} else {
				var previous_margin, previous_margin_right;
				
				previous_margin = pawpr_style_get_property(element.previous, "margin", 0);
				previous_margin_right = pawpr_style_get_property(element.previous, "margin_right", previous_margin);
				
				return element.previous.xoffset+element.previous.width+previous_margin_right+margin_left;	
			}
			
		case pawpr_direction.column:
			switch (parent_align) {
				case pawpr_align.at_start:
					return element.parent.xoffset+parent_padding_left+margin_left;
					
				case pawpr_align.at_center:
					return element.parent.xoffset+(element.parent.width-element.width)/2;
					
				case pawpr_align.at_end:
					var margin_right;
					
					margin_right = pawpr_style_get_property(element, "margin_right", margin);
					
					return element.parent.xoffset+element.parent.width-parent_padding_right-element.width-margin_right;
					
				default:
					throw "Invalid element alignment";
			}
			
		default:
			throw "Invalid element direction";
	}
}
	
function pawpr_element_get_yoffset_default(element) {
	if (is_undefined(element.parent)) return 0;
	
	var parent_direction, parent_align, parent_padding, parent_padding_top, parent_padding_bottom,
		margin, margin_top;
	
	parent_padding = pawpr_style_get_property(element.parent, "padding", 0);
	parent_padding_top = pawpr_style_get_property(element.parent, "padding_top", parent_padding);
	parent_padding_bottom = pawpr_style_get_property(element.parent, "padding_bottom", parent_padding);
	parent_direction = pawpr_style_get_property(element.parent, "direction", pawpr_direction.row);
	parent_align = pawpr_style_get_property(element.parent, "align", pawpr_align.at_start);
	margin = pawpr_style_get_property(element, "margin", 0);
	margin_top = pawpr_style_get_property(element, "margin_top", margin);
	
	switch (parent_direction) {
		case pawpr_direction.column:
			if (is_undefined(element.previous)) {
				return element.parent.yoffset+parent_padding_top+margin_top;
			} else {
				var previous_margin, previous_margin_bottom;
				
				previous_margin = pawpr_style_get_property(element.previous, "margin", 0);
				previous_margin_bottom = pawpr_style_get_property(element.previous, "margin_bottom", previous_margin);
	
				return element.previous.yoffset+element.previous.height+previous_margin_bottom+margin_top;	
			}
			
		case pawpr_direction.row:
			switch (parent_align) {
				case pawpr_align.at_start:
					return element.parent.yoffset+parent_padding_top+margin_top;
					
				case pawpr_align.at_center:
					return element.parent.yoffset+(element.parent.height-element.height)/2;
					
				case pawpr_align.at_end:
					var margin_bottom;
					
					margin_bottom = pawpr_style_get_property(element, "margin_bottom", margin);
					
					return element.parent.yoffset+element.parent.height-parent_padding_bottom-element.height-margin_bottom;
					
				default:
					throw "Invalid element alignment";
			}
			
		default:
			throw "Invalid element direction";
	}
}

function pawpr_element_draw_default(element, draw_func) {
	var bg_alpha, padding, padding_left, padding_top, padding_right, padding_bottom, bounding_rect, border_alpha, previous_color, previous_alpha;
	
	bounding_rect = pawpr_element_get_bounding_rect(element);
	
	padding = pawpr_style_get_property(element, "padding", 0);
	padding_left = pawpr_style_get_property(element, "padding_left", padding);
	padding_top = pawpr_style_get_property(element, "padding_top", padding);
	padding_right = pawpr_style_get_property(element, "padding_right", padding);
	padding_bottom = pawpr_style_get_property(element, "padding_bottom", padding);	
	bg_alpha = pawpr_style_get_property(element, "background_alpha", 0);
	border_alpha = pawpr_style_get_property(element, "border_alpha", 0);
	
	previous_color = draw_get_color();
	previous_alpha = draw_get_alpha();

	if (bg_alpha > 0) {
		var bg_color, border_radius;
		
		bg_color = pawpr_style_get_property(element, "background_color", c_black);
		border_radius = pawpr_style_get_property(element, "border_radius", 0);
		
		draw_set_color(bg_color);
		draw_set_alpha(bg_alpha);
		draw_roundrect_ext(bounding_rect.left, bounding_rect.top, bounding_rect.right, bounding_rect.bottom, border_radius, border_radius, false);
		
	}
	
	if (border_alpha > 0) {
		var border_color;
		
		border_color = pawpr_style_get_property(element, "border_color", c_white);
		
		draw_set_color(border_color);
		draw_set_alpha(border_alpha);
		draw_roundrect_ext(bounding_rect.left, bounding_rect.top, bounding_rect.right, bounding_rect.bottom, border_radius, border_radius, true);
	}
	
	draw_set_color(previous_color);
	draw_set_alpha(previous_alpha);
	
	draw_func(element, bounding_rect.left+padding_left, bounding_rect.top+padding_top, bounding_rect.right-padding_right, bounding_rect.bottom-padding_bottom);
}

function pawpr_element_process_style(element, custom_properties_to_bypass=[]) {
	var class_names, n_classes, element_class, element_class_list, element_n_classes, properties_to_bypass;
	
	if (!variable_struct_exists(element, "style")) element.style = {};
	element_class = variable_struct_get(element, "class");
	
	if (is_undefined(element_class)) return;
	
	element_class_list = string_split(element_class, " ", true);
	element_n_classes = array_length(element_class_list);
	properties_to_bypass = array_concat(custom_properties_to_bypass, ["background_alpha", "border_radius", "direction", "align"])
	pawpr_style_join(element, element.parent.style, properties_to_bypass);
	class_names = struct_get_names(element.ui.stylesheet);
	n_classes = array_length(class_names);

	for (var i = element_n_classes-1; i >= 0; i--) {
		var class_name;
		
		class_name = element_class_list[i];
		
		for (var j = 0; j < n_classes; j++) {
			if (class_name == class_names[j]) {
				var class;
				
				class = variable_struct_get(ui.stylesheet, class_name);
				
				pawpr_style_join(element, class);
			}
		}
	}
}

function pawpr_style_join(element_base, style_joined, properties_to_bypass=[]) {
	var style_joined_property_names, style_joined_length, n_properties_to_bypass;
	
	style_joined_property_names = variable_struct_get_names(style_joined);
	style_joined_length = array_length(style_joined_property_names);
	n_properties_to_bypass = array_length(properties_to_bypass);
	
	for (var i = 0; i < style_joined_length; i++) {
		var property_name, property_value;
		
		property_name = style_joined_property_names[i];
		
		if (variable_struct_exists(element_base.style, property_name)) continue;
		
		for (var j = 0; j < n_properties_to_bypass; j++) {
			if (properties_to_bypass[j] == property_name) continue;
		}
		
		property_value = variable_struct_get(style_joined, property_name);
		
		variable_struct_set(element_base.style, property_name, property_value);
	}
}

function pawpr_create(x, y, content=[], stylesheet={}, horizontal_align=pawpr_align.at_start, vertical_align=pawpr_align.at_start, template=undefined) {
	if (is_undefined(template)) template = pawpr_template_create();
	if (!is_struct(stylesheet)) throw "Invalid stylesheet";
	if (!is_struct(template)) throw "Invalid template";
	
	return {
		x: x,
		y: y,
		horizontal_align: horizontal_align,
		vertical_align: vertical_align,
		stylesheet: stylesheet,
		template: template,
		content: content,
		elements: [],
		type: "container",
		parent: undefined,
		previous: undefined,
		xoffset: 0,
		yoffset: 0,
		event_triggers: {
			"on_mouse_over": function(element) {
				return element.is_mouse_over;
			},
			"on_mouse_out": function(element) {
				return !element.is_mouse_over;
			},
			"on_mouse_enter": function(element) {
				if (element.is_mouse_entering) {
					element.is_mouse_entering = false;
					return true;
				}
					
				return false;
			},
			"on_mouse_leave": function(element) {
				if (element.is_mouse_leaving) {
					element.is_mouse_leaving = false;
					return true;
				}
					
				return false;
			}
		},
		element_on_create: {
			"sprite": function(element) {
				if (!variable_struct_exists(element, "image_index")) element.image_index = 0;
				if (!variable_struct_exists(element, "image_speed")) element.image_speed = 0;
			}
		},
		element_on_update: {
			"sprite": function(element) {
				element.image_index = (element.image_index + element.image_speed) mod sprite_get_number(element.content);
			}
		},
		style_selectors: {
			"hover": function(element) {
				return element.is_mouse_over;
			}
		}
	}
}

function pawpr_add_event_trigger(ui, event_name, predicate) {
	var event_triggers;
	
	if (!is_struct(ui)) throw "Invalid UI";
	
	event_triggers = variable_struct_get(ui, "event_triggers");
	
	if (is_undefined(event_triggers)) throw "Malformed UI: Missing event triggers";
	
	variable_struct_set(event_triggers, event_name, predicate);
}

function pawpr_add_style_selector(ui, name, predicate) {
	var style_selectors;
	
	if (!is_struct(ui)) throw "Invalid UI";
	
	style_selectors = variable_struct_get(ui, "style_selectors");
	
	if (is_undefined(style_selectors)) throw "Malformed UI: Missing style_selectors";
	
	variable_struct_set(style_selectors, name, predicate);
}

function pawpr_add_element_on_create_function(ui, element, func) {
	var create_functions;
	
	if (!is_struct(ui)) throw "Invalid UI";
	
	create_functions = variable_struct_get(ui, "element_on_create");
	
	if (is_undefined(create_functions)) throw "Malformed UI: Missing element create functions";
	
	variable_struct_set(create_functions, element, func);
}

function pawpr_add_element_on_update_function(ui, element, func) {
	var update_functions;
	
	if (!is_struct(ui)) throw "Invalid UI";
	
	update_functions = variable_struct_get(ui, "element_on_update");
	
	if (is_undefined(update_functions)) throw "Malformed UI: Missing element update functions";
	
	variable_struct_set(update_functions, element, func);
}

function pawpr_build(ui, element=ui) {
	var type_template, types_to_process, n_types_to_process;
	
	if (!variable_struct_exists(element, "type")) element.type = "container";
	
	type_template = variable_struct_get(ui.template, element.type);
	if (is_undefined(type_template)) throw "Element type not found in template";
	
	element.width = 0;
	element.height = 0;
	element.xoffset = 0;
	element.yoffset = 0;
	element.is_mouse_over = false;

	pawpr_element_process_style(element);
	if (element != ui) array_push(ui.elements, element);
	
	if (element.type == "container") {
		var content_length;
		
		if (!is_array(element.content)) throw "The content of a container element must be an array";
		
		content_length = array_length(element.content);
		
		for (var i = 0; i < content_length; i++) {
			var element_current;
			
			element_current = element.content[i];
			element_current.parent = element;
			element_current.ui = ui;
			element_current.previous = (i == 0) ? undefined : element.content[i-1];
			pawpr_build(ui, element_current);
		}
	}
	
	element.width = type_template.get_width(element);
	element.height = type_template.get_height(element);
	
	if (ui == element) {
		var buffer_length;
		
		buffer_length = array_length(ui.elements);
	
		for (var i = 0; i < buffer_length; i++) {
			var element_current;
		
			element_current = ui.elements[i];
			element_current.xoffset = type_template.get_xoffset(element_current);
			element_current.yoffset = type_template.get_yoffset(element_current);
			element_current.is_mouse_over = pawpr_is_mouse_over(element_current);
		}
	}
	
	types_to_process = variable_struct_get_names(ui.element_on_create);
	n_types_to_process = array_length(types_to_process);
	
	for (var i = 0; i < n_types_to_process; i++) {
		var type_to_process;
		
		type_to_process = types_to_process[i];
		
		if (type_to_process == element.type) {
			var create_func;
			
			create_func = variable_struct_get(ui.element_on_create, type_to_process);
			create_func(element);
		}
	}
}

function pawpr_style_get_properties(element) {
	if (!is_struct(element)) {
		throw "Invalid element";	
	}
	
	if (!variable_struct_exists(element, "style")) {
		throw "Malformed element: missing style";	
	}
	
	return variable_struct_get_names(element.style);	
}

function pawpr_draw(ui) {
	var length;
	
	length = array_length(ui.elements);
	
	for (var i = 0; i < length; i++) {
		var element, type_template;
		
		element = ui.elements[i];
	
		if (!variable_struct_exists(element, "type")) throw "Malformed element: missing type";
	
		type_template = variable_struct_get(ui.template, element.type);
		if (is_undefined(type_template)) throw "Element type not found in template";
		
		type_template.draw(element);
	}
}

function pawpr_update(ui) {
	var n_elements, types_to_update, n_types_to_update;
	
	n_elements = array_length(ui.elements);
	types_to_update = variable_struct_get_names(ui.element_on_update);
	n_types_to_update = array_length(types_to_update);
	
	for (var i = 0; i < n_elements; i++) {
		var element;
		
		element = ui.elements[i];
		
		if (pawpr_is_mouse_over(element)) {
			if (!element.is_mouse_over) {
				element.is_mouse_over = true;
				element.is_mouse_entering = true;
			} else {
				element.is_mouse_entering = false;	
			}
		} else {
			if (element.is_mouse_over) {
				element.is_mouse_over = false;
				element.is_mouse_leaving = false;
			} else {
				element.is_mouse_leaving = false;	
			}
		}

		if (variable_struct_exists(element, "events")) {
			var element_event_names, n_element_events;
			
			element_event_names = variable_struct_get_names(element.events);
			n_element_events = array_length(element_event_names);
		
			for (var j = 0; j < n_element_events; j++) {
				var element_event_name, event_trigger;
			
				element_event_name = element_event_names[j];
			
				event_trigger = variable_struct_get(ui.event_triggers, element_event_name);
			
				if (is_undefined(event_trigger)) throw "Event not found in UI event triggers";
			
				if (event_trigger(element)) {
					pawpr_element_trigger_event(element, element_event_name);
				}
			}
		}
		
		for (var j = 0; j < n_types_to_update; j++) {
			var type_to_update;
			
			type_to_update = types_to_update[j];
			
			if (type_to_update == element.type) {
				var update_func;
				
				update_func = variable_struct_get(ui.element_on_update, type_to_update);
				update_func(element);
			}
		}
	}
}

function pawpr_element_trigger_event(element, event_name) {
	var element_event_callback;
				
	element_event_callback = variable_struct_get(element.events, event_name);
	if (is_undefined(element_event_callback)) throw "Event not found in element";
				
	element_event_callback(element);	
}

function pawpr_is_mouse_over(element) {
	var bounding_rect;
	
	bounding_rect = pawpr_element_get_bounding_rect(element);
	
	return point_in_rectangle(window_mouse_get_x(), window_mouse_get_y(), bounding_rect.left, bounding_rect.top, bounding_rect.right, bounding_rect.bottom);
}

function pawpr_element_get_bounding_rect(element) {
	var xbase, ybase, left, top, bottom, right, expansion, xoffset, yoffset;
	
	expansion = pawpr_style_get_property(element, "expansion", 1, false);
	
	if (expansion != 1) {
		var scale;
		
		scale = pawpr_style_get_property(element, "scale", 1, false);	
		xoffset = element.width*(expansion-scale)*.5;
		yoffset = element.height*(expansion-scale)*.5;
	} else {
		xoffset = 0;
		yoffset = 0;
	}
	
	switch (element.ui.horizontal_align) {
		case pawpr_align.at_center:
			xbase = element.ui.x-element.ui.width/2;
			break;
			
		case pawpr_align.at_end:
			xbase = element.ui.x-element.ui.width;
			break;
		
		default:
			xbase = element.ui.x;
			break;
	}
	
	switch (element.ui.vertical_align) {
		case pawpr_align.at_center:
			ybase = element.ui.y-element.ui.height/2;
			break;
			
		case pawpr_align.at_end:
			ybase = element.ui.y-element.ui.height;
			break;
		
		default:
			ybase = element.ui.y;
			break;
	}
	
	left = xbase+element.xoffset-xoffset;
	top = ybase+element.yoffset-yoffset;
	right = left+element.width+xoffset;
	bottom = top+element.height+yoffset;
	
	return {
		left: left,
		top: top,
		right: right,
		bottom: bottom
	}
}

function pawpr_template_create(custom_types={}) {
	var template, custom_type_names, n_custom_types;
	
	template = {
		"string": {
			draw: function(element) {
				pawpr_element_draw_default(element, function(element, x, y) {
					var scale, line_separation, line_width, color, alpha, shadow_color, shadow_alpha, shadow_xdist, shadow_ydist,
						color_previous, alpha_previous, halign_previous, valign_previous, font, font_previous, expansion;
					
					alpha = pawpr_style_get_property(element, "alpha", 1);
					if (alpha <= 0) return;
					scale = pawpr_style_get_property(element, "scale", 1);
					color = pawpr_style_get_property(element, "color", c_white);	
					font = pawpr_style_get_property(element, "font", -1);
					line_separation = pawpr_style_get_property(element, "line_separation", -1);
					line_width = pawpr_style_get_property(element, "line_width", -1);
					shadow_color = pawpr_style_get_property(element, "shadow_color", c_black);
					shadow_alpha = pawpr_style_get_property(element, "shadow_alpha", 0);
					shadow_xdist = pawpr_style_get_property(element, "shadow_xdistance", 1);
					shadow_ydist = pawpr_style_get_property(element, "shadow_ydistance", 1);
					expansion = pawpr_style_get_property(element, "expansion", 1);
				
					color_previous = draw_get_color();
					alpha_previous = draw_get_alpha();
					halign_previous = draw_get_halign();
					valign_previous = draw_get_valign();
					font_previous = draw_get_font();
					
					draw_set_color(color);
					draw_set_alpha(alpha);
					draw_set_font(font);
					draw_set_halign(fa_left);
					draw_set_valign(fa_top);
					
					pawpr_draw_text_ext_transformed_shadow(
						x, y, element.content, line_separation, line_width, (scale+expansion)*.5, (scale+expansion)*.5, 0, shadow_color, shadow_alpha, shadow_xdist, shadow_ydist);
					
					draw_set_color(color_previous);
					draw_set_alpha(alpha_previous);
					draw_set_halign(halign_previous)
					draw_set_valign(valign_previous);
					draw_set_font(font_previous);
				});	
			},
			
			get_width: function(element) {
				return pawpr_element_get_width_default(element, function(element) {
					var scale, line_separation, line_width, font, font_previous, width;
					
					font_previous = draw_get_font();
					
					scale = pawpr_style_get_property(element, "scale", 1);
					line_separation = pawpr_style_get_property(element, "line_separation", -1);
					line_width = pawpr_style_get_property(element, "line_width", -1);
					font = pawpr_style_get_property(element, "font", -1);
					
					width = string_width_ext(element.content, line_separation, line_width)*scale;
					
					draw_set_font(font_previous);
					return width;
				});
			},
			
			get_height: function(element) {
				return pawpr_element_get_height_default(element, function(element) {
					var scale, line_separation, line_width, font, font_previous, height;
					
					font_previous = draw_get_font();
					
					scale = pawpr_style_get_property(element, "scale", 1);
					line_separation = pawpr_style_get_property(element, "line_separation", -1);
					line_width = pawpr_style_get_property(element, "line_width", -1);
					font = pawpr_style_get_property(element, "font", -1);
					
					height = string_height_ext(element.content, line_separation, line_width)*scale;
					
					draw_set_font(font_previous);
					return height;
				});
			},
			
			get_xoffset: pawpr_element_get_xoffset_default,	
			get_yoffset: pawpr_element_get_yoffset_default
		},
	
		"sprite": {
			draw: function(element) {
				pawpr_element_draw_default(element, function(element, x, y) {
					var scale, color, alpha, expansion;
					
					scale = pawpr_style_get_property(element, "scale", 1);
					color = pawpr_style_get_property(element, "color", c_white);
					alpha = pawpr_style_get_property(element, "alpha", 1);
					expansion = pawpr_style_get_property(element, "expansion", 1);
					
					draw_sprite_ext(element.content, element.image_index, x, y, (scale+expansion)*.5, (scale+expansion)*.5, 0, color, alpha);
				});
			},
			
			get_width: function(element) {
				return pawpr_element_get_width_default(element, function(element) {
					var scale;
					
					scale = pawpr_style_get_property(element, "scale", 1);
					
					return sprite_get_width(element.content)*scale;
				});
			},
			
			get_height: function(element) {
				return pawpr_element_get_height_default(element, function(element) {
					var scale;
					
					scale = pawpr_style_get_property(element, "scale", 1);
					
					return sprite_get_height(element.content)*scale;
				});
			},
			
			get_xoffset: pawpr_element_get_xoffset_default,	
			get_yoffset: pawpr_element_get_yoffset_default
		},
		
		"container": {
			draw: function(element) {
				pawpr_element_draw_default(element, function() {});
			},
			
			get_width: function(element) {
				return pawpr_element_get_width_default(element, function(element) {
					var dir, content_length, width;
					
					content_length = array_length(element.content);
					width = 0;
					dir = pawpr_style_get_property(element, "direction", pawpr_direction.row);
					
					for (var i = 0; i < content_length; i++) {
						var child, child_margin, child_margin_left, child_margin_right, width_partial;
						
						child = element.content[i];
						child_margin = pawpr_style_get_property(child, "margin", 0);
						child_margin_left = pawpr_style_get_property(child, "margin_left", child_margin);
						child_margin_right = pawpr_style_get_property(child, "margin_right", child_margin);
						width_partial = child_margin_left + child.width + child_margin_right;
						
						switch (dir) {
							case pawpr_direction.row:
								width += width_partial;
								break;
								
							case pawpr_direction.column:
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
				return pawpr_element_get_height_default(element, function(element) {
					var dir, content_length, height;
					
					content_length = array_length(element.content);
					height = 0;
					dir = pawpr_style_get_property(element, "direction", pawpr_direction.row);
					
					for (var i = 0; i < content_length; i++) {
						var child, child_margin, child_margin_top, child_margin_bottom, height_partial;
						
						child = element.content[i];
						child_margin = pawpr_style_get_property(child, "margin", 0);
						child_margin_top = pawpr_style_get_property(child, "margin_top", child_margin);
						child_margin_bottom = pawpr_style_get_property(child, "margin_bottom", child_margin);
						height_partial = child_margin_top + child.height + child_margin_bottom;
						
						switch (dir) {
							case pawpr_direction.row:
								height += height_partial;
								break;
								
							case pawpr_direction.column:
								height = max(height, height_partial);
								break;
								
							default:
								throw "Invalid element direction";
						}
					}
					
					return height;
				});
			},
			
			get_xoffset: pawpr_element_get_xoffset_default,
			get_yoffset: pawpr_element_get_yoffset_default
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