package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObserver;
import org.decatime.event.IObservable;
import org.decatime.event.EventManager;
import org.decatime.ui.primitive.Arrow;

/**
* ArrowButton is a kind of button that is displayed has an arrow that can be
* oriented to Left, Right, Top and bottom. It can be use in Scrollbars, treeviews,
*/
class ArrowButton extends BaseSpriteElement  implements IObservable {
	private static var NAMESPACE:String = "org.decatime.ui.componnet.BaseScrollBar :";

	/** Event raised when the button is clicked */
	public static var EVT_CLICK:String = NAMESPACE + "EVT_CLICK";

	private var orientation:String;
	private var evManager:EventManager;
	private var blurFx:BlurFilter;
	private var primitiveArrow: Arrow;


	/**
	* Construct a new instance of arrow button.
	*
	* @param name:String a name
	* @orientation (can be Arrow.ORIENTATION-LEFT, Arrow.ORIENTATION_RIGHT, Arrow.ORIENTATION_BOTTOM, Arrow.ORIENTATION_TOP)
	*/
	public function new(name:String, orientation: String) {
		super(name);
		evManager = new EventManager(this);
		this.orientation = orientation;
		this.addEventListener(MouseEvent.CLICK, onMouseClick);
		this.blurFx = new BlurFilter(2, 2, 2);
		this.filters = [blurFx];
		this.cacheAsBitmap = true;
		this.primitiveArrow = new Arrow(this.graphics, orientation);
	}

	/**
	* Override of the refresh of the ILayoutElement implementation to draw the Arrow.
	*/
	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		this.drawArrow();
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

	private function drawArrow(): Void {
		this.primitiveArrow.draw(this.sizeInfo);
	}

	private function onMouseClick(e:MouseEvent): Void {
		// Relay the click event on me
		evManager.notify(EVT_CLICK, this.name);
	}
}