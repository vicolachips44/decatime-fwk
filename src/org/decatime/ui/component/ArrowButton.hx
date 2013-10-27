package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.events.MouseEvent;
import flash.display.Graphics;
import flash.display.GradientType;
import flash.filters.BlurFilter;
import flash.geom.Matrix;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.event.EventManager;

/**
* ArrowButton is a kind of button that is displayed has an arrow that can be
* oriented to Left, Right, Top and bottom. It can be use in Scrollbars, treeviews,
*/
class ArrowButton extends BaseSpriteElement  implements IObservable {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.BaseScrollBar :";

	/** Event raised when the button is clicked */
	public static var EVT_CLICK:String = NAMESPACE + "EVT_CLICK";

	/** left orientation for this button */
	public static inline var ORIENTATION_LEFT:String = "left";

	/** right orientation for this button */
	public static inline var ORIENTATION_RIGHT:String = "right";

	/** top orientation for this button */
	public static inline var ORIENTATION_TOP:String = "top";

	/** bottom orientation for this button */
	public static inline var ORIENTATION_BOTTOM:String = "bottom";

	private var initialized:Bool;
	private var orientation:String;
	private var evManager:EventManager;
	private var blurFx:BlurFilter;

	/**
	* Construct a new instance of arrow button.
	*
	* @param name:String a name
	* @orientation (can be ORIENTATION-LEFT, ORIENTATION_RIGHT, ORIENTATION_BOTTOM, ORIENTATION_TOP)
	*/
	public function new(name:String, orientation: String) {
		super(name);
		evManager = new EventManager(this);
		this.orientation = orientation;
		this.addEventListener(MouseEvent.CLICK, onMouseClick);
		this.blurFx = new BlurFilter(2, 2, 2);
		this.filters = [blurFx];
	}

	/**
	* Override of the refresh of the ILayoutElement implementation to draw the Arrow.
	*/
	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		if (! this.initialized) {
			this.drawArrow();
		}
		this.initialized = true;
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

	// TODO Fix me since its ugly...
	private function drawArrow(): Void {
		var box:Matrix = new Matrix();
		var g:Graphics = this.graphics;
		g.clear();

		g.beginFill(0xdfdfdf);
		g.drawRect(this.sizeInfo.x, this.sizeInfo.y, this.sizeInfo.width, this.sizeInfo.height);
		g.endFill();

		var lx: Float = this.sizeInfo.x + 3;
		var ly: Float = this.sizeInfo.y + 3;
		var lw: Float = this.sizeInfo.width - 6;
		var lh: Float = this.sizeInfo.height - 6;

		g.lineStyle(0.4, 0x000000, 1, true, 
			flash.display.LineScaleMode.VERTICAL,
			flash.display.CapsStyle.NONE, 
			flash.display.JointStyle.ROUND);
		
		box.createGradientBox(this.sizeInfo.width, this.sizeInfo.height, 45, this.sizeInfo.x, this.sizeInfo.y);
		
		if (orientation == ORIENTATION_TOP) {	
			g.beginGradientFill(GradientType.LINEAR, [0xc0c0c0, 0x808080], [1, 1], [1, 255], box);
			g.moveTo(lx, ly + lw);
			g.lineTo(lx + lw, ly + lh);
			g.lineTo(lx + (lw / 2), ly);
			g.lineTo(lx, ly + lw);
		}		
		if (orientation == ORIENTATION_BOTTOM) {
			g.beginGradientFill(GradientType.LINEAR, [0xc0c0c0, 0x808080], [1, 1], [1, 255], box);
			g.moveTo(lx, ly);
			g.lineTo(lx + lw, ly);
			g.lineTo(lx + (lw / 2), ly + lw);
			g.lineTo(lx, ly);
		}
		if (orientation == ORIENTATION_LEFT) {
			g.beginGradientFill(GradientType.LINEAR, [0xc0c0c0, 0x808080], [1, 1], [1, 255], box);
			g.moveTo(lx + lw, ly);
			g.lineTo(lx + lw, ly + lh);
			g.lineTo(lx, ly + (lh / 2));
			g.lineTo(lx + lw, ly);
		}
		if (orientation == ORIENTATION_RIGHT) {
			g.beginGradientFill(GradientType.LINEAR, [0xc0c0c0, 0x808080], [1, 1], [1, 255], box);
			g.moveTo(lx, ly);
			g.lineTo(lx, ly + lh);
			g.lineTo(lx + lw, ly + (lh / 2));
			g.lineTo(lx, ly);
		}
		g.endFill();
		
	}

	private function onMouseClick(e:MouseEvent): Void {
		// Relay the click event on me
		evManager.notify(EVT_CLICK, this.name);
	}
}