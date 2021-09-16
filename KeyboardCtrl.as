package {
	import flash.events.*;
	import flash.display.*;
	import flash.ui.Keyboard;



	public class KeyboardCtrl {
		

		public function KeyboardCtrl(stage:Stage) {
			
			
			stage.getChildByName("upBTN").addEventListener(MouseEvent.MOUSE_DOWN, onUpKeyDown);
			stage.getChildByName("downBTN").addEventListener(MouseEvent.MOUSE_DOWN, onDownKeyDown);
			stage.getChildByName("leftBTN").addEventListener(MouseEvent.MOUSE_DOWN, onLeftKeyDown);
			stage.getChildByName("rightBTN").addEventListener(MouseEvent.MOUSE_DOWN, onRightKeyDown);
			
			
			stage.getChildByName("upBTN").addEventListener(MouseEvent.MOUSE_UP, onUpKeyUp);
			stage.getChildByName("downBTN").addEventListener(MouseEvent.MOUSE_UP, onDownKeyUp);
			stage.getChildByName("leftBTN").addEventListener(MouseEvent.MOUSE_UP, onLeftKeyUp);
			stage.getChildByName("rightBTN").addEventListener(MouseEvent.MOUSE_UP, onRightKeyUp);
			
			
			stage.getChildByName("cam_upBTN").addEventListener(MouseEvent.MOUSE_DOWN, onCam_upKeyDown);
			stage.getChildByName("cam_downBTN").addEventListener(MouseEvent.MOUSE_DOWN, onCam_downKeyDown);
			
			stage.getChildByName("cam_upBTN").addEventListener(MouseEvent.MOUSE_UP, onCam_upKeyUp);
			stage.getChildByName("cam_downBTN").addEventListener(MouseEvent.MOUSE_UP, onCam_downKeyUp);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, myKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, myKeyUp);
			
			
			
		}
		
		private function onCam_upKeyDown(e:MouseEvent = null):void
		{
			Model.turnsObj.camera_up = true;
			Model.turnsObj.camera_down = false;
		}
		
		private function onCam_downKeyDown(e:MouseEvent = null):void
		{
			Model.turnsObj.camera_up = false;
			Model.turnsObj.camera_down = true;
		}
		
		private function onCam_upKeyUp(e:MouseEvent = null):void
		{
			Model.turnsObj.camera_up = false;
			Model.turnsObj.camera_down = false;
		}
		
		private function onCam_downKeyUp(e:MouseEvent = null):void
		{
			Model.turnsObj.camera_up = false;
			Model.turnsObj.camera_down = false;
		}
		
		
		
		private function onLeftKeyDown(e:MouseEvent = null):void
		{
			Model.turnsObj.left = true;
			Model.turnsObj.right = false;
		}
		
		private function onRightKeyDown(e:MouseEvent = null):void
		{
			Model.turnsObj.right = true;
			Model.turnsObj.left = false;
		}
		
		private function onUpKeyDown(e:MouseEvent = null):void
		{
			Model.turnsObj.up = true;
			Model.turnsObj.down = false;
		}
		
		private function onDownKeyDown(e:MouseEvent = null):void
		{
			Model.turnsObj.down = true;
			Model.turnsObj.up = false;
		}
		
		
		
		
		
		
		
		function myKeyDown(e: KeyboardEvent): void {

			if (e.keyCode == Keyboard.W) {
				onUpKeyDown();
			}
			if (e.keyCode == Keyboard.S) {

				onDownKeyDown();
			}
			if (e.keyCode == Keyboard.A) {

				onLeftKeyDown();
			}
			if (e.keyCode == Keyboard.D) {

				onRightKeyDown();
			}
			if (e.keyCode == Keyboard.UP) {
				onCam_upKeyDown();
				
			}
			if (e.keyCode == Keyboard.DOWN) {
				onCam_downKeyDown();
				
			}
		}
		
		
		///////mouse up////
		private function onUpKeyUp(e:MouseEvent = null):void
		{
			Model.turnsObj.up = false;
		}
		
		private function onDownKeyUp(e:MouseEvent = null):void
		{
			Model.turnsObj.down = false;
		}
		
		private function onLeftKeyUp(e:MouseEvent = null):void
		{
			Model.turnsObj.left = false;
		}
		
		private function onRightKeyUp(e:MouseEvent = null):void
		{
			Model.turnsObj.right = false;
		}
		

		function myKeyUp(e: KeyboardEvent): void {

			if (e.keyCode == Keyboard.W) {
				onUpKeyUp();
			}
			if (e.keyCode == Keyboard.S) {

				onDownKeyUp();
			}
			if (e.keyCode == Keyboard.A) {

				onLeftKeyUp();
			}
			if (e.keyCode == Keyboard.D) {

				onRightKeyUp();
			}
			if (e.keyCode == Keyboard.UP) {
				onCam_upKeyUp();
				
			}
			if (e.keyCode == Keyboard.DOWN) {
				onCam_downKeyUp();
				
			}
		}

	}

}