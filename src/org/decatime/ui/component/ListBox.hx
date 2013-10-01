package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.display.DisplayObject;

import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.ui.layout.Content;
import org.decatime.ui.component.ListItem;
import org.decatime.ui.component.BaseContainer;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;

class ListBox extends BaseContainer  implements IObserver {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.ListBox :";
	public static var EVT_ITEM_CLICK:String = NAMESPACE + "EVT_ITEM_CLICK";

	private var listItems:Array<ListItem>;
	private var listItemHeight: Int;
	private var firstVisibleIndex:Int;
	private var visibleCount:Int;
	private var listContainer:VBox;
	private var vsBar1:VerticalScrollBar;

	public function new(name:String) {
		super(name);
		this.isContainer = true;
		this.listItems = new Array<ListItem>();
		this.listItemHeight = 12;
		firstVisibleIndex = 0;
	}

	public function setListItemHeight(value:Int): Void {
		this.listItemHeight = value;
	}

	public function addItem(item:ListItem): Void {
		this.listItems.push(item);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		
		this.graphics.clear();
		this.graphics.lineStyle(1 ,0x000000 ,1.0);
		this.graphics.drawRect(r.x, r.y, r.width, r.height);

		updateList();
		updateScrollBar();
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case VerticalScrollBar.EVT_SCROLL_DOWN,
				VerticalScrollBar.EVT_SCROLL_UP:
				this.firstVisibleIndex = data;
				trace ("data value is " + data);
				this.updateList();
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			VerticalScrollBar.EVT_SCROLL_UP,
			VerticalScrollBar.EVT_SCROLL_DOWN
		];
	}

	// IObserver implementation END

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(1);
		this.container.setHorizontalGap(1);

		listContainer = new VBox(this.container);
		listContainer.setHorizontalGap(0);
		listContainer.setVerticalGap(0);

		// A Vertical Scroll bar
		vsBar1 = new VerticalScrollBar('VsBar1');
		vsBar1.addListener(this);
		vsBar1.setStepSize(4);
		
		this.container.create(1.0, listContainer);

		this.container.create(32, vsBar1);

		this.addChild(vsBar1);
	}

	private override function initializeEvent(): Void {

	}

	private function updateScrollBar(): Void {
		// the thumb is being dragged
		if (this.vsBar1.isScrolling()) { return; }

		this.vsBar1.setStepCount(this.listItems.length);
		this.vsBar1.setStepPos(this.firstVisibleIndex);
		this.vsBar1.setStepSize(this.listItemHeight);
		this.vsBar1.setVisibleHeight(this.listContainer.getCurrSize().height);
		trace ("updating scrollbar position from Listbox instance");
		this.vsBar1.updatePos();
	}

	private function updateList(): Void {
		var item:ListItem = null;
		var i:Int = 0;
		var j:Int = this.firstVisibleIndex;

		while (this.numChildren > 0) { this.removeChildAt(0); }
		this.addChild(vsBar1);

		this.listContainer.reset();
		this.visibleCount = 0;

		for (i in j...this.listItems.length) {
			item = this.listItems[i];
			if ((this.visibleCount + 1) * this.listItemHeight > this.listContainer.getCurrSize().height) {
				break;
			}
			
			this.listContainer.create(listItemHeight, item);
			this.addChild(item);

			this.visibleCount++;
		}
		this.listContainer.refresh(this.listContainer.getCurrSize());
	}
}