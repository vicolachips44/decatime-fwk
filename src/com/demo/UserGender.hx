package com.demo;

import org.decatime.ui.component.IPrintable;

class UserGender implements IPrintable {
	private var value1:String;

	public function new(value: String) {
		value1 = value;
	}

	public function toString(): String {
		return value1;
	}
}