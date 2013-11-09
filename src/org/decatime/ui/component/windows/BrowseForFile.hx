package org.decatime.ui.component.windows;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.EmptyLayout;
import flash.geom.Point;
import flash.geom.Rectangle;

import flash.filesystem.File;
import flash.filesystem.StorageVolume;
import flash.filesystem.StorageVolumeInfo;

import flash.display.Bitmap;
import flash.events.MouseEvent;
import org.decatime.Facade;
import org.decatime.ui.component.ListBox;
import org.decatime.ui.component.TextLabel;
import org.decatime.ui.component.Button;
import org.decatime.ui.primitive.Arrow;
import org.decatime.ui.BaseSpriteElement;
import org.decatime.event.IObservable;

class BrowseForFile extends Window {
    inline private static var NAMESPACE:String = "org.decatime.ui.component.windows.BrowseForFile";
    public static inline var EVT_FILE_SELECTED: String = NAMESPACE + "EVT_FILE_SELECTED";
    
	private var pathSeparator: String;
	private var rootPath: String;
    private var lblPath: TextLabel;
    private var lblSelectedItem: TextLabel;
	private var bmpFile: Bitmap;
	private var bmpDirectory: Bitmap;
	private var itemList: ListBox;
    private var bfileItems: Array<BrowseForFileItem>;
    private var btnCancel: Button;
    private var btnOk: Button;
    private var arrowUp: Arrow;
    private var arrowContainer: BaseSpriteElement;


	public function new(name:String, in_size:Point, fontResPath:String) {
		super(name, in_size, fontResPath);

		this.pathSeparator = Facade.getInstance().getPathSeparator();
		this.rootPath = File.userDirectory.nativePath;
        
    }

    public override function refresh(r:Rectangle): Void {
        super.refresh(r);
        this.arrowUp.draw(new Rectangle(0, 0, 24, 24));
    }

    public function setRootPath(value: String): Void {
    	this.rootPath = value;
    }

    public function getRootPath(): String {
    	return this.rootPath;
    }

    public function setBitmapFile(bmp: Bitmap): Void {
    	this.bmpFile = bmp;
    }

    public function setBitmapDirectory(bmp: Bitmap): Void {
    	this.bmpDirectory = bmp;
    }

    private function loadWinDrives(): Void {
        
        var volumes:Array<StorageVolume> = StorageVolumeInfo.getInstance().getStorageVolumes();
        var volume:StorageVolume = null;
        
        for (volume in volumes) {
            this.bfileItems.push(new BrowseForFileItem(volume.drive, this.bmpDirectory));
        }

        for (item in this.bfileItems) {
            this.itemList.add(item);
        }

        this.itemList.draw(this.itemList.getCurrSize());
    }

    private function onArrowClick(e:MouseEvent): Void {
        var lpath:String = this.rootPath.substr(0, this.rootPath.lastIndexOf(pathSeparator));
        if (lpath == "" && pathSeparator == "/") { lpath = pathSeparator; }
        if (lpath.length == 1 && pathSeparator == "\\") { 
            lpath += ":"; 
            this.loadWinDrives();
            this.rootPath = lpath;
        } else {
            this.rootPath = lpath;
            drawList();
        }
        this.lblPath.setText(this.rootPath);
    }

    private function clearList(): Void {
        this.itemList.clear();
        if (this.itemList.getCurrSize() != null) {
            this.itemList.refresh(this.itemList.getCurrSize());
        }
        this.bfileItems = new Array<BrowseForFileItem>();

    }

    private function drawList(): Void {
        var files:Array<String> = sys.FileSystem.readDirectory(this.rootPath);

        clearList();

        var file: String = "";
        for (file in files) {

            var lpath:String = file.substr(0, 1) == this.pathSeparator ? file : this.rootPath + this.pathSeparator + file;
            if (sys.FileSystem.isDirectory(lpath)) {
                this.bfileItems.push(new BrowseForFileItem(file, this.bmpDirectory));
            } else {
                this.bfileItems.push(new BrowseForFileItem(file, this.bmpFile));
            }
        }

        for (item in this.bfileItems) {
            this.itemList.add(item);
        }

        this.itemList.draw(this.itemList.getCurrSize());
        this.itemList.updateScrollBar();
    }

    private override function buildClientArea(): Void {
    	// the clientArea is a VBOX
        this.clientArea.setVerticalGap(4);
        var hbox1: HBox = new HBox(this.clientArea);
        this.clientArea.create(40, hbox1);

        this.lblPath = new TextLabel(this.rootPath);
        this.lblPath.setFontRes(this.fontResPath);
        hbox1.create(1.0, this.lblPath);
        this.addChild(this.lblPath);

        this.arrowContainer = new BaseSpriteElement('arrowContainer');
        this.arrowContainer.isContainer = false;
        this.arrowContainer.addEventListener(MouseEvent.CLICK, onArrowClick);
        this.arrowUp = new Arrow(this.arrowContainer.graphics, Arrow.ORIENTATION_TOP);

        hbox1.create(24, this.arrowContainer);
        this.addChild(this.arrowContainer);

        this.itemList = new ListBox('lstItems', this.fontResPath);
        this.itemList.addListener(this);
        this.clientArea.create(1.0, this.itemList);
        this.addChild(this.itemList);

        var hbox2: HBox = new HBox(this.container);
        this.container.create(40, hbox2);

        this.lblSelectedItem = new TextLabel('');
        this.lblSelectedItem.setFontRes(this.fontResPath);

        hbox2.create(1.0, this.lblSelectedItem);
        this.addChild(this.lblSelectedItem);

        this.btnCancel = new Button('Cancel', this.fontResPath);
        this.btnCancel.addListener(this);
        hbox2.create(80, this.btnCancel);
        this.addChild(this.btnCancel);

        this.btnOk = new Button('Ok', this.fontResPath);
        this.btnOk.addListener(this);
        hbox2.create(80, this.btnOk);
        this.addChild(this.btnOk);
        this.drawList();
    }

    public override function handleEvent(name:String, sender:IObservable, data:Dynamic): Void {
        super.handleEvent(name, sender, data);
        switch (name) {
            case ListBox.EVT_ITEM_DBLCLICK:
                var bfileItem: BrowseForFileItem = cast (data, BrowseForFileItem);
                var lpath: String = this.rootPath + this.pathSeparator + bfileItem;
                if (bfileItem.getBitmap() == this.bmpFile) {
                    
                } else {
                    trace ("directory path is " + lpath);
                    this.rootPath = lpath;
                    this.lblPath.setText(lpath);
                    this.drawList();
                }
            case ListBox.EVT_ITEM_SELECTED:
                var bfileItem: BrowseForFileItem = cast (data, BrowseForFileItem);
                this.lblSelectedItem.setText(bfileItem.toString());
            case Button.EVT_CLICK:
                var btn: Button = cast (data, Button);
                if (btn == this.btnOk) {
                    this.notify(EVT_FILE_SELECTED, this.rootPath + this.pathSeparator + this.lblSelectedItem.text);
                }
                this.remove();
        }
    }

    public override function getEventCollection(): Array<String> {
        var parentAy:Array<String> = super.getEventCollection();
        parentAy.push(ListBox.EVT_ITEM_DBLCLICK);
        parentAy.push(ListBox.EVT_ITEM_SELECTED);
        return parentAy;
    }
}