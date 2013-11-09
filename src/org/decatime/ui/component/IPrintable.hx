package org.decatime.ui.component;

interface IPrintable {
    function toString() : String;
    function getBitmap(): flash.display.Bitmap;
}