package org.decatime.ui.component;

/*
* All objects that can respond to Tabstop and gain the focus
* within a same parent container must implement this interface.
*/
interface ITabStop {

	/*
	* return the tab index value (must be unique within the parent container collection)
	*/
	function getTabIndex(): Int;

	/*
	* sets the tab index value (must be unique within the parent container collection)
	*/
	function setTabIndex(value:Int): Void;

	/*
	* Ask the control that implements this behavior to grab the focus
	*/
	function setFocus(): Void;
}