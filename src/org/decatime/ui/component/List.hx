package org.decatime.ui.component;

import openfl.Assets;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.BlendMode;
import flash.display.Shape;
import flash.display.Graphics;

import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;

import flash.geom.Rectangle;
import flash.geom.Matrix;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
import flash.text.Font;
import flash.text.AntiAliasType;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.ui.BaseBitmapElement;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;

class List extends BaseContainer implements IObserver {
	private static var NAMESPACE:String = "org.decatime.ui.component.List :";
	public static var EVT_ITEM_SELECTED:String = NAMESPACE + "EVT_ITEM_SELECTED";

	private var renderer:BaseBitmapElement;
	private var dataRenderer:BitmapData;
	private var listContainer: VBox;
	private var vsBar1:VerticalScrollBar;
	private var tfield:TextField;
	private var fontRes:Font;
	private var listItems:Array<String>;
	private var selectedItem:String;
	private var selectedItemIndex:Int;

	private var itemsCount:Int;
	private var itemsHeight:Int;
	private var firstVisibleIndex:Int;
	private var visibleItemsCount:Int;
	private var shpBackground:Shape;

	public function new(name:String, fontRes:String) {
		super(name);
		this.buttonMode = true;
		this.renderer = new BaseBitmapElement();
		this.listItems = new Array<String>();
		this.itemsHeight = 16;
		this.firstVisibleIndex = 0;
		this.selectedItemIndex = -1;
		this.selectedItem = '';

		this.tfield = new TextField();
		this.tfield.selectable = false;
		this.tfield.autoSize = TextFieldAutoSize.LEFT;
		this.tfield.mouseEnabled = false;
		this.fontRes = Assets.getFont(fontRes);
		this.createEmbeddedFontTextFormat();
		this.tfield.antiAliasType = AntiAliasType.ADVANCED;

		this.shpBackground = new Shape();
	}

	public function add(value:String): Void {
		this.listItems.push(value);
		this.itemsCount = this.listItems.length;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		draw();
		updateScrollBar();
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case VerticalScrollBar.EVT_SCROLL_DOWN,
				VerticalScrollBar.EVT_SCROLL_UP:
				this.firstVisibleIndex = data;
				draw();
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			VerticalScrollBar.EVT_SCROLL_UP,
			VerticalScrollBar.EVT_SCROLL_DOWN
		];
	}

	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		this.listContainer = new VBox(this.container);
		this.listContainer.setHorizontalGap(0);
		this.listContainer.setVerticalGap(0);

		// A Vertical Scroll bar
		vsBar1 = new VerticalScrollBar('VsBar1');
		vsBar1.addListener(this);
		vsBar1.setStepSize(1);

		this.container.create(1.0, listContainer);

		this.container.create(24, vsBar1);
		this.listContainer.create(1.0, this.renderer);

		this.addChild(vsBar1);
		this.addChild(this.renderer);
	}

	private override function initializeEvent(): Void {
		this.addEventListener(FocusEvent.FOCUS_IN, onFocusInEvt);
		this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutEvt);
		this.addEventListener(MouseEvent.MOUSE_DOWN, onListMouseDown);

		var r:Rectangle = this.listContainer.getCurrSize();
		this.dataRenderer = new BitmapData(Std.int(r.width), Std.int(r.height), true);
		this.renderer.bitmapData = this.dataRenderer;

		this.visibleItemsCount = Std.int(r.height / this.itemsHeight);
	}


	private function draw(): Void {		
		var r:Rectangle    = this.listContainer.getCurrSize();
		var startIndex:Int = this.firstVisibleIndex;
		var endIndex:Int   = this.visibleItemsCount + this.firstVisibleIndex;
		var currItmIdx:Int = 0;
		var g:Graphics     = this.shpBackground.graphics;
		
		g.clear();
		g.beginFill(0xffffff, 1);
		// g.lineStyle(2, 0x000000);
		g.drawRect(0, 0, r.width, r.height);
		g.endFill;

		this.dataRenderer.draw(this.shpBackground, null, null, BlendMode.ERASE);

		for (i in startIndex...endIndex) {
			this.tfield.text = this.listItems[i];

			var m:Matrix = new Matrix(
				1, 0, 0 , 1 , 2,
				(this.itemsHeight / 2) - (this.tfield.textHeight / 2)
			);
			m.translate(0, currItmIdx);

			if (selectedItemIndex == i) {
				g.clear();
				g.beginFill(0xaaaaaa, 0.5);
				g.drawRect(0, 0, r.width, this.itemsHeight);
				g.endFill();
				this.dataRenderer.draw(
					this.shpBackground,
					m,
					null,
					BlendMode.OVERLAY,
					null,
					false
				);
			}

			this.dataRenderer.draw(
				this.tfield,
				m,
				null,  
				BlendMode.ADD,
				null,
				true
			);

			currItmIdx = currItmIdx + this.itemsHeight;
		}

		r = this.container.getCurrSize();
		this.graphics.clear();
		this.graphics.lineStyle(1, 0x000000);
		this.graphics.drawRect(r.x, r.y, r.width, r.height);
		this.graphics.endFill();
	}

	private function moveNext(): Void {
		this.firstVisibleIndex++;
		if (this.firstVisibleIndex > this.itemsCount) { 
			this.firstVisibleIndex = this.itemsCount - this.visibleItemsCount;
		}
		this.draw();
		this.updateScrollBar();
	}

	private function movePrevious(): Void {
		this.firstVisibleIndex--;
		if (this.firstVisibleIndex < 0) { this.firstVisibleIndex = 0; }

		this.draw();
		this.updateScrollBar();
	}

	private function updateScrollBar(): Void {
		// the thumb is being dragged
		if (this.vsBar1.isScrolling()) { return; }

		this.vsBar1.setStepCount(this.itemsCount);
		this.vsBar1.setStepPos(this.firstVisibleIndex);
		this.vsBar1.setStepSize(this.itemsHeight);
		this.vsBar1.setVisibleHeight(this.listContainer.getCurrSize().height);
		this.vsBar1.updatePos();
	}

	private function createEmbeddedFontTextFormat(): Void {
		var format:TextFormat = new TextFormat(
			this.fontRes.fontName,
			10, 
			0x000000,
			false
		);
	
		this.tfield.embedFonts = true;
		this.tfield.defaultTextFormat = format;
		this.tfield.setTextFormat(format);
	}

	private function selectItem(e:MouseEvent): Void {
		var ypos:Int = Std.int(e.localY - this.listContainer.getCurrSize().y);
		var totalHeight:Int = visibleItemsCount * itemsHeight;
		var i:Int = 0;
		var index:Int = 0;

		while (i < totalHeight) {
			i += itemsHeight;
			if (ypos < i) {
				break;
			}
			index++;
		}
		this.selectedItemIndex = this.firstVisibleIndex + index;
		this.selectedItem = this.listItems[this.selectedItemIndex];
		this.notify(EVT_ITEM_SELECTED, this.selectedItem);
	}

	private function onListMouseDown(e:MouseEvent): Void {
		if (e.ctrlKey) {
			this.selectedItemIndex = -1;
			draw();
			return;
		}
		var xpos:Int = Std.int(e.localX - this.listContainer.getCurrSize().x);
		
		if (xpos >= this.listContainer.getCurrSize().width) { return; }

		this.stage.focus = this;
		this.addEventListener(MouseEvent.MOUSE_OUT, onListMouseOut);
		this.selectItem(e);
		draw();
	}

	private function onListMouseOut(e:MouseEvent): Void {
		this.stage.focus = null;
	}

	private function onFocusInEvt(e:FocusEvent): Void {
		this.myStage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
		this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvt);
	}

	private function onFocusOutEvt(e:FocusEvent): Void {
		this.myStage.removeEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
		this.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvt);
	}

	private function onMouseWheelEvt(e:MouseEvent): Void {
		if (e.delta == 0) { return; }
		if (e.delta > 0) {
			this.movePrevious();
		} else {
			this.moveNext();
		}
	}

	private function onStageKeyUp(e:KeyboardEvent): Void {
		if (e.keyCode == 40) { // down arrow
			this.movePrevious();
		}
		if (e.keyCode == 38) { // up arrow
			this.moveNext();
		}
	}
}