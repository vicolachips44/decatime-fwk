package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.display.DisplayObject;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.ui.component.HorizontalScrollBar;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;

class ScrollPanel extends BaseContainer implements IObserver {
	private var vsBar1: VerticalScrollBar;
	private var hsBar1: HorizontalScrollBar;
	private var scrollArea: BaseSpriteElement;
	private var scrollAreaContainer:VBox;
	private var scrollAreaRect:Rectangle;
	private var scrollRectPosY: Int;
	private var scrollRectPosX: Int;

	public function getScrollArea(): BaseSpriteElement {
		return this.scrollArea;
	}

	public function getScrollAreaContainer(): VBox {
		return this.scrollAreaContainer;
	}

	public function new(name:String) {
		super(name);
		
		// child objets will be added to this sprite
		this.scrollArea = new BaseSpriteElement('scrollArea1');
		this.scrollArea.buttonMode = false;
		this.scrollArea.isContainer = false;
		this.scrollArea.elBackColor = 0x000000;
		this.scrollArea.elBackColorVisibility = 1.0;

		// child objets will be layedout by this container
		this.scrollAreaContainer = new VBox(this.container);
		this.scrollAreaContainer.setVerticalGap(0);
		this.scrollAreaContainer.setHorizontalGap(0);

		this.scrollAreaContainer.create(1.0, this.scrollArea);

		this.scrollRectPosX = 0;
		this.scrollRectPosY = 0;

		this.addChild(this.scrollArea);
	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		draw();
		updateVsScrollBar();
		updateHsScrollBar();
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case VerticalScrollBar.EVT_SCROLL_DOWN,
				 VerticalScrollBar.EVT_SCROLL_UP:

				this.scrollRectPosY = data;
				draw();

			case HorizontalScrollBar.EVT_SCROLL_LEFT,
				 HorizontalScrollBar.EVT_SCROLL_RIGHT:
				this.scrollRectPosX = data;
				draw();
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			VerticalScrollBar.EVT_SCROLL_UP,
			VerticalScrollBar.EVT_SCROLL_DOWN,
			HorizontalScrollBar.EVT_SCROLL_LEFT,
			HorizontalScrollBar.EVT_SCROLL_RIGHT
		];
	}

	// IObserver implementation END	
	
	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		hsBar1 = new HorizontalScrollBar('hsbar1');
		hsBar1.addListener(this);

		var vb1:VBox = new VBox(this.container);
		vb1.setHorizontalGap(0);
		vb1.setVerticalGap(0);

		vb1.create(1.0, this.scrollAreaContainer);
		vb1.create(24, hsBar1);		

		this.container.create(1.0, vb1);

		vsBar1 = new VerticalScrollBar('vsbar1');
		vsBar1.addListener(this);
		this.container.create(24, vsBar1);

		this.addChild(hsBar1);	
		this.addChild(vsBar1);
	}

	private override function initializeEvent(): Void {
		this.addEventListener(FocusEvent.FOCUS_IN, onFocusInEvt);
		this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutEvt);
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
			movePrevious();
		} else {
			moveNext();
		}
	}

	private function onStageKeyUp(e:KeyboardEvent): Void {
		if (e.keyCode == 40) { // down arrow
			this.moveNext();
		}
		if (e.keyCode == 38) { // up arrow
			this.movePrevious();
		}
	}

	private function moveNext(): Void {
		this.scrollRectPosY = this.scrollRectPosY + 24;

		var avHeight: Float = Math.abs(this.scrollArea.getCurrSize().height);

		if (this.scrollRectPosY > avHeight) {
			this.scrollRectPosY = Std.int(avHeight);
		}
		updateScrollAreaRect();
		updateVsScrollBar();
	}

	private function movePrevious(): Void {
		this.scrollRectPosY = this.scrollRectPosY - 24;
		if (this.scrollRectPosY  < 0) { this.scrollRectPosY = 0; }
		updateScrollAreaRect();
		updateVsScrollBar();
	}

	private function updateVsScrollBar(): Void {
		if (this.vsBar1.isScrolling()) { return; }
		var avHeight: Float = Math.abs(this.scrollArea.getCurrSize().height) + this.scrollAreaContainer.getCurrSize().height;

		this.vsBar1.setStepCount(Std.int(avHeight));
		this.vsBar1.setStepPos(this.scrollRectPosY);
		this.vsBar1.setStepSize(24);
		this.vsBar1.setVisibleHeight(this.scrollAreaContainer.getCurrSize().height);
		this.vsBar1.updatePos();
	}

	private function updateHsScrollBar(): Void {
		if (this.hsBar1.isScrolling()) { return; }

		this.hsBar1.setStepCount(Std.int(this.scrollArea.width));
		this.hsBar1.setStepPos(this.scrollRectPosX);
		this.hsBar1.setStepSize(1);
		this.hsBar1.setVisibleWidth(this.scrollAreaContainer.getCurrSize().width);
		this.hsBar1.updatePos();
	}

	private function draw(): Void {
		this.graphics.lineStyle(1, 0x000000);
		this.graphics.drawRect(this.scrollAreaContainer.getCurrSize().x, this.scrollAreaContainer.getCurrSize().y, this.scrollAreaContainer.getCurrSize().width, this.scrollAreaContainer.getCurrSize().height);
		this.updateScrollAreaRect();
	}

	private function updateScrollAreaRect(): Void {
		if (this.scrollAreaRect == null) {
			this.scrollAreaRect = new Rectangle(
				this.scrollAreaContainer.getCurrSize().x, this.scrollAreaContainer.getCurrSize().y,
				this.scrollAreaContainer.getCurrSize().width,
				this.scrollAreaContainer.getCurrSize().height
			);
		} 


		this.scrollAreaRect.y = this.scrollRectPosY;
		this.scrollAreaRect.x = this.scrollRectPosX;
		this.scrollArea.scrollRect = this.scrollAreaRect;
	}
}