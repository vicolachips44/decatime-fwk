package org.decatime.ui.component.table;

/*
* All objects that can be an editor for the cell of a table
*/
interface ITableEditor {

	/**
	* returns the DisplayObject instance of this
	*/ 
	function getDisplayObject(): flash.display.InteractiveObject;

	/**
	* to set the position of the DisplayObject instance
	*/
	function setPosition(r:flash.geom.Rectangle): Void;

	/*
	* toggle the visibility of the DisplayObject instance
	*/
	function setVisible(value:Bool): Void;

	/**
	* Set the initial value
	*/ 
	function setValue(newValue: String): Void;

	/*
	* Returns the current value
	*/
	function getValue(): String;
}