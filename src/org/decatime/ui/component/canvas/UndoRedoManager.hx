package org.decatime.ui.component.canvas;

import haxe.ds.IntMap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

class UndoRedoManager {
	private var canvas:DrawingSurface;
	private var data:BitmapData;
	private var undoLevel:Int;
	private var undoPosition:Int;
	private var slicePos:Int;

	private var bmdCacheHistory:IntMap<BitmapData>;

	public function new() {
		undoPosition = 1;
		slicePos = 1;
	}

	public function setData(in_data:BitmapData) : Void {
		this.data = in_data;
	}

	public function initialize(): Void {
		if (data != null) { 
			data.dispose();
		}
		
		if (bmdCacheHistory != null) {
			var nbEl:Int = Lambda.count(bmdCacheHistory);
			for (i in nbEl...1) {
				if (bmdCacheHistory.get(i) != null) {
					bmdCacheHistory.get(i).dispose();
					bmdCacheHistory.remove(i);
				}
			}
		}
		
		bmdCacheHistory = new IntMap<BitmapData>();
		undoPosition = 1;
	}

	public function setUndoLevel(value:Int): Void {
		undoLevel = value;
	}

	public function canUndo(): Bool {
		var tpos:Int = undoPosition - 2;
		var bMove:Bool = bmdCacheHistory.exists(tpos);
		return bMove;
	}

	public function undo(): Bool {
		var newPos:Int = undoPosition - 2;

		if (canUndo()) {
			updateDataValue(newPos);
			undoPosition = undoPosition - 1;
			return true;
		}
		return false;
	}

	private function updateDataValue(newPos:Int): Void {
		var bmCache:BitmapData = bmdCacheHistory.get(newPos);
		data.copyPixels(
			bmCache, 
			bmCache.rect, 
			new Point(0, 0)
		);
	}

	
	public function canRedo(): Bool {
		var tpos:Int = undoPosition;
		return bmdCacheHistory.exists(tpos);
	}

	public function redo(): Bool {
		var newPos:Int = undoPosition;
		if (canRedo()) {
			updateDataValue(newPos);
			undoPosition++;
			return true;
		}
		return false;
	}

	public function update(): Void {
		if (undoPosition > undoLevel) {
			//slice needed
			var toRemove:Int = undoPosition - undoLevel - 1;
			var bmd:BitmapData = bmdCacheHistory.get(toRemove);
			if (bmd != null) { bmd.dispose(); }
			bmdCacheHistory.remove(toRemove);
		}

		initUndoCache(undoPosition);

		var cacheHisto:BitmapData = bmdCacheHistory.get(undoPosition);
		
		cacheHisto.copyPixels(
			data, 
			new Rectangle(0, 0, data.width, data.height), 
			new Point(0,0)
		);
		
		undoPosition++;
	}

	private function initUndoCache(pos:Int): Void {
		bmdCacheHistory.set(
			pos, 
			new BitmapData(
				data.width, 
				data.height, 
				true, 
				0x000000
			)
		);
	}
}