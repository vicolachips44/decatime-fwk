package org.decatime.ui.component.table;

import flash.geom.Rectangle;
import flash.display.Graphics;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.ui.component.ScrollPanel;

class TableView extends BaseContainer implements IObserver {
	private var scPanel: ScrollPanel;
	private var headerArea: HBox;

	public function new(name:String) {
		super(name);
	}
	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
	
	}

	public function getEventCollection(): Array<String> {
		return [
			
		];
	}

	// IObserver implementation END

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		
		var g:Graphics = this.graphics;
		
		g.clear();

		g.lineStyle(1, 0x000000);
		g.drawRect(r.x, r.y, r.width, r.height);

	}

	private override function initializeComponent(): Void {
		this.container = new VBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);
		this.headerArea = new HBox(this.container);
		this.headerArea.setHorizontalGap(0);
		this.headerArea.setVerticalGap(0);
		this.container.create(24, this.headerArea);
		
		this.scPanel = new ScrollPanel('scPanel1');
		this.container.create(1.0, this.scPanel);
		this.addChild(this.scPanel);
	}
}