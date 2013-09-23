package com.demo;

import flash.geom.Rectangle;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.Facade;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.Content;
import org.decatime.ui.component.Label;
import org.decatime.ui.component.PngButton;
import org.decatime.ui.component.Textbox;

import flash.text.TextFormat;

class Application extends BaseSpriteElement implements IObserver {

	private var layout:VBox;
	private var lblTitle:Label;
	private var testCount:Int = 0;
	private var txtTwo:Textbox;

	public function new() {
		super('DemoApplication');

		// I am the main container and i do not handle mouse events (for now...)
		this.buttonMode = false;

		Facade.getInstance().addListener(this);
		layout = new VBox(this);

	}

	public override function refresh(r:Rectangle): Void {
		super.refresh(r);
		layout.refresh(r);
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case Facade.EV_INIT:
				initializeComponent();
			case PngButton.EVT_PNGBUTTON_CLICK:
				this.lblTitle.setText('this is a new text number: ' + testCount++ + '!!');
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			Facade.EV_INIT,
			PngButton.EVT_PNGBUTTON_CLICK
		];
	}

	// IObserver implementation END

	private function initializeComponent() {
		this.lblTitle = new Label('DECATIME FRAMEWORK DEMO - V1');
		this.lblTitle.setFontRes('assets/BepaOblique.ttf');
		this.lblTitle.setAlign(Label.CENTER);
		this.lblTitle.setFontSize(24);
		this.lblTitle.setColor(0x0000ff);
		this.lblTitle.setVerticalGap(0);
		this.lblTitle.setBackColor(0xafafaf);
		layout.create(32, this.lblTitle);
		this.addChild(this.lblTitle);

		var btn:PngButton = new PngButton('btnChangeLabelCaption', 'assets/btn_add_cold.png', 'assets/btn_add_hot.png');
		btn.addListener(this);
		layout.create(48, btn);
		this.addChild(btn);

		var txt:Textbox = new Textbox('txtInputElement');
		txt.setFontRes('assets/BepaOblique.ttf');
		txt.setTabIndex(1);
		layout.create(32, txt);
		this.addChild(txt);

		txtTwo = new Textbox('txt2InputElement');
		txtTwo.setFontRes('assets/BepaOblique.ttf');
		txtTwo.setTabIndex(2);
		layout.create(64, txtTwo);
		txtTwo.multiline = true;
		this.addChild(txtTwo);

	}
}