package org.decatime.ui.component;

class ListItem extends BaseSelected {

	public function new(name:String) {
		super(name);
		this.visible = false;
	}

	private override function drawSelected(): Void {
		//this.label.setBackColor(0xcccccc);
		releaseFocus();
	}

	private override function drawUnselected(): Void {
		//this.label.setBackColor(0xffffff);
		releaseFocus();
	}

	private function releaseFocus(): Void {
		if (this.parent != null && ! Std.is(this.stage.focus, this.parent)) {
			this.stage.focus = this.parent;	
		}
	}
}