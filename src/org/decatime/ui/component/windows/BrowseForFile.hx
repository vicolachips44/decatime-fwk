package org.decatime.ui.component.windows;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.EmptyLayout;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.filesystem.File;
import flash.display.Bitmap;
import flash.events.MouseEvent;
import org.decatime.Facade;
import org.decatime.ui.component.ListBox;
import org.decatime.ui.component.TextLabel;
import org.decatime.ui.component.Button;
import org.decatime.ui.primitive.Arrow;
import org.decatime.ui.BaseSpriteElement;

class BrowseForFile extends Window {
	private var pathSeparator: String;
	private var rootPath: String;
    private var lblPath: TextLabel;

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
        this.arrowUp.draw(new Rectangle(0, 0, 32, 32));
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

    private function updatePath(direction: String): Void {
        if (direction == 'up') {

        } else {
            // down
        }
    }

    private function onArrowClick(e:MouseEvent): Void {
        updatePath('up');
        drawList();
    }

    private function clearList(): Void {
        this.itemList.clear();
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

        hbox1.create(32, this.arrowContainer);
        this.addChild(this.arrowContainer);

        this.itemList = new ListBox('lstItems', this.fontResPath);
        this.clientArea.create(1.0, this.itemList);
        this.addChild(this.itemList);

        var hbox2: HBox = new HBox(this.container);
        this.container.create(40, hbox2);

        hbox2.create(1.0, new EmptyLayout());
        this.btnCancel = new Button('Cancel', this.fontResPath);
        hbox2.create(80, this.btnCancel);
        this.addChild(this.btnCancel);

        this.btnOk = new Button('Ok', this.fontResPath);
        hbox2.create(80, this.btnOk);
        this.addChild(this.btnOk);
        this.drawList();
    }
}