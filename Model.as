package {
	import flash.display.BitmapData;
	public class Model {

		public static var map: Array = [
			[2, 2, 2, 0, 2, 0, 0, 0, 0, 0],
			[2, 0, 1, 0, 0, 0, 0, 2, 0, 0],
			[2, 0, 0, 0, 0, 0, 0, 0, 0, 2],
			[0, 0, 2, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 2, 0, 0],
			[2, 0, 2, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 2, 0],
			[0, 0, 0, 0, 2, 0, 0, 0, 0, 2],
			[0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 2, 0, 0, 0, 0, 0, 1, 0]
		];


		public static var layersMap: Array = [
			[
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null]
			],
			[
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null],
				[null, null, null, null, null, null, null, null, null, null]
			]

		];
		
		public static var origSightRange:int = 30;
		public static var sightRange: int = origSightRange;
		public static var TILE_SIZE: int = 45;
		public static var speed: Number = 4;
		public static var turnAmount: int = 2;

		public static var turnsObj: Object = {
			up: false,
			down: false,
			left: false,
			right: false,
			camera_up:false,
			camera_down:false
		};

		public static var patches: Array = [];
		public static var patch: BitmapData = new Grass50();
		public static var patchLayers: Array = [{
			img: patch,
			partial: false
		}];

		//tree
		public static var trees: Array = [];
		public static var tree_bd1: BitmapData = new Tree1();
		public static var tree_bd2: BitmapData = new Tree2();
		public static var tree_bd3: BitmapData = new Tree3();
		public static var tree_bd4: BitmapData = new Tree4();
		public static var tree_bd5: BitmapData = new Tree5();
		public static var treeLayers: Array = [
			 {
				img: tree_bd1,
				partial: false
			}, {
				img: tree_bd1,
				partial: false
			}, {
				img: tree_bd1,
				partial: false
			}, {
				img: tree_bd1,
				partial: false
			}, {
				img: tree_bd1,
				partial: false
			}, {
				img: tree_bd1,
				partial: false
			}, {
				img: tree_bd1,
				partial: false
			}, {
				img: tree_bd1,
				partial: false
			}, {
				img: tree_bd2,
				partial: false
			}, {
				img: tree_bd3,
				partial: false
			}, {
				img: tree_bd4,
				partial: false
			}, {
				img: tree_bd5,
				partial: false
			}

		];


		//building
		public static var buildings: Array = [];
		public static var bd: BitmapData = new Layer1();
		public static var bd1: BitmapData = new Layer2();
		public static var bd2: BitmapData = new Layer3();
		public static var bd5: BitmapData = new Layer5();
		public static var baseYDiff:Number = 5;
		public static var yDiff: Number = 5;
		public static var buildingLayers: Array = [{
				img: bd,
				partial: false
			}, {
				img: bd,
				partial: true
			}, {
				img: bd,
				partial: true
			}, {
				img: bd,
				partial: true
			}, {
				img: bd1,
				partial: false
			}, {
				img: bd2,
				partial: true
			}, {
				img: bd2,
				partial: true
			}, {
				img: bd2,
				partial: true
			}, {
				img: new Layer6(),
				partial: false
			}, {
				img: bd5,
				partial: true
			}, {
				img: bd5,
				partial: true
			}, {
				img: bd5,
				partial: true
			}, {
				img: new Layer7(),
				partial: false
			}

		];
			
		public static var moveI:int = 0;
		
		public static var soldierIdleFront: BitmapData = new SoldierStand();
		public static var moveArrFront:Array = [new S1(),new S2(),new S3(),new S4(),new S5(),new S6()];
			
		public static var soldierIdleBack: BitmapData = new SoldierStandBack();
		public static var moveArrBack:Array = [new S1Back(),new S2Back(),new S3Back(),new S4Back(),new S5Back(),new S6Back()];
			
		public static var moveArr:Array;
		public static var soldierIdle:BitmapData;
			

	}

}