import org.decatime.Facade;


//import com.androiddemo.AndroidApplication;
import com.demo.Application;
// import com.Testin;
class Main {
	
	public function new () {
		#if dotest
		runTest();
        #else
        runApp();
        #end
	}

	private function runApp(): Void {
		trace ("begin");
		var app:Application = new Application();
		// var app: Testin = new Testin();
		Facade.getInstance().run(app);
	}

	private function runTest(): Void {
		var runner:haxe.unit.TestRunner = new haxe.unit.TestRunner();
		runner.add (new com.test.TestLayout());

		runner.run();
	}
}
	
