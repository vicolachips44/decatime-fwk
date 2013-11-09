package org.decatime;

import flash.Lib;
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import org.decatime.ui.component.BaseContainer;
import org.decatime.event.EventManager;

/**
* <p> 
* The Facade object is based on the singleton design pattern and is
* the entry point for the application. Every application using
* decatime framework make a call to the run method aka: 
* <pre>Facade.getInstance().run($application) where
* $application is the main application container.</pre></p>
* <p>Every layoutable objects within the framework area must implement the ILayoutElement
* interface.</p>
*/
class Facade extends EventManager {
	
	/** 
	* This event is fired when the initialisation event
	* as last. The listener (witch is a IObserver) must
	* register to the facade IObservable interface in order to
	* manage the event with it's handleEvent implementation.
	*/
	public static var EV_INIT:String = "org.decatime.Facade.EV_INIT";

	/** This event is fired when ever the stage is resized */
	public static var EV_RESIZE:String = "org.decatime.Facade.EV_RESIZE";

	private static var instance:Facade;

	private var root:BaseContainer;
	private var tmResize:Timer;
	private var tmNotifyResize:Timer;
	private var stageRect:Rectangle;

	/**
	* Private constructor since this object conforms
	* to the singleton design pattern
	*/
	private function new() {
		super(this);
		
		// setting default values for the stage rendering
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;

		Lib.current.stage.stageFocusRect = false;
	}

	/**
	* Singleton instance entry point.
	*/
	public static function getInstance(): Facade {
		if (instance == null) {
			instance = new Facade();
		}
		return instance;
	}

	/**
	* Accessor to the root element (primary element on the stage) 
	*/
	public function getRoot(): BaseContainer {
		return root;
	}

	#if !(flash || html5)
	/**
	* return the path separator to use
	*/
	public function getPathSeparator(): String {
        return Sys.systemName() == "Windows" ? "\\" : "/";
    }
    #end

	/**
	* The application is started by calling this method.</br>
	* When the BaseSpriteElement root instance has been added to the
	* stage an initialisation phase is begining that will raise EV_INIT
	* event when done.
	*/
	public function run(root:BaseContainer, ?bFullScreen:Bool = false): Void {
		if (bFullScreen) {
			Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN;
			Mouse.hide();
		}

		this.root = root;
		root.addEventListener(Event.ADDED_TO_STAGE, onRootAddedToStage);
		Lib.current.stage.addChild(root);
	}

	/**
    * The root has been added to stage
    **/
	private function onRootAddedToStage(e:Event): Void {
		root.removeEventListener(Event.ADDED_TO_STAGE, onRootAddedToStage);
		initialize();
	}

	private function initialize() {
		// We create a timer to manage the resize event
		tmResize = new Timer(1);
		tmResize.addEventListener(TimerEvent.TIMER, onTmResizeCycle);

		// We raise the initialisation event before building the UI main application
		notify(EV_INIT, root);

		tmNotifyResize = new Timer(100);
		tmNotifyResize.addEventListener(TimerEvent.TIMER, onTmNotifyResizeCycle);

		// we call it to build the all layout
		onResize(null);

		// we then map the event to the event listener function
		Lib.current.stage.addEventListener( Event.RESIZE, onResize);
	}

	private function onResize(e:Event): Void {
		if (tmResize.running) { return; }

		tmResize.start();
	}

	private function onTmResizeCycle(e:TimerEvent) {
		tmResize.stop();
		
		// get the stage geometry to call the refresh method on the root element
		stageRect = new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		
		// we ask the root element to layout it's content
		root.refresh(stageRect);

		// we notify for the resize with a delay of 100
		this.tmNotifyResize.start();
	}

	private function onTmNotifyResizeCycle(e:TimerEvent): Void {
		tmNotifyResize.stop();
		this.notify(EV_RESIZE, null);
	}
}