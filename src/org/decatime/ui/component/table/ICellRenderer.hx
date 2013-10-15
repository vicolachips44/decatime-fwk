package org.decatime.ui.component.table;

interface ICellRenderer {

	function alwaysShow(): Bool;
	/**
	* returns the DisplayObject instance of this
	*/ 
	function getDisplayObject(): flash.display.DisplayObject;

	/**
	* returns the Cell instance of this renderer
	*/ 
	function getParentCell(): Cell;

	/**
	* sets the Cell instance of this renderer
	*/
	function setParentCell(c:Cell): Void;

	/**
	* toggle the visibility of this renderer
	*/ 
	function setVisible(value:Bool): Void;

	/**
	* returns the geometry of this renderer
	*/ 
	function getCurrSize(): flash.geom.Rectangle;

	/**
	* sets the value to display on this renderer
	*/ 
	function setValue(value:Dynamic): Void;

	/**
	* gets the value to edit on this renderer
	*/ 
	function getValue(): Dynamic;
}