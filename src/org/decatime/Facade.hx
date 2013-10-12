package org.decatime;

import flash.Lib;
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.geom.Rectangle;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.EventManager;

class Facade extends EventManager {
	public static var EV_INIT:String = "org.decatime.Facade.EV_INIT";
	public static var EV_RESIZE:String = "org.decatime.Facade.EV_RESIZE";

	private static var instance:Facade;

	private var root:BaseSpriteElement;
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
	public function getRoot(): BaseSpriteElement {
		return root;
	}


	public function run(root:BaseSpriteElement, ?bFullScreen:Bool = false): Void {
		if (bFullScreen) {
			Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN;
			flash.ui.Mouse.hide();
		}

		this.root = root;
		root.addEventListener(Event.ADDED_TO_STAGE, onRootAddedToStage);
		Lib.current.stage.addChild(root);
	}

	private function onRootAddedToStage(e:Event): Void {
		root.removeEventListener(Event.ADDED_TO_STAGE, onRootAddedToStage);
		initialize();
	}

	private function initialize() {
		// We create a timer to manage the resize event
		tmResize = new Timer(1);
		tmResize.addEventListener(TimerEvent.TIMER, onTmResizeCycle);

		// We raise the initialisation event to build the UI from the main application
		notify(EV_INIT, root);

		tmNotifyResize = new Timer(100);
		tmNotifyResize.addEventListener(TimerEvent.TIMER, onTmNotifyResizeCycle);
		// we call it to get the initial size for the initialisation process
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