import org.decatime.Facade;
import com.demo.Application;

class Main {
	
	public function new () {
		var app:Application = new Application();
		Facade.getInstance().run(app);
	}
}
	
