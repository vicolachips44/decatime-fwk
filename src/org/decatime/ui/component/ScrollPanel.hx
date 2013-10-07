package org.decatime.ui.component;

import org.decatime.ui.component.BaseContainer;
import org.decatime.ui.component.VerticalScrollBar;
import org.decatime.ui.component.HorizontalScrollBar;
import org.decatime.ui.layout.HBox;
import org.decatime.ui.layout.VBox;
import org.decatime.ui.BaseSpriteElement;

class ScrollPanel extends BaseContainer {
	private var vsBar1: VerticalScrollBar;
	private var hsBar1: HorizontalScrollBar;
	private var scrollArea: BaseSpriteElement;
	private var scrollAreaContainer:VBox;

	public function getScrollArea(): BaseSpriteElement {
		return this.scrollArea;
	}
	
	private override function initializeComponent(): Void {
		this.container = new HBox(this);
		this.container.setVerticalGap(0);
		this.container.setHorizontalGap(0);

		this.scrollAreaContainer = new VBox(this.container);
		this.scrollAreaContainer.setVerticalGap(0);
		this.scrollAreaContainer.setHorizontalGap(0);

		this.scrollArea = new BaseSpriteElement('scrollArea1');
		this.scrollArea.buttonMode = false;
		this.scrollArea.elBackColor = 0xaabbff;
		this.scrollArea.elBackColorVisibility = 1.0;

		this.scrollAreaContainer.create(1.0, this.scrollArea);
		this.addChild(this.scrollArea);

		hsBar1 = new HorizontalScrollBar('hsbar1');
		this.scrollAreaContainer.create(24, hsBar1);
		this.addChild(hsBar1);

		this.container.create(1.0, this.scrollAreaContainer);

		vsBar1 = new VerticalScrollBar('vsbar1');
		this.container.create(24, vsBar1);
		this.addChild(vsBar1);
	}
}