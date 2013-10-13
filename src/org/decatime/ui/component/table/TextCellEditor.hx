package org.decatime.ui.component.table;

class TextCellEditor extends TextBox implements ICellEditor {
	public var table(default, default): TableView;

	public function new(table: TableView, name:String, ?text:String = ' ', ?color:Int=0x000000) {
		super(name, text, color);

		this.table = table;

		this.setFontRes(this.table.getFontRes());
		
		this.setAsBorder(false);
		this.setIsBold(false);
	}

	// ICellEditor implementation - BEGIN

	public function getDisplayObject(): flash.display.InteractiveObject {
		return this;
	}

	public function setPosition(r:flash.geom.Rectangle): Void {
		this.refresh(r);
	}

	public override function setVisible(value:Bool): Void {
		super.setVisible(value);
		if (value == true) {
			// this will only work with flash target
			this.setSelection(this.text.length, this.text.length);
		}
	}
	
	public function setValue(newValue: String): Void {
		this.text = newValue;
	}

	public function getValue(): String {
		return this.text;
	}

	// ICellEditor implementation - END
}