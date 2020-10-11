package com.king.group.elements
{
	import com.king.group.elements.event.GroupElementEvent;
	import com.king.group.Group;
	import com.king.meta.constants.GraphicConstants;
	import com.king.utils.*;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.animation.*;
	import starling.core.*;
	import starling.display.*;
	import starling.extensions.PDParticleSystem;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	
	/**
	 *
	 * Base group elem. Containes references to its neighbours (over, under, left and right elems).
	 *
	 * @author Marko Cetinic
	 */
	
	public class GroupElement extends Image
	{
		/**
		 * Width and height dimension of elems.
		 */
		public static const ELEM_H_V_DIMENSIONS:int = 37;
		
		/**
		 * Number of possible elem colors.
		 */
		public static const NUMBER_OF_COLORS:int = 5;
		
		/**
		 * If player clicks on elem, flag is set to true
		 *
		 * @see setElemSelected()
		 *
		 */
		
		public static const MOVE_ANIM_DURATION:Number = 0.25;
		
		public static const PULL_ANIM_DURATION:Number = 0.25;
		
		public static const TIME_OUT:int = 1;
		public static const INTERVAL:int = 7500;
		
		protected var _selected:Boolean = false;
		
		/**
		 * Graphic color ( Blue, Green, Purple, Red, Yellow ).
		 */
		private var _graphicColor:int;
		
		/**
		 * Elem position in grid. (i * Group.COL_COUNT + j)
		 */
		private var _position:int;
		
		public var markedForRemoval:Boolean = false;
		
		private var _glow:BlurFilter;
		
		private var _particleCircle:PDParticleSystem = null;
		
		private var _particleCircleTimer:Timer;
		
		/**
		 * Group elem constructor. Demands color and position argument
		 *
		 * @param	randColor	Random color passed by parent.
		 * @param	position	Elem position in parent container.
		 */
		public function GroupElement(randColor:int, position:int)
		{
			super(TextureUtil.elemUnselectedTexture(randColor));
			
			_position = position;
			_graphicColor = randColor;
			
			_particleCircleTimer = new Timer(INTERVAL, TIME_OUT);
			_particleCircleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, particleCircleTimerComplete);
		}
		
		override public function dispose():void
		{
			_particleCircleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, particleCircleTimerComplete);
			
			super.dispose();
		}
		
		/**
		 * Over elem reference getter. This getter will fetch all elements includeing the once with position value less than 64.
		 * Null if not existant.
		 */
		public function get overElemAndBeyond():GroupElement
		{
			var pos:int = this.position - Group.COL_COUNT;
			
			if (pos >= 0)
				return Group.GroupElemsVec[pos];
			else
				return null;
		}
		
		/**
		 * Over elem reference getter. This getter will not fetch elemts that are not visible.
		 * I.E. all elements with position less than 64 (ROW_COUNT * COL_COUNT), instead it will return NULL.
		 */
		public function get overElem():GroupElement
		{
			var pos:int = this.position - Group.COL_COUNT;
			
			if (pos >= Group.ROW_COUNT * Group.COL_COUNT)
				return Group.GroupElemsVec[pos];
			else
				return null;
		}
		
		/**
		 * Under elem reference getter, null if non existenet.
		 */
		public function get underElem():GroupElement
		{
			var pos:int = this.position + Group.COL_COUNT;
			
			if (pos < Group.GroupElemsVec.length)
				return Group.GroupElemsVec[pos];
			else
				return null;
		}
		
		/**
		 * Left elem getter. Null in not existant.
		 */
		public function get leftElem():GroupElement
		{
			if (this.position % Group.COL_COUNT > 0)
				return Group.GroupElemsVec[this.position - 1];
			else
				return null;
		}
		
		/**
		 * Right elem getter. Null if not existant.
		 */
		public function get rightElem():GroupElement
		{
			if (this.position % Group.COL_COUNT < Group.COL_COUNT - 1)
				return Group.GroupElemsVec[this.position + 1];
			else
				return null;
		}
		
		/**
		 * Elem color getter. Read only.
		 */
		public function get graphicColor():int
		{
			return _graphicColor;
		}
		
		/**
		 * Selcted flag getter. Read only.
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		
		/**
		 * Position getter.
		 */
		public function get position():int
		{
			return _position;
		}
		
		/**
		 * Position settter.
		 */
		public function set position(value:int):void
		{
			_position = value;
		}
		
		public function get neighbourWithPossiblePoint():GroupElement
		{
			if (this.overElem == null || this.overElem.overElem == null)
				return null;
			else if (this.overElem.graphicColor == this.graphicColor && this.overElem.overElem.graphicColor == this.graphicColor)
				return this.overElem;
			else
				return null;
			
			if (this.underElem == null || this.underElem.underElem == null)
				return null;
			else if (this.overElem.graphicColor == this.graphicColor && this.overElem.overElem.graphicColor == this.graphicColor)
				return this.overElem;
			else
				return null;
		}
		
		/**
		 * Elem color in HEX value.
		 *
		 * @return Elem color in Hex value.
		 */
		public function get colorHex():uint
		{
			var retVal:uint;
			
			switch (this._graphicColor)
			{
				case 0: 
					retVal = 0x0000FF;
					break;
				case 1: 
					retVal = 0x00FF00;
					break;
				case 2: 
					retVal = 0xFF00FF;
					break;
				case 3: 
					retVal = 0xFF0000;
					break;
				case 4: 
					retVal = 0xFFFF00;
					break;
			}
			
			return retVal;
		}
		
		public function moveLeftAnim(onCompleate:Function = null):Tween
		{
			var tween:Tween = new Tween(this, MOVE_ANIM_DURATION, Transitions.EASE_OUT);
			tween.animate("x", this.x + GroupElement.ELEM_H_V_DIMENSIONS + Group.ELEM_GAP);
			tween.onComplete = onCompleate;
			
			Starling.juggler.add(tween);
			
			return tween;
		}
		
		public function moveRightAnim(onCompleate:Function = null):Tween
		{
			var tween:Tween = new Tween(this, MOVE_ANIM_DURATION, Transitions.EASE_OUT);
			tween.animate("x", this.x - GroupElement.ELEM_H_V_DIMENSIONS - Group.ELEM_GAP);
			tween.onComplete = onCompleate;
			
			Starling.juggler.add(tween);
			
			return tween;
		}
		
		public function moveDownAnim(onCompleate:Function = null):Tween
		{
			var tween:Tween = new Tween(this, MOVE_ANIM_DURATION, Transitions.EASE_OUT);
			tween.animate("y", this.y + GroupElement.ELEM_H_V_DIMENSIONS + Group.ELEM_GAP);
			tween.onComplete = onCompleate;
			
			Starling.juggler.add(tween);
			
			return tween;
		}
		
		public function moveUpAnim(onCompleate:Function = null):Tween
		{
			var tween:Tween = new Tween(this, MOVE_ANIM_DURATION, Transitions.EASE_OUT);
			tween.animate("y", this.y - GroupElement.ELEM_H_V_DIMENSIONS - Group.ELEM_GAP);
			tween.onComplete = onCompleate;
			
			Starling.juggler.add(tween);
			
			return tween;
		}
		
		public function bounceLeftAnim(onCompleate:Function = null):Tween
		{
			var fun:Function = function():void
			{
				moveRightAnim(onCompleate);
			}
			
			return moveLeftAnim(fun);
		}
		
		public function bounceRightAnim(onCompleate:Function = null):Tween
		{
			var fun:Function = function():void
			{
				moveLeftAnim(onCompleate);
			}
			
			return moveRightAnim(fun);
		}
		
		public function bounceDownAnim(onCompleate:Function = null):Tween
		{
			var fun:Function = function():void
			{
				moveUpAnim(onCompleate);
			}
			
			return moveDownAnim(fun);
		}
		
		public function bounceUpAnim(onCompleate:Function = null):Tween
		{
			var fun:Function = function():void
			{
				moveDownAnim(onCompleate);
			}
			
			return moveUpAnim(fun);
		}
		
		public function pullElemDownAnim(columnOffset:int, onCompleate:Function = null):Tween
		{
			var tweenDuration:Number = PULL_ANIM_DURATION; //columnOffset / Group.COL_COUNT * PULL_ANIM_DURATION;
			var movementValue:int = columnOffset / Group.COL_COUNT * (ELEM_H_V_DIMENSIONS + Group.ELEM_GAP);
			
			var tween:Tween = new Tween(this, tweenDuration, Transitions.EASE_OUT_BACK);
			tween.onComplete = onCompleate;
			
			tween.animate("y", this.y + movementValue);
			
			Starling.juggler.add(tween);
			
			return tween;
		}
		
		public function isElemNeighbour(elem:GroupElement):Boolean
		{
			if (this.overElem != null && this.overElem.position == elem.position)
				return true;
			
			if (this.underElem != null && this.underElem.position == elem.position)
				return true;
			
			if (this.leftElem != null && this.leftElem.position == elem.position)
				return true;
			
			if (this.rightElem != null && this.rightElem.position == elem.position)
				return true;
			
			return false;
		}
		
		/**
		 * Set elem selected method.
		 */
		public function setElemSelected():void
		{			
			_selected = true;
			this.texture = TextureUtil.elemSelectedTexture(_graphicColor);
			
			_glow = BlurFilter.createGlow(colorHex, 2, 2, 0.5);
			this.filter = _glow;
		}
		
		/**
		 * Set elem unselected method.
		 */
		public function setElemUnSelected():void
		{
			_selected = false;
			this.texture = TextureUtil.elemUnselectedTexture(_graphicColor);
			
			_glow.dispose();
			this.filter = null;
		}
		
		public function checkOverElemsForPoints(elem:GroupElement, colorCount:int = 0):Boolean
		{
			var threeInAnRow:Boolean;
			
			if (elem.overElem != null && elem.graphicColor == elem.overElem.graphicColor)
				threeInAnRow = checkOverElemsForPoints(elem.overElem, colorCount + 1);
			else
			{
				if (colorCount >= 2)
				{
					elem.markedForRemoval = true;
					return true;
				}
				else
					return false;
			}
			
			if (threeInAnRow)
				elem.markedForRemoval = true;
			
			return threeInAnRow;
		}
		
		protected function checkUnderElemsForPoints(elem:GroupElement, colorCount:int = 0):Boolean
		{
			var threeInAnRow:Boolean;
			
			if (elem.underElem != null && elem.graphicColor == elem.underElem.graphicColor)
				threeInAnRow = checkUnderElemsForPoints(elem.underElem, colorCount + 1);
			else
			{
				if (colorCount >= 2)
				{
					elem.markedForRemoval = true;
					return true;
				}
				else
					return false;
			}
			
			if (threeInAnRow)
				elem.markedForRemoval = true;
			
			return threeInAnRow;
		}
		
		protected function checkLeftElemsForPoints(elem:GroupElement, colorCount:int = 0):Boolean
		{
			var threeInAnRow:Boolean;
			
			if (elem.leftElem != null && elem.graphicColor == elem.leftElem.graphicColor)
				threeInAnRow = checkLeftElemsForPoints(elem.leftElem, colorCount + 1);
			else
			{
				if (colorCount >= 2)
				{
					elem.markedForRemoval = true;
					return true;
				}
				else
					return false;
			}
			
			if (threeInAnRow)
				elem.markedForRemoval = true;
			
			return threeInAnRow;
		}
		
		protected function checkRightElemsForPoints(elem:GroupElement, colorCount:int = 0):Boolean
		{
			var threeInAnRow:Boolean;
			
			if (elem.rightElem != null && elem.graphicColor == elem.rightElem.graphicColor)
				threeInAnRow = checkRightElemsForPoints(elem.rightElem, colorCount + 1);
			else
			{
				if (colorCount >= 2)
				{
					elem.markedForRemoval = true;
					return true;
				}
				else
					return false;
			}
			
			if (threeInAnRow)
				elem.markedForRemoval = true;
			
			return threeInAnRow;
		}
		
		protected function checkOverAndUnderElem():Boolean
		{
			if (this.overElem == null || this.underElem == null)
				return false;
			
			if (this.graphicColor == this.overElem.graphicColor && this.graphicColor == this.underElem.graphicColor)
			{
				this.markedForRemoval = true;
				this.overElem.markedForRemoval = true;
				this.underElem.markedForRemoval = true;
				
				return true;
			}
			
			return false;
		}
		
		protected function checkLeftAndRightElem():Boolean
		{
			if (this.leftElem == null || this.rightElem == null)
				return false;
			
			if (this.graphicColor == this.leftElem.graphicColor && this.graphicColor == this.rightElem.graphicColor)
			{
				this.markedForRemoval = true;
				this.leftElem.markedForRemoval = true;
				this.rightElem.markedForRemoval = true;
				
				return true;
			}
			
			return false;
		}
		
		public function checkAndMarkElemForPoints():Boolean
		{
			var foundPoint:int = 0;
			
			foundPoint += checkOverElemsForPoints(this);
			foundPoint += checkUnderElemsForPoints(this);
			foundPoint += checkLeftElemsForPoints(this);
			foundPoint += checkRightElemsForPoints(this);
			foundPoint += checkOverAndUnderElem();
			foundPoint += checkLeftAndRightElem();
			
			return foundPoint > 0;
		}
		
		public function startParticleCircle():void
		{
			// instantiate embedded objects
			var psConfig:XML = XML(new GraphicConstants.PARTICLE_CIRCLE_XML());
			var psTexture:Texture = Texture.fromBitmap(new GraphicConstants.PARTICLE_CIRCLE_TEXTURE());
			
			// create particle system
			_particleCircle = new PDParticleSystem(psConfig, psTexture);
			
			var xGlob:Number = this.parent.localToGlobal(new Point(this.x, 0)).x;
			var yGlob:Number = this.parent.localToGlobal(new Point(0, this.y)).y;
			
			_particleCircle.x = xGlob + this.texture.width / 2;
			_particleCircle.y = yGlob + this.texture.height / 2;
			
			stage.addChild(_particleCircle);
			
			Starling.juggler.add(_particleCircle);
			
			_particleCircle.start();
			
			_particleCircleTimer.start();
		}
		
		public function stopParticleCircle():void
		{
			if (_particleCircle != null)
			{
				_particleCircle.stop();
				_particleCircleTimer.reset();
				
				Starling.juggler.remove(_particleCircle);
				
				stage.removeChild(_particleCircle, true);
			
				_particleCircle = null;
				
				if (this.overElem != null)
					this.overElem.stopParticleCircle();
					
				if (this.underElem != null)
					this.underElem.stopParticleCircle();
					
				if (this.leftElem != null)
					this.leftElem.stopParticleCircle();
					
				if (this.underElem != null)
					this.underElem.stopParticleCircle();
					
				this.dispatchEvent(new GroupElementEvent(GroupElementEvent.PARTICLE_CIRCLE_STOPED));
			}
		}
		
		protected function particleCircleTimerComplete(e:TimerEvent):void
		{
			_particleCircleTimer.reset();
			
			stopParticleCircle();
		}
	}
}