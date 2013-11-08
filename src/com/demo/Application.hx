package com.demo;

import flash.geom.Point;
import flash.system.System;
import org.decatime.ui.component.BaseContainer;
import org.decatime.event.IObservable;
import org.decatime.event.IObserver;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.Content;
import org.decatime.ui.component.ListBox;
import org.decatime.ui.component.windows.Window;
import org.decatime.ui.component.windows.Manager;
import org.decatime.ui.component.menu.MenuBar;
import org.decatime.ui.component.menu.MenuItem;

class Application extends BaseContainer implements IObserver {

	private var mnuBar: MenuBar;

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
				
				activeWindow = w;
				w.show(windowManager);

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
		// var fonts: Array<flash.text.Font> = flash.text.Font.enumerateFonts(true);
		// for (fnt in fonts) {
		// 	trace ("font is " + fnt.fontName);
		// }
		// trace ("font enumeration done");

		this.container = new VBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		this.mnuBar = new MenuBar('MainMenu', 'assets/Vera.ttf');
		this.mnuBar.addListener(this);
		var mnuFile : MenuItem = new MenuItem('File');
        mnuFile.setFontRes('assets/Vera.ttf');
        mnuFile.setFontSize(14);
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
        mnuEdit.setFontRes('assets/Vera.ttf');
        mnuEdit.setFontSize(14);
		this.mnuBar.addMenu(mnuEdit);
		
		mnuEdit.setSubItems ([
			new MenuItem('Cut', 'assets/menuIcons/cut.png'),
			new MenuItem('Copy', 'assets/menuIcons/copy.png'),
			new MenuItem('Paste', 'assets/menuIcons/paste.png'),
			new MenuItem(MenuItem.SEPARATOR),
			new MenuItem('Undo', 'assets/menuIcons/undo.png'),
			new MenuItem('Redo', 'assets/menuIcons/redo.png')
		]);

		var mnuProj : MenuItem = new MenuItem('Project');
        mnuProj.setFontRes('assets/Vera.ttf');
        mnuProj.setFontSize(14);
		this.mnuBar.addMenu(mnuProj);

		var mnuNewProj: MenuItem = new MenuItem('New...');


		mnuProj.setSubItems ([
			mnuNewProj,
			new MenuItem('Very long menu doing nothing')
		]);

		mnuNewProj.setSubItems(
			[new MenuItem('Sub item new proj 1'), new MenuItem('Sub item new Proj 2')]
		);
		
		this.container.create(20, this.mnuBar);
		this.addChild(this.mnuBar);

		var wxSimple: WxSimpleWindow = new WxSimpleWindow('wxSimple', new Point(600, 400), 'assets/Vera.ttf');
		var wxList:WxListBoxDemo = new WxListBoxDemo('ListBoxDemo', new Point(400, 480), 'assets/Vera.ttf');
		var wxTable:WxTableViewDemo = new WxTableViewDemo('WxTableViewDemo', new Point(720, 480), 'assets/VeraMono.ttf');
		var wxCombo:WxComboBoxDemo = new WxComboBoxDemo('WxComboBoxDemo', new Point(400, 480), 'assets/Vera.ttf');
		wxCanvas = new WxCanvasDemo('wxCanvas', new Point(400, 400), 'assets/Vera.ttf');
		var wxTextArea: WxTextAreaDemo = new WxTextAreaDemo('wxTextArea', new Point(600, 480), 'assets/Vera.ttf');
		
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
		demoList.add(wxTextArea);
		demoList.addListener(this);

		hbox1.create(160, demoList);
		this.addChild(demoList);

		windowManager = new Manager('applicationContainer');
		hbox1.create(1.0, windowManager);
		this.addChild(windowManager);
	}
}