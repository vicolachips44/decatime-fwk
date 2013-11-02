package org.decatime.ui.component.canvas.style;

interface IFeedbackProvider {
    function processDown(xpos: Float, ypos: Float) : Void;
    function processMove(xpos: Float, ypos: Float): Bool;
    function processUp(xpos: Float, ypos: Float): Void;
}