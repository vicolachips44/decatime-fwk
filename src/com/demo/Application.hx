package com.demo;

import flash.geom.Rectangle;
import flash.geom.Point;

import org.decatime.ui.BaseSpriteElement;
import org.decatime.ui.component.BaseContainer;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.Facade;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.Content;
import org.decatime.ui.component.Label;
import org.decatime.ui.component.TextLabel;
import org.decatime.ui.component.PngButton;
import org.decatime.ui.component.TextBox;
import org.decatime.ui.component.TextArea;
import org.decatime.ui.component.ListBox;
import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.windows.WindowState;
import org.decatime.ui.component.windows.Manager;
import org.decatime.ui.component.canvas.DrawingSurface;
import org.decatime.ui.component.menu.MenuBar;
import org.decatime.ui.component.menu.MenuItem;

import flash.text.TextFormat;

class Application extends BaseContainer implements IObserver {

	private var lblTitle:Label;
	private var lblAppTitle: TextLabel;
	private var mnuBar: MenuBar;

	private var testCount:Int = 0;
	private var txtTwo:TextBox;
	private var appContainer: BaseSpriteElement;
	private var activeWindow: Window;
	private var windowManager: Manager;
	private var wxCanvas:WxCanvasDemo;

	public function new() {
		super('DemoApplication');
	}

	// IObserver implementation BEGIN

	public function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
		switch (name) {
			case ListBox.EVT_ITEM_SELECTED:
				var w:Window = cast(data, Window);
				// if (activeWindow != null) {
				// 	activeWindow.remove();
				// }

				activeWindow = w;
				w.show(windowManager);
				trace ("the new window is on stage!!");
			case MenuBar.MENUITEM_CLICK:
				trace (data + " clicked!");
				var mnuFileQuit: String = "File" + MenuItem.PATH_SEPARATOR + "Quit";
				var mnuEditUndo: String = "Edit" + MenuItem.PATH_SEPARATOR + "Undo";
				var mnuEditRedo: String = "Edit" + MenuItem.PATH_SEPARATOR + "Redo";

				if (data == mnuFileQuit) {
					flash.system.System.exit(0);
				}

				if (wxCanvas.getIsActiveAndVisible()) {
					if (data == mnuEditUndo) {
						wxCanvas.callUndo();
					}
					if (data == mnuEditRedo) {
						wxCanvas.callRedo();
					}
					this.mnuBar.setMenuItemState(mnuEditUndo, wxCanvas.canUndo());
					this.mnuBar.setMenuItemState(mnuEditRedo, wxCanvas.canRedo());
				}
		}
	}

	public function getEventCollection(): Array<String> {
		return [
			ListBox.EVT_ITEM_SELECTED,
			MenuBar.MENUITEM_CLICK
		];
	}

	// IObserver implementation END

	private override function initializeComponent() {
		this.container = new VBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		this.mnuBar = new MenuBar('MainMenu', 'assets/Vera.ttf');
		this.mnuBar.addListener(this);
		var mnuFile : MenuItem = new MenuItem('File');
		this.mnuBar.addMenu(mnuFile);
		
		mnuFile.setSubItems([
			new MenuItem('New', 'assets/menuIcons/new.png'),
			new MenuItem('Open...', 'assets/menuIcons/open.png'),
			new MenuItem('Save', 'assets/menuIcons/save.png'),
			new MenuItem('Save As...'),
			new MenuItem(MenuItem.SEPARATOR),
			new MenuItem('Quit', 'assets/menuIcons/quit.png')
		]);


		var mnuEdit : MenuItem = new MenuItem('Edit');
		this.mnuBar.addMenu(mnuEdit);
		
		mnuEdit.setSubItems ([
			new MenuItem('Cut', 'assets/menuIcons/cut.png'),
			new MenuItem('Copy', 'assets/menuIcons/copy.png'),
			new MenuItem('Paste', 'assets/menuIcons/paste.png'),
			new MenuItem(MenuItem.SEPARATOR),
			new MenuItem('Undo', 'assets/menuIcons/undo.png'),
			new MenuItem('Redo', 'assets/menuIcons/redo.png')
		]);


		this.container.create(20, this.mnuBar);
		this.addChild(this.mnuBar);

		// this.lblAppTitle = new TextLabel('DECATIME FRAMEWORK DEMO V1');
		// this.lblAppTitle.setFontRes('assets/1979rg.ttf');
		// this.lblAppTitle.setFontSize(24);
		// this.lblAppTitle.background = true;
		// this.lblAppTitle.backgroundColor = 0xbbbbbb;
		// this.lblAppTitle.border = true;
		// this.container.create(32, this.lblAppTitle);
		// this.addChild(this.lblAppTitle);

		var wxSimple: WxSimpleWindow = new WxSimpleWindow('wxSimple', new Point(600, 400), 'assets/Vera.ttf');
		var wxList:WxListBoxDemo = new WxListBoxDemo('ListBoxDemo', new Point(400, 480), 'assets/Vera.ttf');
		var wxTable:WxTableViewDemo = new WxTableViewDemo('WxTableViewDemo', new Point(720, 480), 'assets/VeraMono.ttf');
		var wxCombo:WxComboBoxDemo = new WxComboBoxDemo('WxComboBoxDemo', new Point(400, 480), 'assets/Vera.ttf');
		wxCanvas = new WxCanvasDemo('wxCanvas', new Point(400, 400), 'assets/Vera.ttf');
		
		var hbox1: HBox = new HBox(this.container);
		hbox1.setVerticalGap(2);
		hbox1.setHorizontalGap(2);

		this.container.create(1.0, hbox1);

		var demoList: ListBox = new ListBox('demoList', 'assets/BepaOblique.ttf');
		demoList.showScrollBar = false;
		demoList.add(wxSimple);
		demoList.add(wxList);
		demoList.add(wxTable);
		demoList.add(wxCombo);
		demoList.add(wxCanvas);
		
		demoList.addListener(this);

		hbox1.create(160, demoList);
		this.addChild(demoList);

		windowManager = new Manager('applicationContainer');
		hbox1.create(1.0, windowManager);
		this.addChild(windowManager);
	}
}