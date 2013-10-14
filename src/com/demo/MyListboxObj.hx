package com.demo;

import org.decatime.ui.component.IPrintable;

class MyListboxObj implements IPrintable {
	private var value1:String;
	private var value2:Int;

	public function new(index:Int) {
		value1 = 'list item ';
		value2 = index;
	}

	public function toString(): String {
		return value1 + Std.string(value2);
	}
}