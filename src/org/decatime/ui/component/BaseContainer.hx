package org.decatime.ui.component;

import flash.geom.Rectangle;
import flash.display.Stage;

import org.decatime.ui.layout.BoxBase;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.event.EventManager;
import org.decatime.ui.layout.HBox;

/**
* <b>Sprite->BaseSpriteElement->BaseContainer.</b>
* <p>The BaseContainer implements the IObservable and
* contains by default a horizontal layout.</p>
* <p> Objects that inherit this BaseContainer must override
* the initializeComponent method in order to build the UI.
* After the first call to the refresh method the instance initialized
* property is setted to true.
*/
class BaseContainer extends BaseSpriteElement implements IObservable {

	private var container:BoxBase;
	private var initialized:Bool;
	private var evManager:EventManager;
	private var myStage:Stage;

	/** 
	* default constructor.
	* 
	* @param name: String the name of this container.
	*/
	public function new(name:String) {
		super(name);
		this.buttonMode = false;
		evManager = new EventManager(this);
		this.myStage = flash.Lib.current.stage;
	}

	/**
	* The refresh method is overrided in order to implement
	* the initialization routine. We call the initalizeComponent
	* if the instance is not initialized.
	* every time this method is called, the refresh method of the
	* inner container is also called.
	* 
	* @param r:Rectangle the size rect to fit in
	*
	* @return Void
	*/
	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		if (! this.initialized){
			initializeComponent();
		}
		if (this.container == null) {
			throw new flash.errors.Error("The container object has not been initialized");
		}
		this.container.refresh(r);
		
		if (! this.initialized) {
			initializeEvent();
			layoutComponent();
		}

		this.initialized = true;
	}

	/** IObservable implementation **/
	public function addListener(observer:IObserver): Void {
		evManager.addListener(observer);
	}

	/** IObservable implementation **/
	public function removeListener(observer:IObserver): Void {
		evManager.removeListener(observer);
	}

	/** IObservable implementation **/
	public function notify(name:String, data:Dynamic): Void {
		evManager.notify(name, data);
	}

	// IObservable implementation END

	/**
	* Initialize the default container.
	*/
	private function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);
	}

	/**
	* can be use to do some additionnal layout stuff.
	*/
	private function layoutComponent(): Void {
		// trace ("this method is called once after the first refresh method call");
	}

	/**
	* can be use to initialize the eventListener of components.
	*/
	private function initializeEvent(): Void {
		// trace ("BaseContainer : no implementation for initializeEvent at the moment");
	}
}