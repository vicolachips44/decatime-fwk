package com.demo;
import openfl.Assets;

import flash.geom.Point;
import flash.display.Bitmap;
import flash.display.BitmapData;
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
import org.decatime.ui.component.windows.BrowseForFile;

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
				var mnuFileQuit: String = "File" + MenuItem.PATH_SEPARATOR + "Quit";
				var mnuFileOpen: String = "File" + MenuItem.PATH_SEPARATOR + "Open...";
				var mnuEditUndo: String = "Edit" + MenuItem.PATH_SEPARATOR + "Undo";
				var mnuEditRedo: String = "Edit" + MenuItem.PATH_SEPARATOR + "Redo";

				if (data == mnuFileQuit) {
					flash.system.System.exit(0);
				}

				if (data == mnuFileOpen) {
                    
					var bfile:BrowseForFile = new BrowseForFile('select file...', new Point(600, 480), 'assets/Vera.ttf');
					bfile.setBitmapFile(new Bitmap(Assets.getBitmapData('assets/file.png')));
					bfile.setBitmapDirectory(new Bitmap(Assets.getBitmapData('assets/directory.png')));
					
					bfile.show(this.windowManager);
                    
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
		this.mnuBar.setMenuColor(0x000000);
		this.mnuBar.setMenuOverColor(0xffffff);
		this.mnuBar.setFontColor(0xffffff);
		this.mnuBar.setFontOverColor(0x000000);

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
		hbox1.setVerticalGap(4);
		hbox1.setHorizontalGap(4);

		this.container.create(1.0, hbox1);

		var demoList: ListBox = new ListBox('demoList', 'assets/BepaOblique.ttf');
		demoList.drawBorder = false;
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