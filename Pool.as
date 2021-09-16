package  {
	import flash.geom.Point;
	
	//O(1) access pool - Yonny Zohar
	
	public class Pool {
		
		private static const ELEMENT_INVALID:int = -1;
		private static const ELEMENT_FREE:int = 0;
		private static const ELEMENT_OCCUPIED:int = 1;
		
		private var pool:Array;//the actual pool storing the elements
		private var curIndex:int;//the current index of the pool
		private var poolSize:int;// store pool sizd as int
		
		private var elementsStatus:Array;//the status of each element in the pool. 0 is avalibale, 1 is used
		private var recentlyDiscarded:Array;//recently discareded handles stored here for quick access
		private var totalUsageCount:Array;//stores the num of times each element in the pool was alloced as a new instance. enables tracking invalid elements
		private CLS:Class;//the class to be created in the pool
		
		public function Pool() {
			curIndex = 0;
			pool = [];
			elementsStatus = [];
			recentlyDiscarded = [];
			totalUsageCount = [];
		}
		
		//create a pool with _numElements and an elementsStatus array of the same size. current total usage count of all elements is 0
		public function init(_numElements:int, _CLS:Class):void
		{
			CLS = _CLS;
			poolSize = _numElements;
			for(var i:int = 0; i < _numElements; i++)
			{
				pool[i] = new CLS();
				elementsStatus[i] = ELEMENT_FREE;
				totalUsageCount[i] = 0;
			}
		}
		
		
		//returns an avaliable handle and num allocations
		public function getAvaliable():Point
		{
			var index:int;
			//if the recently discarded array is not empty, return the most recent
			//increment the number of times this handle was accloted as a new instance
			//mark the current element status as used
			//return the handle and the current usage count. the user needs to hold on to these two values for validation
			if(recentlyDiscarded.length)
			{
				index = recentlyDiscarded.pop();
				elementsStatus[index] = ELEMENT_OCCUPIED;
				totalUsageCount[index]++;
				return new Point(index, totalUsageCount[index]);
			}
			
			index = curIndex;
			
			if (index >= poolSize)
			{
				//pool is full
				return null;
			}
			
			elementsStatus[index] = ELEMENT_OCCUPIED;
			totalUsageCount[index]++;
			curIndex++;
			return new Point(index, totalUsageCount[index]);
		}
		
		//mark the current handle as used
		public function disposeElement(index:int):void
		{
			recentlyDiscarded.push(index);
			elementsStatus[index] = ELEMENT_FREE;
		}
		
		//check if this handle is currently in use
		public function isOccupied(index:int):int
		{
			if(index < 0 || index > poolSize)
			{
				return ELEMENT_INVALID;
			}
			
			return elementsStatus[index]; // 0 is free, 1 is occupied
		}
		
		//check if this handle is valid (might be old handle currently assigned to differnt instance)
		//this will only return true if the element is in use and it is the same instance that the user thinks it is
		public function isValid(index:int, usageCount:int):Boolean
		{
			//if outside the bounds of the pool - invalaid
			if(index < 0 || index > poolSize)
			{
				return false;
			}
			
			var status:int = elementsStatus[index]; // 0 is free, 1 is occupied
			
			if(status == ELEMENT_OCCUPIED)
			{
				//if in use but not the same "version" as the one passed in, it is not valid
				if(totalUsageCount[index] != usageCount)
				{
					return false;
				}
				//it is same version and so is valid
				return true;
			}
			else
			{
				//index is not currently linked to live instance so it is invalid
				return false;
			}
		}
	}
}
