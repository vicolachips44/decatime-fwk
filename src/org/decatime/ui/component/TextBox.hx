package org.decatime.ui.component;

import openfl.Assets;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.text.Font;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Stage;
import flash.display.DisplayObject;
import flash.geom.Rectangle;
import flash.display.Shape;
import flash.display.Graphics;
import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;

import org.decatime.ui.layout.ILayoutElement;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.event.EventManager;
import org.decatime.ui.primitive.RoundRectangle;


class TextBox extends TextField implements ILayoutElement implements ITabStop implements IObservable {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.TextBox :";
	public static var EVT_KEYUP:String = NAMESPACE + "EVT_KEYUP";

	private var sizeInfo:Rectangle;
	private var fontRes:Font;
	private var color:Int;
	private var fontSize:Int;
	private var margin:Point;
	private var initialized:Bool;
	private var asBorder:Bool;
	private var isBold:Bool;
	private var txtBorderColor:Int;
	private var evManager:EventManager;

	#if !(flash || html5)
	private var tabIndex:Int;
	#end

	private var borderColorFocus:Int;
	private var borderDecorator: RoundRectangle;
	private var borderDecoratorShape: Shape;

	public function new(name:String, ?text:String = ' ', ?color:Int=0x000000) {
		super();
		this.name = name;
		this.type = TextFieldType.INPUT;
		this.mouseEnabled = true;
		this.selectable = true;
		this.autoSize = TextFieldAutoSize.NONE;
		this.margin = new Point(2, 2);
		evManager = new EventManager(this);
		// if the text length is equal to zero the caret will not be visible in the TextBox
		// for some platforms.
		this.text = '';
		this.fontSize = 12;
		this.asBorder = false;
		this.txtBorderColor = 0x000000;
		this.borderColorFocus = 0x0000fa;

		#if !(flash || html5)
		this.tabIndex = -1; // must be setted client side
		#end

		this.addEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn);
		this.addEventListener(FocusEvent.FOCUS_OUT, onTxtFocusOut);

		this.isBold = false;
		
	}

	public function setMargin(p:Point): Void {
		this.margin = p;
		this.updateDisplay();
	}

	public function getMargin(): Point {
		return this.margin;
	}

	public function setFontRes(fontRes:String): Void {
		this.fontRes = Assets.getFont(fontRes);
		this.updateDisplay();
	}

	public function setFontSize(size:Int): Void {
		this.fontSize = size;
		this.updateDisplay();
	}

	public function setIsBold(value: Bool): Void {
		this.isBold = value;
	}

	public function getIsBold(): Bool {
		return this.isBold;
	}

	public function getColor(): Int {
		return this.color;
	}

	public function setColor(value:Int): Void {
		this.color = value;
		this.updateDisplay();
	}

	public function setBorderColorFocus(value:Int): Void {
		this.borderColorFocus = value;
	}

	public function setTxtBorderColor(value:Int): Void {
		this.txtBorderColor = value;
	}

	// IObservable implementation

	public function addListener(observer:IObserver): Void {
		evManager.addListener(observer);
	}
	public function removeListener(observer:IObserver): Void {
		evManager.removeListener(observer);
	}

	public function notify(name:String, data:Dynamic): Void {
		evManager.notify(name, data);
	}

	// IObservable implementation END

	// ITabStop implementation BEGIN

	public function getTabIndex(): Int {
		return this.tabIndex;
	}

	public function setTabIndex(value:Int): Void {
		this.tabIndex = value;
	}

	public function setAsBorder(value:Bool): Void {
		this.asBorder = value;
	}

	public function setFocus(): Void {
		flash.Lib.current.stage.focus = this;
	}

	// ITabStop implementation END

	// ILayoutElement implementation BEGIN

	public function refresh(r:Rectangle): Void {
		this.sizeInfo = r;
		
		this.x = r.x + margin.x;
		this.y = r.y + margin.y;
		this.width = r.width - (margin.x * 2);
		this.height = r.height - (margin.y * 2);

		this.draw(r);

		this.initialized = true;
	}

	public function getCurrSize(): Rectangle {
		return sizeInfo;
	}

	public function setVisible(value:Bool): Void {
		this.visible = value; // TextField property
	}

	// ILayoutElement implementation END

	private function draw(r: Rectangle): Void {
		createEmbeddedFontTextFormat();
		this.border = asBorder;
		this.borderColor = txtBorderColor;
		if (this.asBorder == false) {
			this.drawBorderDecorator(r);
		}
	}

	private function drawBorderDecorator(r: Rectangle): Void {
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
		rCopy.x --;
		rCopy.y --;
		rCopy.width += 2;
		rCopy.height += 2;
		this.borderDecorator.draw(rCopy);
	}

	private function updateDisplay(): Void {
		// if the initial drawing was done we can call agin the refresh method.
		if (this.initialized) {
			this.refresh(this.sizeInfo);
		}
	}

	private function createEmbeddedFontTextFormat(): Void {
		var format:TextFormat = new TextFormat(
			this.fontRes.fontName, 
			this.fontSize, 
			this.color,
			this.isBold
		);

		this.embedFonts = true;
		this.defaultTextFormat = format;
		this.setTextFormat(format);
	}

	private function onStageKeyUp(e:KeyboardEvent): Void {
		if (e.keyCode == 9) {
			e.keyCode = 0; // prevent an infinite loop...
			processTabIndex();
		}

		this.notify(EVT_KEYUP, e);
	}

	private function processTabIndex(): Void {
		var nbChilds:Int = this.parent.numChildren;
		var i:Int = 0;
		var smallestTbIndex:Int = 100;
		var nextTabElement:ITabStop = null;

		for (i in 0...nbChilds) {
			var child:DisplayObject = this.parent.getChildAt(i);
			
			if (Std.is(child, ITabStop)) {
				var tbHandler:ITabStop = cast(child, ITabStop);
				
				if (tbHandler.getTabIndex() == -1) {
					trace ("warning: the tab index has not been setted on child " + child.name);
					continue;
				}

				if (tbHandler.getTabIndex() == this.getTabIndex() + 1) {
					tbHandler.setFocus();
					return;	
				}
				if (tbHandler.getTabIndex() < smallestTbIndex) {
					nextTabElement = tbHandler;
					smallestTbIndex = tbHandler.getTabIndex();
				}
			}
		}
		// we give the focus to the smallest tab index value
		if (nextTabElement != null) {
			nextTabElement.setFocus();
		}
	}

	private function onTxtFocusIn(e:FocusEvent): Void {
		this.stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
		this.borderColor = this.borderColorFocus;
	}

	private function onTxtFocusOut(e:FocusEvent): Void {
		#if !flash
		this.stage.removeEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);
		#end

		this.borderColor = this.txtBorderColor;
	}
}