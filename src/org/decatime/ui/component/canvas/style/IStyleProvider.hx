package org.decatime.ui.component.canvas.style;

interface IStyleProvider {
    function processDown(xpos: Float, ypos: Float) : Void;
    function processMove(xpos: Float, ypos: Float): Void;
    function processUp(xpos: Float, ypos: Float): Void;
}