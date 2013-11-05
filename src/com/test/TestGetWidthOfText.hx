package com.test;
import flash.geom.Rectangle;
import flash.display.Stage;
import flash.Lib;

import org.decatime.ui.component.TextLabel;

class TestGetWidthOfText {

    public function new() {

        var stage: Stage = Lib.current.stage;
        var tlabel:TextLabel = new TextLabel('this is some text');
        tlabel.setFontRes('assets/Vera.ttf');
        tlabel.setFontSize(32);

        var lneededWidth: Float = tlabel.getTextWidth();
        var lneededHeight: Float = tlabel.getTextHeight();
        var r: Rectangle = new Rectangle(10, 10, lneededWidth, lneededHeight);
        tlabel.refresh(r);
        stage.addChild(tlabel);

        tlabel.text = "this is a new value much longer";
        lneededWidth = tlabel.getTextWidth();
        lneededHeight = tlabel.getTextHeight();
        var r: Rectangle = new Rectangle(10, 10, lneededWidth, lneededHeight);
        tlabel.refresh(r);
        #if !flash
        stage.graphics.lineStyle(1);
        stage.graphics.drawRect(10, 10, r.width, r.height);
        #end
    }
}