package org.decatime.ui.component;

import org.decatime.ui.layout.VBox;
import org.decatime.ui.BaseContainer;

class ListBox extends BaseContainer {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.ListBox :";
	public static var EVT_ITEM_CLICK:String = NAMESPACE + "EVT_ITEM_CLICK";


	public function new(name:String) {
		super(name);
	}
}