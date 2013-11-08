package org.decatime.ui.component;

import openfl.Assets;

import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Shape;
import flash.display.Graphics;

import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;

import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;

import flash.geom.Rectangle;
import flash.geom.Matrix;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.text.Font;
import flash.text.AntiAliasType;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.ui.BaseBitmapElement;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.primitive.RoundRectangle;

import org.decatime.event.IObserver;
import org.decatime.event.IObservable;

class ListBox extends BaseContainer implements IObserver {
	private static var NAMESPACE:String = "org.decatime.ui.component.List :";
	public static var EVT_ITEM_SELECTED:String = NAMESPACE + "EVT_ITEM_SELECTED";
	
	public var showScrollBar(default, default): Bool;
	public var drawBorder(default, default): Bool;

	private var renderer:BaseBitmapElement;
	private var dataRenderer:BitmapData;
	private var listContainer: VBox;
	private var vsBar1:VerticalScrollBar;
	private var tfield:TextField;
	private var fontRes:Font;
	private var listItems:Array<IPrintable>;
	private var selectedItem:IPrintable;
	private var selectedItemIndex:Int;

	private var itemsCount:Int;
	private var itemsHeight:Int;
	private var firstVisibleIndex:Int;
	private var visibleItemsCount:Int;
	private var shpBackground:Shape;

	private var borderDecorator: RoundRectangle;
	private var borderDecoratorShape: Shape;

	public function new(name:String, fontRes:String) {
		super(name);
		this.buttonMode = true;
		this.renderer = new BaseBitmapElement();
		this.renderer.cacheAsBitmap = true;
		this.renderer.setResizable(false);
		this.listItems = new Array<IPrintable>();
		this.itemsHeight = 16;
		this.firstVisibleIndex = 0;
		this.selectedItemIndex = -1;
		this.selectedItem = null;
		this.visibleItemsCount = 0;

		this.tfield = new TextField();
		this.tfield.selectable = false;
		this.tfield.autoSize = TextFieldAutoSize.LEFT;
		this.tfield.mouseEnabled = false;
		this.fontRes = Assets.getFont(fontRes);
		this.createEmbeddedFontTextFormat();
		this.tfield.antiAliasType = AntiAliasType.ADVANCED;
		this.tfield.text = '';
		this.itemsCount = 0;
		this.shpBackground = new Shape();
		this.showScrollBar = true;
		this.elBackColorVisibility = 1.0;
		this.drawBorder = true;
	}

	public function add(value:IPrintable): Void {
		this.listItems.push(value);
		this.itemsCount = this.listItems.length;
	}

	public function getListCount(): Int {
		return this.listItems.length;
	}

	public function getItemsHeight(): Int {
		return this.itemsHeight;
	}

	public function setItemsHeight(value:Int): Void {
		this.itemsHeight = value;
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		
		if (this.dataRenderer != null) { 
			this.dataRenderer.dispose(); 
			this.dataRenderer = null;
		}

		var vsbarWidth: Float = vsBar1 != null ? vsBar1.width : 0;

		this.dataRenderer = new BitmapData(Std.int(r.width - vsbarWidth), Std.int(r.height), true);
		this.renderer.bitmapData = this.dataRenderer;
		
		this.visibleItemsCount = Std.int(r.height / this.itemsHeight);

		draw(r);
		updateScrollBar();


		if (this.borderDecoratorShape == null) {
			this.borderDecoratorShape = new Shape();
			this.borderDecorator = new RoundRectangle(this.borderDecoratorShape.graphics);
			this.parent.addChild(this.borderDecoratorShape);
			var f:Array<BitmapFilter> = new Array<BitmapFilter>();
	    
		    var shadowFilter:DropShadowFilter = new DropShadowFilter(3, 45, 0x000000, 1, 2, 2, 2, 2, false, false, false);
		    f.push(shadowFilter);
		    this.borderDecoratorShape.filters = f;
		}
		var rCopy: Rectangle = r.clone();
		rCopy.x = rCopy.x - 2;
		rCopy.y = rCopy.y - 2;
		rCopy.width += 4;
		rCopy.height += 4;
		this.borderDecorator.draw(rCopy);
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case VerticalScrollBar.EVT_SCROLL_DOWN,
				VerticalScrollBar.EVT_SCROLL_UP:
				this.firstVisibleIndex = data;
				if (this.firstVisibleIndex > this.itemsCount - this.visibleItemsCount) { 
					this.firstVisibleIndex = this.itemsCount - this.visibleItemsCount;
				}
				if (this.firstVisibleIndex < 0) { this.firstVisibleIndex = 0; }
				draw(this.sizeInfo);
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


		this.container.create(1.0, listContainer);

		if (this.showScrollBar) {
			// A Vertical Scroll bar
			vsBar1 = new VerticalScrollBar('VsBar1');
			vsBar1.addListener(this);
			vsBar1.setStepSize(1);
			this.container.create(24, vsBar1);

			this.addChild(vsBar1);
		}

		this.listContainer.create(1.0, this.renderer);
		this.addChild(this.renderer);
	}

	private override function initializeEvent(): Void {
		this.addEventListener(FocusEvent.FOCUS_IN, onFocusInEvt);
		this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutEvt);
		this.addEventListener(MouseEvent.MOUSE_DOWN, onListMouseDown);
	}


	private function draw(r:Rectangle): Void {	
		if (! this.initialized) { return; }	
		var r:Rectangle    = this.listContainer.getCurrSize();
		var startIndex:Int = this.firstVisibleIndex;
		var endIndex:Int   = this.visibleItemsCount + this.firstVisibleIndex;
		var currItmIdx:Int = 0;
		var g:Graphics     = this.shpBackground.graphics;
		
		g.clear();
		g.beginFill(0xffffff, 1);
		g.drawRect(0, 0, r.width, r.height);
		g.endFill;

		this.dataRenderer.draw(this.shpBackground, null, null, BlendMode.ERASE);
		for (i in startIndex...endIndex) {
			if (this.listItems == null || this.listItems.length == i) { break; }
			this.tfield.text = this.listItems[i].toString();
			
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
				m
			);

			currItmIdx = currItmIdx + this.itemsHeight;
		}
		
		if (this.drawBorder) {
			r = this.listContainer.getCurrSize();
			var shContour:Shape = new Shape();
			g = shContour.graphics;
			g.clear();
			g.lineStyle(1, 0x000000);
			g.drawRect(0,  0, r.width - 1, r.height - 1);
			g.endFill();
			this.dataRenderer.draw(
				shContour,
				null,
				null,
				BlendMode.ADD,
				null,
				false
			);
		}
	}

	
	private function moveNext(): Void {
		this.firstVisibleIndex++;
		if (this.firstVisibleIndex > (this.itemsCount - this.visibleItemsCount)) { 
			this.firstVisibleIndex = this.itemsCount - this.visibleItemsCount;
		}
		this.draw(this.sizeInfo);
		this.updateScrollBar();
	}

	private function movePrevious(): Void {
		this.firstVisibleIndex--;
		if (this.firstVisibleIndex < 0) { this.firstVisibleIndex = 0; }

		this.draw(this.sizeInfo);
		this.updateScrollBar();
	}

	private function updateScrollBar(): Void {
		if (this.vsBar1 == null) { return; }
		// the thumb is being dragged
		if (this.vsBar1.isScrolling()) { return; }

		this.vsBar1.setStepCount(this.itemsCount);
		this.vsBar1.setStepPos(this.firstVisibleIndex);
		this.vsBar1.setStepSize(this.itemsHeight);
		this.vsBar1.setVisibleHeight(this.listContainer.getCurrSize().height / this.visibleItemsCount);
		this.vsBar1.updatePos();
	}

	private function createEmbeddedFontTextFormat(): Void {
		var format:TextFormat = new TextFormat(
			this.fontRes.fontName,
			12, 
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
		if (this.selectedItemIndex < this.listItems.length) {
			this.selectedItem = this.listItems[this.selectedItemIndex];
			this.notify(EVT_ITEM_SELECTED, this.selectedItem);
		}
	}

	private function onListMouseDown(e:MouseEvent): Void {
		trace ("ListBox::onListMouseDown: START");
		if (e.ctrlKey) {
			this.selectedItemIndex = -1;
			draw(this.sizeInfo);
			return;
		}
		var xpos:Int = Std.int(e.localX - this.listContainer.getCurrSize().x);
		
		if (xpos >= this.listContainer.getCurrSize().width) { return; }

		this.stage.focus = this;
		this.addEventListener(MouseEvent.MOUSE_OUT, onListMouseOut);
		this.selectItem(e);
		draw(this.sizeInfo);
		trace ("ListBox::onListMouseDown: END");
	}

	private function onListMouseOut(e:MouseEvent): Void {
		if( this.stage == null) { return; }
		this.stage.focus = null;
	}

	private function onFocusInEvt(e:FocusEvent): Void {
		this.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
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