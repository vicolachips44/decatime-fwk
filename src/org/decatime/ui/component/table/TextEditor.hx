package org.decatime.ui.component.table;

class TextEditor extends TextBox implements ITableEditor {
	public var table(default, default): TableView;

	public function new(table: TableView, name:String, ?text:String = ' ', ?color:Int=0x000000) {
		super(name, text, color);

		this.table = table;

		this.setFontRes(this.table.getFontRes());
		
		this.setAsBorder(false);
		this.setIsBold(false);
	}

	// ITableEditor implementation - BEGIN

	public function getDisplayObject(): flash.display.InteractiveObject {
		return this;
	}

	public function setPosition(r:flash.geom.Rectangle): Void {
		this.refresh(r);
	}

	public override function setVisible(value:Bool): Void {
		super.setVisible(value);
	}
	
	public function setValue(newValue: String): Void {
		this.text = newValue;
	}

	public function getValue(): String {
		return this.text;
	}

	// ITableEditor implementation - END
}