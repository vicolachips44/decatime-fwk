package com.test;

import org.decatime.ui.layout.VBox;
import org.decatime.ui.layout.Content;

import flash.geom.Rectangle;

class TestLayout extends haxe.unit.TestCase {


	public function testVboxLayoutTwoContent(): Void {
		var obj:LayoutElementObj = new LayoutElementObj('testFixture');
		var vbox:VBox = new VBox(obj);
		assertTrue(vbox != null);

		var content1:Content = vbox.create(50, new LayoutElementObj('component1'));
		assertTrue(content1 != null);

		var content2:Content = vbox.create(1.0, new LayoutElementObj('component2'));

		var r:Rectangle = new Rectangle(0 , 0 , 400 , 300);
		vbox.refresh(r);

		// The size is absolute so it remain the same
		assertEquals(content1.getCurrSize().height, 50);
		assertEquals(content1.getCurrSize().x, 4);
		assertEquals(content1.getCurrSize().y, 4);

		// The size is relative to the remaining height
		assertEquals(content2.getCurrSize().x, 4);
		assertEquals(content2.getCurrSize().y, 58);
		assertEquals(content2.getCurrSize().height, 238);
	}

	public function testVboxLayout(): Void {
		var obj:LayoutElementObj = new LayoutElementObj('testFixture');
		var vbox:VBox = new VBox(obj);
		assertTrue(vbox != null);

		var content1:Content = vbox.create(50, new LayoutElementObj('component1'));
		assertTrue(content1 != null);

		var content2:Content = vbox.create(1.0, new LayoutElementObj('component2'));

		var content3:Content = vbox.create(30, new LayoutElementObj('component3'));

		var r:Rectangle = new Rectangle(0 , 0 , 400 , 300);
		vbox.refresh(r);

		// The size is absolute so it remain the same
		assertEquals(content1.getCurrSize().height, 50);
		assertEquals(content1.getCurrSize().x, 4);
		assertEquals(content1.getCurrSize().y, 4);

		// The size is relative to the remaining height
		assertEquals(content2.getCurrSize().x, 4);
		assertEquals(content2.getCurrSize().y, 58);
		assertEquals(content2.getCurrSize().height, 204);

		assertEquals(content3.getCurrSize().x, 4);
		assertEquals(content3.getCurrSize().y, 266);
		assertEquals(content3.getCurrSize().height, 30);
	}
}