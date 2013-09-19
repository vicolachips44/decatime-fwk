import org.decatime.Facade;
import com.demo.Application;

class Main {
	
	public function new () {
		#if dotest
		runTest();
        #else
        runApp();
        #end
	}

	private function runApp(): Void {
		var app:Application = new Application();
		Facade.getInstance().run(app);
	}

	private function runTest(): Void {
		var runner:haxe.unit.TestRunner = new haxe.unit.TestRunner();
		runner.add (new com.test.TestLayout());

		runner.run();
	}
}
	
