package {

	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.*;
	import flash.utils.getTimer;



	public class Main extends MovieClip {

		private var bob: Bob = new Bob();
		private var mapHolder: Sprite = new Sprite();

		var cameraW: Number;
		var cameraH: Number;
		var cameraX: Number;
		var cameraY: Number;

		var topRect: Rectangle;
		var bmp: Bitmap;
		var targetBd: BitmapData;
		var playerOrigRot: int = 90;


		var userRow: int;
		var userCol: int;

		private var keyCtrl: KeyboardCtrl;

		var drawLines: Boolean = false;
		var mapRowLen: int;
		var mapColLen: int;


		var playerX: int = 0;
		var playerY: int = 0;
		var offsetX: int = 0;
		var offsetY: int = 0;
		var bmpScale: Number = 1;
		var shrinkAmount: Number = 1;
		var zoom:Number = 2;

		var miniMapTiles: Array;
		var lastDirUp: Boolean = false;


		public function Main() {


			stage.align = "topLeft";
			stage.scaleMode = "noScale";

			cameraW = stage.stageWidth / zoom; //300;
			cameraH = stage.stageHeight / zoom; //400;
			topRect = new Rectangle(0, 0, cameraW, cameraH);
			targetBd = new BitmapData(cameraW, cameraH, false); //0x33ff00

			Model.moveArr = Model.moveArrFront;
			Model.soldierIdle = Model.soldierIdleFront;

			bmp = new Bitmap();
			//bmpScale = stage.stageHeight / cameraH;
			bmp.scaleX = zoom
			bmp.scaleY = zoom;
			stage.addChild(bmp);
			stage.addChild(this);

			createBoard();

			createMap(9, Model.patches, Model.patchLayers, Model.layersMap[0]);
			createMap(1, Model.buildings, Model.buildingLayers, Model.layersMap[1]);
			createMap(2, Model.trees, Model.treeLayers, Model.layersMap[1]);

			mapRowLen = (Model.map.length - 1);
			mapColLen = (Model.map[0].length - 1);


			bmp.bitmapData = targetBd;

			//update();

			stage.addEventListener(Event.ENTER_FRAME, update);


			stage.addChild(upBTN);
			stage.addChild(downBTN);

			stage.addChild(leftBTN);
			stage.addChild(rightBTN);

			stage.addChild(cam_downBTN);
			stage.addChild(cam_upBTN);

			downBTN.x = stage.stageWidth - (upBTN.width / 2);
			downBTN.y = stage.stageHeight - (upBTN.width / 2);

			upBTN.x = downBTN.x;
			upBTN.y = downBTN.y - upBTN.height;

			cam_downBTN.x = downBTN.x - (upBTN.width);
			cam_downBTN.y = downBTN.y;

			cam_upBTN.x = upBTN.x - (upBTN.width);
			cam_upBTN.y = upBTN.y;


			leftBTN.x = upBTN.width / 2;
			leftBTN.y = stage.stageHeight - (upBTN.width / 2);

			rightBTN.x = leftBTN.x + leftBTN.width + 5;
			rightBTN.y = stage.stageHeight - (upBTN.width / 2);


			keyCtrl = new KeyboardCtrl(stage);

		}
		
		private function setZoom():void
		{
			cameraW = stage.stageWidth / zoom; //300;
			cameraH = stage.stageHeight / zoom; //400;
			topRect.width = cameraW;
			topRect.height = cameraH;
			targetBd = new BitmapData(cameraW, cameraH, false);
			bmp.scaleX = zoom
			bmp.scaleY = zoom;
			bmp.bitmapData = targetBd;
		}


		function drawLine(a: Asset, b: Asset): void {
			var offsetY: Number = ((cameraH * (1 - shrinkAmount)) / 2);
			this.graphics.moveTo((a.newX + cameraX) * bmpScale, (((a.newY + cameraY) * bmpScale) * shrinkAmount) + offsetY);
			this.graphics.lineTo((b.newX + cameraX) * bmpScale, (((b.newY + cameraY) * bmpScale) * shrinkAmount) + offsetY);
		}

		function createBoard(): void {

			miniMapTiles = [];
			for (var row: int = 0; row < Model.map.length; row++) {
				miniMapTiles[row] = [];
				for (var col: int = 0; col < Model.map[row].length; col++) {


					var tile: Wall = new Wall();
					mapHolder.addChild(tile);
					tile.alpha = 0.5;
					if (Model.map[row][col] == 0) {
						tile.alpha = 0.1;
					}
					tile.width = Model.TILE_SIZE;
					tile.height = Model.TILE_SIZE;
					tile.x = col * Model.TILE_SIZE;
					tile.y = row * Model.TILE_SIZE;
					miniMapTiles[row][col] = tile;



				}
			}

			mapHolder.addChild(bob);
			bob.x = Model.TILE_SIZE;
			bob.y = Model.TILE_SIZE;
			playerX = bob.x; //Model.TILE_SIZE;
			playerY = bob.y; //Model.TILE_SIZE;
			bob.innerMC.rotation = playerOrigRot; //THIS HAS TO BE 90 BECAUSE PLAYER WALKS DOWN!!!!!!!

			stage.addChild(mapHolder);

			var ratio: Number = mapHolder.width / mapHolder.height;

			mapHolder.width = stage.stageWidth - (cameraW * bmp.scaleX);
			mapHolder.height = mapHolder.width / ratio;
			mapHolder.x = stage.stageWidth - mapHolder.width;
		}

		private function createMap(imgType: int, entites: Array, imgLayers: Array, mapLayer: Array): void {
			var arr: Array;
			var sources: Array;
			var angle: Number;
			var row: int = 0;
			var col: int = 0;
			var count: int = 0;
			var obj: Asset;

			for (row = 0; row < Model.map.length; row++) {
				for (col = 0; col < Model.map[row].length; col++) {
					var proceed: Boolean = false;
					if (Model.map[row][col] == imgType || imgType == 9) {
						arr = entites;
						sources = imgLayers;

						obj = new Asset();
						var dx: Number = (userCol * Model.TILE_SIZE) - (col * Model.TILE_SIZE);
						var dy: Number = (userRow * Model.TILE_SIZE) - (row * Model.TILE_SIZE);
						obj._radious = Math.sqrt((dy * dy) + (dx * dx));
						obj.innerRotation = 0;
						obj.src = sources;

						angle = degreesToRads(obj.outerRot); //this is for inner rotation
						obj.newX = Model.TILE_SIZE * col;
						obj.newY = Model.TILE_SIZE * row;
						obj.origX = obj.newX;
						obj.origY = obj.newY;
						//this is my oiginal angle from the player
						obj.outerRot = radsToDegrees(Math.atan2(obj.newY - playerY, obj.newX - playerX));
						obj.row = row;
						obj.col = col;

						arr.push(obj);
						mapLayer[row][col] = obj;
						count++;
					}
				}
			}
		}

		function drawPlayer(_pX: int, _pY: int, moving: Boolean): void {
			var img: BitmapData = Model.soldierIdle;
			if (moving) {
				img = Model.moveArr[Model.moveI];
				Model.moveI++;
				if (Model.moveI == 6) {
					Model.moveI = 0;
				}
			}
			var w: int = img.width;
			var h: int = img.height;
			var targetX: Number = _pX - (w / 2);
			var targetY: Number = (_pY - h) * shrinkAmount;
			targetY += (cameraH * (1 - shrinkAmount)) / 2;

			targetBd.copyPixels(img, new Rectangle(0, 0, w, h), new Point(targetX, targetY));
		}



		function drawCrossHair(_pX: int, _pY: int, _drawDir: Boolean): void {
			var color: uint = 0xff0000;

			var offsetY: Number = ((cameraH * (1 - shrinkAmount)) / 2);

			targetBd.setPixel(_pX, (_pY - 3) * shrinkAmount + offsetY, color);
			targetBd.setPixel(_pX, (_pY - 2) * shrinkAmount + offsetY, color);
			targetBd.setPixel(_pX, (_pY - 1) * shrinkAmount + offsetY, color);

			targetBd.setPixel(_pX, (_pY) * shrinkAmount + offsetY, color);



			targetBd.setPixel(_pX, (_pY + 1) * shrinkAmount + offsetY, color);
			targetBd.setPixel(_pX, (_pY + 2) * shrinkAmount + offsetY, color);
			targetBd.setPixel(_pX, (_pY + 3) * shrinkAmount + offsetY, color);

			if (_drawDir) {
				targetBd.setPixel(_pX, _pY + 4, color);
				targetBd.setPixel(_pX, _pY + 5, color);
				targetBd.setPixel(_pX, _pY + 6, color);
			}


			targetBd.setPixel(_pX - 1, _pY * shrinkAmount + offsetY, color);
			targetBd.setPixel(_pX - 2, _pY * shrinkAmount + offsetY, color);
			targetBd.setPixel(_pX - 3, _pY * shrinkAmount + offsetY, color);

			targetBd.setPixel(_pX + 1, _pY * shrinkAmount + offsetY, color);
			targetBd.setPixel(_pX + 2, _pY * shrinkAmount + offsetY, color);
			targetBd.setPixel(_pX + 3, _pY * shrinkAmount + offsetY, color);
		}


		function update(e: Event = null): void {

			var i: int = 0;
			if (Model.turnsObj.camera_up) {
				if (shrinkAmount > 0.5) {
					shrinkAmount -= 0.02;
					zoom += 0.1;
					setZoom();
				}

			}

			if (Model.turnsObj.camera_down) {
				
				
				
				if (shrinkAmount < 1) {
					shrinkAmount += 0.02;
					zoom -= 0.1;
					setZoom();
				}


			}
			Model.sightRange = Model.origSightRange / shrinkAmount;
			Model.yDiff = Model.baseYDiff / shrinkAmount;



			//////////////
			var moving: Boolean = false;


			var origX: int = bob.x;
			var origY: int = bob.y;

			var speed: int = Model.speed;


			if (Model.turnsObj.up || Model.turnsObj.down) {
				moving = true;
				var rad: Number = speed;
				var angle: Number = degFromRot(bob.innerMC.rotation) * Math.PI / 180;
				var dirX: Number = rad * Math.cos(angle);
				var dirY: Number = rad * Math.sin(angle);

				var proposedY: int = (bob.y + dirY);
				var proposedX: int = (bob.x + dirX);

				if (proposedY >= mapRowLen * Model.TILE_SIZE || proposedY < 0) {
					if((lastDirUp && Model.turnsObj.up) || (!lastDirUp && !Model.turnsObj.up))
					{
						dirY = 0;
					}
					
				}

				if (proposedX >= mapColLen * Model.TILE_SIZE || proposedX < 0) {
					if((lastDirUp && Model.turnsObj.up) || (!lastDirUp && !Model.turnsObj.up))
					{
						dirY = 0;
					}
				}

				if (Model.turnsObj.up) {

					Model.moveArr = Model.moveArrBack;
					Model.soldierIdle = Model.soldierIdleBack;


					bob.x -= dirX;
					bob.y -= dirY;
					lastDirUp = true;

				}

				if (Model.turnsObj.down) {

					Model.moveArr = Model.moveArrFront;
					Model.soldierIdle = Model.soldierIdleFront;


					bob.x += dirX;
					bob.y += dirY;
					lastDirUp = false;

				}

				playerY = bob.y;
				playerX = bob.x;

			}



			if (Model.turnsObj.left) {
				bob.innerMC.rotation -= speed;


			}
			if (Model.turnsObj.right) {
				bob.innerMC.rotation += speed;

			}



			userRow = bob.y / (Model.TILE_SIZE);
			userCol = bob.x / (Model.TILE_SIZE);


			offsetX = -playerX;
			offsetY = -playerY;
			if (drawLines) {
				this.graphics.clear();
				this.graphics.lineStyle(2, 0x990000, .75);
			}



			cameraX = offsetX + (cameraW / 2);
			cameraY = offsetY + (cameraH / 2);

			targetBd.lock();
			targetBd.fillRect(topRect, 0x000000);
			var currDegree: Number = (degFromRot(bob.innerMC.rotation));


			if (currDegree >= 0 && currDegree <= 180) {

				if (currDegree >= 0 && currDegree <= 90) {

					for (var i: int = 0; i < Model.layersMap.length; i++) {
						var layer: Array = Model.layersMap[i];

						var count: int = 0;
						for (var r: int = -Model.sightRange; r <= Model.sightRange; r++) {
							for (var c: int = -Model.sightRange; c <= Model.sightRange; c++) {
								performFunc(layer, r, c);
							}
						}
						if (i == 0) {
							drawPlayer(playerX + cameraX, playerY + cameraY, moving);
						}
					}

				} else {
					for (var i: int = 0; i < Model.layersMap.length; i++) {
						var layer: Array = Model.layersMap[i];
						var count: int = 0;
						for (var r: int = -Model.sightRange; r <= Model.sightRange; r++) {
							for (var c: int = Model.sightRange; c >= -Model.sightRange; c--) {
								performFunc(layer, r, c);
							}
						}
						if (i == 0) {
							drawPlayer(playerX + cameraX, playerY + cameraY, moving);
							//drawCrossHair(playerX + cameraX, playerY + cameraY, true);
						}
					}
				}


			} else {

				if (currDegree >= 180 && currDegree <= 270) {
					for (var i: int = 0; i < Model.layersMap.length; i++) {
						var layer: Array = Model.layersMap[i];
						var count: int = 0;
						for (var r: int = Model.sightRange; r >= -Model.sightRange; r--) {
							for (var c: int = Model.sightRange; c >= -Model.sightRange; c--) {
								performFunc(layer, r, c);
							}
						}
						if (i == 0) {
							drawPlayer(playerX + cameraX, playerY + cameraY, moving);
						}
					}

				} else {
					for (var i: int = 0; i < Model.layersMap.length; i++) {
						var layer: Array = Model.layersMap[i];
						var count: int = 0;
						for (var r: int = Model.sightRange; r >= -Model.sightRange; r--) {
							for (var c: int = -Model.sightRange; c <= Model.sightRange; c++) {
								performFunc(layer, r, c);
							}
						}
						if (i == 0) {
							drawPlayer(playerX + cameraX, playerY + cameraY, moving);
						}
					}
				}


			}


			targetBd.unlock();

		}

		function performFunc(layer: Array, r: int, c: int): void {
			var currRow: int = userRow + r;
			var currCol: int = userCol + c;
			if (layer[currRow] && layer[currRow][currCol]) {
				var obj: Asset = layer[currRow][currCol];
				if (obj != null) {

					//the rotation of the object is the opposite of the player
					rotateOnce(obj, degFromRot(180 - bob.innerMC.rotation));

					drawImg(obj.newX, obj.newY, degreesToRads(obj.innerRotation), obj.src);

					if (drawLines) {
						if (layer[currRow + 1] && layer[currRow + 1][currCol]) {
							drawLine(obj, layer[currRow + 1][currCol]);
						}

						if (layer[currRow] && layer[currRow][currCol + 1]) {
							drawLine(obj, layer[currRow][currCol + 1]);
						}
					}
				}
			}
		}





		function rotateOnce(obj: Asset, playerAngle: Number): void {
			var angle: Number;
			//set at orig position
			obj.newX = obj.origX;
			obj.newY = obj.origY;


			//add offset from player
			obj.newX -= (playerX);
			obj.newY -= (playerY);

			//get current angle
			obj.outerRot = radsToDegrees(Math.atan2(obj.newY, obj.newX));

			obj.innerRotation = playerAngle - playerOrigRot;

			var dx: Number = (obj.newX);
			var dy: Number = (obj.newY);
			obj._radious = Math.sqrt((dy * dy) + (dx * dx));
			angle = degreesToRads((playerAngle - playerOrigRot + obj.outerRot));

			//trace(obj.row, obj.col, obj.outerRot, playerAngle, obj.outerRot, (playerAngle - playerOrigRot + obj.outerRot));

			obj.newX = obj._radious * Math.cos(angle);
			obj.newY = obj._radious * Math.sin(angle);
			obj.newX += (playerX);
			obj.newY += (playerY);


			//trace(playerAngle, angle,obj.newX,obj.newY);

		}


		//center x / y is the base position of the asset
		//cameraX is center screen absolute
		function drawImg(assetCenterX: Number, assetCenterY: Number, _rot: Number, sources: Array): void {
			if (drawLines) {
				drawCrossHair(assetCenterX + cameraX, assetCenterY + cameraY, false);
				return;
			}
			//
			//
			var l: int = sources.length;
			var halfTileSize: Number = (Model.TILE_SIZE / 1.5);
			var topAssetY: Number = (assetCenterY - (l * Model.yDiff));
			topAssetY *= shrinkAmount;

			if (
				assetCenterX + cameraX - halfTileSize > cameraW ||
				topAssetY + cameraY - halfTileSize > cameraH ||
				assetCenterX + cameraX + halfTileSize < 0 ||
				((assetCenterY + cameraY + halfTileSize) * shrinkAmount + (cameraH * (1 - shrinkAmount)) / 2) < 0) {
				return;
			}



			var absPosX: Number = assetCenterX + cameraX;
			var absPosY: Number = assetCenterY + offsetY;
			var halfBaseHeight: Number = (sources[0].img.height / 2)
			var h: Number = (Model.yDiff * l) + halfBaseHeight;

			var _assetCenterY: Number = assetCenterY;
			var srcBd: BitmapData;
			var w: int;


			var l: int = sources.length;
			var wallDepth: Number = 2;
			var row: int;
			var col: int;
			var centerW: int;
			var centerH: int;

			for (var i: int = 0; i < l; i++) //
			{
				var proceed: Boolean = false;
				srcBd = sources[i].img;
				w = srcBd.width;
				h = srcBd.height;
				centerW = w / 2;
				centerH = h / 2;

				if (sources[i].partial) { //

					for (row = 0; row < wallDepth; row++) {
						for (col = 0; col < w; col++) {
							drawNow(assetCenterX, _assetCenterY, _rot, row, col, srcBd, targetBd, centerW, centerH, assetCenterY);
						}
					}

					for (row = h; row >= h - wallDepth; row--) {
						for (col = 0; col < w; col++) {
							drawNow(assetCenterX, _assetCenterY, _rot, row, col, srcBd, targetBd, centerW, centerH, assetCenterY);
						}
					}

					for (col = 0; col < wallDepth; col++) {
						for (row = 0; row < h; row++) {
							drawNow(assetCenterX, _assetCenterY, _rot, row, col, srcBd, targetBd, centerW, centerH, assetCenterY);
						}
					}

					for (col = w; col >= w - wallDepth; col--) {
						for (row = 0; row < h; row++) {
							drawNow(assetCenterX, _assetCenterY, _rot, row, col, srcBd, targetBd, centerW, centerH, assetCenterY);
						}
					}

				} else {
					for (row = h; row >= 0; row--) {
						for (col = w; col >= 0; col--) {
							drawNow(assetCenterX, _assetCenterY, _rot, row, col, srcBd, targetBd, centerW, centerH, assetCenterY);
						}
					}

				}
				_assetCenterY -= Model.yDiff;
			}

		}

		function drawNow(assetCenterX: Number, _assetCenterY: Number, _rot: Number, row: int, col: int, srcBd: BitmapData, targetBd: BitmapData, centerW: Number, centerH: Number, baseY: Number): void {

			var pixel: uint;
			var dx: Number;
			var dy: Number;
			var distance: Number;
			var currAngle: Number;
			var newX: Number;
			var newY: Number;

			//distance from the top row to the middle row
			dy = Math.abs(row - centerH); //4
			var dySquared: Number = (dy * dy);
			//distance from the top left col to the middle col
			dx = Math.abs(col - centerW); //3

			//distance between the top left cell to the middle cell
			distance = Math.sqrt(dySquared + (dx * dx));


			//angle between the top left cell to the center cell
			currAngle = (Math.atan2(row - centerH, col - centerW)) //radians

			//new col by adding up the angles
			newX = distance * Math.cos(currAngle + _rot);
			newY = distance * Math.sin(currAngle + _rot);

			//&& _assetCenterY + newY + 50 > 0

			var targetX: Number = (assetCenterX + newX + cameraX);
			var targetY: Number = ((_assetCenterY + newY + cameraY) * shrinkAmount);
			targetY += (cameraH * (1 - shrinkAmount)) / 2;

			if (targetX < cameraW && targetX > 0 && targetY < cameraH && targetY > 0) {

				pixel = srcBd.getPixel32(col, row);

				if (pixel != 0) {
					targetBd.setPixel(targetX, targetY, pixel);
				}
			}
		}


		function degreesToRads(degrees: Number): Number {
			return degrees * Math.PI / 180
		}

		function radsToDegrees(radians: Number): Number {
			return radians * 180 / Math.PI;
		}

		function degFromRot(p_rotInput: Number): Number {
			var degOutput: Number = p_rotInput;
			while (degOutput >= 360) {
				degOutput -= 360;
			}
			while (degOutput < 0) {
				degOutput += 360;
			}
			return degOutput;
		}

	}
}