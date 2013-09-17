
 
package org.decatime.event;

/*
* Small helper and adapter class to apply the IObservable pattern.
*/
class EventManager implements IObservable {

	private var observable:IObservable;
	private var observers:Array<IObserver>;
	
	/**
	* Default constructor that needs the IObservable instance to manage.
	*
	* @param observable IObservable instance to manage.
	*/
	public function new (observable:IObservable) {
		this.observable = observable;
		observers = new Array<IObserver>();
	}

	/**
	* method to add a IObserver instance to the list of observers.
	*
	* @param observer IObserver instance
	*/
	public function addListener(observer:IObserver): Void {
		observers.push(observer);
	}

	/**
	* method to remove an IObserver instance from the list of observers.
	*
	* @param observer IObserver instance
	*/
	public function removeListener(observer:IObserver): Void {
		observers.remove(observer);
	}

	/**
	* method that will notify all observers about the given event name.
	*
	* @param name the event Name
	* @param data the Dynamic content to broadcast with the event
	*/
	public function notify(name:String, data:Dynamic): Void {
		var obs:IObserver;

		for (obs in observers) {
			obs.handleEvent( name , observable , data );
		}
	}
}