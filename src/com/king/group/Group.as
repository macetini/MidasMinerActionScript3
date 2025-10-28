package com.king.group
{
	import com.king.framework.TweenMonitor;
	import com.king.framework.events.TweenMonitorEvent;
	import com.king.group.elements.GroupElement;
	import com.king.group.elements.event.GroupElementEvent;
	import com.king.group.events.GroupEvent;
	import com.king.hud.events.ScorePanelEvent;
	import com.king.meta.variables.GameVariables;
	import com.king.utils.SoundUtil;

	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Marko Cetinic
	 */
	public class Group extends Sprite
	{
		public static const COL_COUNT:int = 8;
		public static const ROW_COUNT:int = 8;
		
		public static const FIRST_ELEM_POS:int = COL_COUNT * ROW_COUNT;
		
		public static const ELEM_GAP:int = 5;
		
		public static const INTRO_TWEEN_ANIMATION_DURRATION:Number = 1.96;
		public static const RESET_TWEEN_ANIMATION_DURRATION:Number = 1.0;
		
		public static const INTERVAL:uint = 4500;
		
		public static var GroupElemsVec:Vector.<GroupElement>;
		
		private var _groupElemsSprite:Sprite;
		
		private var _selectedElem:GroupElement = null;
		
		private var _groupElementsLocked:Boolean = true;
		
		private var _tweenMonitor:TweenMonitor;
		
		private var _inactivityTimer:Timer;
		
		public function Group()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			var clipRectY:int = ROW_COUNT * (GroupElement.ELEM_H_V_DIMENSIONS + Group.ELEM_GAP);
			var clipRectHeight:int = clipRectY + GroupElement.ELEM_H_V_DIMENSIONS;
			var clipRectWidth:int = COL_COUNT * (GroupElement.ELEM_H_V_DIMENSIONS + Group.ELEM_GAP) + GroupElement.ELEM_H_V_DIMENSIONS * 2;
			
			this.clipRect = new Rectangle(-GroupElement.ELEM_H_V_DIMENSIONS, clipRectY, clipRectWidth, clipRectHeight);
			
			GroupElemsVec = new Vector.<GroupElement>(ROW_COUNT * 2 * COL_COUNT, true);
			
			_groupElemsSprite = new Sprite;
			_groupElemsSprite.x = 0;
			_groupElemsSprite.y = -ROW_COUNT * (GroupElement.ELEM_H_V_DIMENSIONS + Group.ELEM_GAP);
			_groupElemsSprite.addEventListener(TouchEvent.TOUCH, touchEventHandler);
			_groupElemsSprite.addEventListener(Event.ADDED_TO_STAGE, groupElemsSpriteOnAdded);
			
			_tweenMonitor = new TweenMonitor();
			
			_inactivityTimer = new Timer(INTERVAL, 1);
			_inactivityTimer.addEventListener(TimerEvent.TIMER, inactivityTimerComplete);
		}
		
		public function get groupElementsLocked():Boolean
		{
			return _groupElementsLocked;
		}
		
		public function set groupElementsLocked(value:Boolean):void
		{
			_groupElementsLocked = value;
		}
		
		public function timeOverEventHandler(e:ScorePanelEvent):void
		{
			SoundUtil.playEndGame();
			
			removeInactivityMarker();
			
			groupElementsLocked = true;
			_tweenMonitor.purge();
			
			if (_selectedElem != null)
				_selectedElem.setElemUnSelected();
		}
		
		protected function onAdded():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			buildGrid();
		}
		
		protected function buildGrid():void
		{
			var groupElem:GroupElement;
			
			var imageX:int = 0;
			var imageY:int = 0;
			
			var randColor:int;
			
			var pos:int;
			var overPos:int;
			
			var i:int, j:int;
			
			for (i = 0; i < ROW_COUNT * 2; i++)
			{
				groupElem = null;
				
				for (j = 0; j < COL_COUNT; j++)
				{
					pos = i * COL_COUNT + j;
					
					randColor = Math.random() * GroupElement.NUMBER_OF_COLORS;
					
					while (containesThreeInARow(randColor, pos))
						randColor = Math.random() * GroupElement.NUMBER_OF_COLORS;
					
					groupElem = new GroupElement(randColor, pos);
					
					groupElem.x = imageX;
					groupElem.y = imageY;
					
					if ((pos + 1) % COL_COUNT == 0)
					{
						imageX = 0;
						imageY += GroupElement.ELEM_H_V_DIMENSIONS + Group.ELEM_GAP;
					}
					else
						imageX += GroupElement.ELEM_H_V_DIMENSIONS + Group.ELEM_GAP;
					
					GroupElemsVec[pos] = groupElem;
				}
			}
			
			var length:int = GroupElemsVec.length;
			for (i = 0; i < GroupElement.NUMBER_OF_COLORS; i++)
				for (j = 0; j < length; j++)
					if ((GroupElemsVec[j] as GroupElement).graphicColor == i)
						_groupElemsSprite.addChild(GroupElemsVec[j]);
			
			this.addChild(_groupElemsSprite);
		}
		
		protected function playIntroAnimation():void
		{
			GroupElemsVec = new Vector.<GroupElement>(ROW_COUNT * 2 * COL_COUNT, true);
			_groupElemsSprite.removeChildren(0, -1, true);
			
			buildGrid();
			
			SoundUtil.playMetalClick();
			
			var tween:Tween = new Tween(_groupElemsSprite, INTRO_TWEEN_ANIMATION_DURRATION, Transitions.EASE_OUT_BOUNCE);
			
			tween.animate("y", _groupElemsSprite.y + Group.ROW_COUNT * (GroupElement.ELEM_H_V_DIMENSIONS + ELEM_GAP) + ELEM_GAP);
			tween.onComplete = introTweenAnimationComplete;
			
			Starling.juggler.add(tween);
		}
		
		protected function groupElemsSpriteOnAdded(e:Event):void
		{
			e.target.removeEventListener(Event.ADDED_TO_STAGE, groupElemsSpriteOnAdded);
			
			playIntroAnimation();
		}
		
		public function resetGridForRetry():void
		{
			playResetAnimation();
		}
		
		protected function playResetAnimation():void
		{
			SoundUtil.playReTry();
			
			var tween:Tween = new Tween(_groupElemsSprite, RESET_TWEEN_ANIMATION_DURRATION);
			
			tween.animate("y", _groupElemsSprite.y - Group.ROW_COUNT * (GroupElement.ELEM_H_V_DIMENSIONS + ELEM_GAP) - ELEM_GAP);
			tween.onComplete = playIntroAnimation;
			
			Starling.juggler.add(tween);
		}
		
		protected function introTweenAnimationComplete():void
		{
			this.dispatchEvent(new GroupEvent(GroupEvent.INTRO_ANIM_COMPLETE));
			
			if (!checkGridForNoPoints())
			{
				groupElementsLocked = false;
				_inactivityTimer.start();
			}
		}
		
		protected function particleCircleStoped(e:GroupElementEvent):void
		{
			e.target.removeEventListener(GroupElementEvent.PARTICLE_CIRCLE_STOPPED, particleCircleStoped);
			
			_inactivityTimer.start();
		}
		
		protected function removeInactivityMarker():void
		{
			this.removeEventListener(GroupElementEvent.PARTICLE_CIRCLE_STOPPED, particleCircleStoped);
			
			_inactivityTimer.reset();
			
			var length:int = GroupElemsVec.length;
			for (var i:int = FIRST_ELEM_POS; i < length; i++)
				GroupElemsVec[i].stopParticleCircle();
		}
		
		protected function inactivityTimerComplete(e:TimerEvent):void
		{
			this.addEventListener(GroupElementEvent.PARTICLE_CIRCLE_STOPPED, particleCircleStoped);
			
			var length:int = GroupElemsVec.length;
			
			var initPosition:int = FIRST_ELEM_POS + Math.random() * (length / 2);
			var index:int = initPosition;
			
			var offset:int;
			
			if (Math.random() * 1 == 0)
				offset = 1;
			else
				offset = -1;
			
			var pointPair:Vector.<GroupElement>;
			
			while (index >= FIRST_ELEM_POS && index < length)
			{
				pointPair = returnGridElemPointPair(GroupElemsVec[index]);
				
				if (pointPair.length > 0)
				{
					pointPair[0].startParticleCircle();
					pointPair[1].startParticleCircle();
					
					break;
				}
				
				index += offset;
			}
			
			index = initPosition;
			
			if (pointPair.length == 0)
				while (index >= FIRST_ELEM_POS && index < length)
				{
					pointPair = returnGridElemPointPair(GroupElemsVec[index]);
					
					if (pointPair.length > 0)
					{
						pointPair[0].startParticleCircle();
						pointPair[1].startParticleCircle();
						
						break;
					}
					
					index -= offset;
				}
			
			for (var i:int = FIRST_ELEM_POS; i < length; i++)
				GroupElemsVec[i].markedForRemoval = false;
		}
		
		protected function swapElemProperties(elem1:GroupElement, elem2:GroupElement):void
		{
			var tempElem1Pos:int = elem1.position;
			
			elem1.position = elem2.position;
			elem2.position = tempElem1Pos;
			
			var item1pos:int = GroupElemsVec.indexOf(elem1);
			var item2pos:int = GroupElemsVec.indexOf(elem2);
			
			if ((item1pos != -1) && (item2pos != -1))
			{
				var tempItem:GroupElement = GroupElemsVec[item2pos];
				GroupElemsVec[item2pos] = GroupElemsVec[item1pos];
				GroupElemsVec[item1pos] = tempItem;
			}
		}
		
		protected function noPointsInGridAnimCompleate(e:TweenMonitorEvent):void
		{
			e.target.removeEventListener(TweenMonitorEvent.TWEEN_ANIMATIONS_COMPLETE, noPointsInGridAnimCompleate);
			
			if (checkForAdditionalPoints())
				if (checkGridForNoPoints())
					groupElementsLocked = false;
		}
		
		protected function returnGridElemPointPair(elem:GroupElement):Vector.<GroupElement>
		{
			var retVec:Vector.<GroupElement> = new Vector.<GroupElement>;
			
			if (elem.overElem != null && elem.overElem.overElem != null)
			{
				var overElem:GroupElement = elem.overElem;
				
				swapElemProperties(elem, overElem);
				
				if (elem.checkAndMarkElemForPoints() || overElem.checkAndMarkElemForPoints())
				{
					swapElemProperties(elem, overElem);
					
					retVec.push(elem, overElem);
					return retVec;
				}
				
				swapElemProperties(elem, overElem);
			}
			
			if (elem.underElem != null && elem.underElem.underElem != null)
			{
				var underElem:GroupElement = elem.underElem;
				
				swapElemProperties(elem, underElem);
				
				if (elem.checkAndMarkElemForPoints() || underElem.checkAndMarkElemForPoints())
				{
					swapElemProperties(elem, underElem);
					
					retVec.push(elem, underElem);
					return retVec;
				}
				
				swapElemProperties(elem, underElem);
			}
			
			if (elem.leftElem != null && elem.leftElem.leftElem != null)
			{
				var leftElem:GroupElement = elem.leftElem;
				
				swapElemProperties(elem, leftElem);
				
				if (elem.checkAndMarkElemForPoints() || leftElem.checkAndMarkElemForPoints())
				{
					swapElemProperties(elem, leftElem);
					
					retVec.push(elem, leftElem);
					return retVec;
				}
				
				swapElemProperties(elem, leftElem);
			}
			
			if (elem.rightElem != null && elem.rightElem.rightElem != null)
			{
				var rightElem:GroupElement = elem.rightElem;
				
				swapElemProperties(elem, rightElem);
				
				if (rightElem.checkAndMarkElemForPoints() || rightElem.checkAndMarkElemForPoints())
				{
					swapElemProperties(elem, rightElem);
					
					retVec.push(elem, rightElem);
					return retVec;
				}
				
				swapElemProperties(elem, rightElem);
			}
			
			return retVec;
		}
		
		protected function checkGridForNoPoints():Boolean
		{
			var foundPoints:Boolean = false;
			
			var length:int = GroupElemsVec.length;
			for (var i:int = FIRST_ELEM_POS; i < length; i++)
				if (returnGridElemPointPair(GroupElemsVec[i]).length > 0)
				{
					foundPoints = true;
					break;
				}
			
			//reset
			for (i = FIRST_ELEM_POS; i < length; i++)
				GroupElemsVec[i].markedForRemoval = false;
			
			if (!foundPoints)
			{
				var rowToDelete:int = int(Math.random() * ROW_COUNT) * COL_COUNT + FIRST_ELEM_POS;
				
				var rowToDeleteFirstElem:GroupElement = GroupElemsVec[rowToDelete];
				
				while (rowToDeleteFirstElem != null)
				{
					rowToDeleteFirstElem.markedForRemoval = true;
					rowToDeleteFirstElem = rowToDeleteFirstElem.rightElem;
				}
				
				removeMarkedElements(noPointsInGridAnimCompleate);
			}
			
			return !foundPoints;
		}
		
		protected function containesThreeInARow(randColor:int, pos:int):Boolean
		{
			if (pos - ROW_COUNT * 2 >= 0)
			{
				var oneStepOverElemGraphicColor:int = GroupElemsVec[pos - ROW_COUNT].graphicColor;
				var twoStepOverElemGraphicColor:int = GroupElemsVec[pos - ROW_COUNT * 2].graphicColor;
				
				if (oneStepOverElemGraphicColor == randColor && twoStepOverElemGraphicColor == randColor)
					return true;
			}
			
			if ((pos - 2) % 8 >= 0)
			{
				var oneStepLeftElemGraphicColor:int = GroupElemsVec[pos - 1].graphicColor;
				var twoStepLeftElemGraphicColor:int = GroupElemsVec[pos - 2].graphicColor;
				
				if (oneStepLeftElemGraphicColor == randColor && twoStepLeftElemGraphicColor == randColor)
					return true;
			}
			
			return false;
		}
		
		protected function removeMarkedElements(onAnimComplete:Function = null):void
		{
			SoundUtil.playPoint();
			
			if (onAnimComplete != null)
				_tweenMonitor.addEventListener(TweenMonitorEvent.TWEEN_ANIMATIONS_COMPLETE, onAnimComplete);
			
			for (var i:int = GroupElemsVec.length - 1; i >= FIRST_ELEM_POS; i--)
				if (GroupElemsVec[i].markedForRemoval)
				{
					GameVariables.Score += 1;
					this.dispatchEvent(new GroupEvent(GroupEvent.SCORE_CHANGE));
					
					pullWholeColumnDown(GroupElemsVec[i]);
				}
		}
		
		protected function checkForAdditionalPoints():Boolean
		{
			var foundAdditionalPoints:Boolean = false;
			
			for (var i:int = GroupElemsVec.length - 1; i >= FIRST_ELEM_POS; i--)
				if (GroupElemsVec[i].checkAndMarkElemForPoints())
				{
					foundAdditionalPoints = true;
					break;
				}
			
			if (foundAdditionalPoints)
				removeMarkedElements(pullAnimationsComplete);
			
			return foundAdditionalPoints;
		}
		
		protected function pullAnimationsComplete(e:TweenMonitorEvent):void
		{
			e.target.removeEventListener(TweenMonitorEvent.TWEEN_ANIMATIONS_COMPLETE, pullAnimationsComplete);
			
			if (!checkForAdditionalPoints())
				if (GameVariables.TimerRunning && !checkGridForNoPoints())
				{
					groupElementsLocked = false;
					_inactivityTimer.start();
				}
		}
		
		protected function swapAnimCompleate():void
		{
			removeMarkedElements(pullAnimationsComplete);
		}
		
		/**
		 *
		 * @param	elem1 Selected
		 * @param	elem2 Clicked
		 */
		protected function swapAnimHorizontally(elem1:GroupElement, elem2:GroupElement):void
		{
			groupElementsLocked = true;
			
			if (elem1.position > elem2.position)
			{
				elem1.moveLeftAnim(swapAnimCompleate);
				elem2.moveRightAnim();
			}
			else
			{
				elem1.moveRightAnim(swapAnimCompleate);
				elem2.moveLeftAnim();
			}
		}
		
		/**
		 *
		 * @param	elem1 Selected
		 * @param	elem2 Clicked
		 */
		protected function swapAnimVertically(elem1:GroupElement, elem2:GroupElement):void
		{
			groupElementsLocked = true;
			
			if (elem1.position > elem2.position)
			{
				elem1.moveDownAnim(swapAnimCompleate);
				elem2.moveUpAnim();
			}
			else
			{
				elem1.moveUpAnim(swapAnimCompleate);
				elem2.moveDownAnim();
			}
		}
		
		protected function bounceAnimCompleate():void
		{
			groupElementsLocked = false;
		}
		
		protected function bounceAnimHorizontally(elem1:GroupElement, elem2:GroupElement):void
		{
			groupElementsLocked = true;
			
			if (elem1.position < elem2.position)
			{
				elem1.bounceLeftAnim(bounceAnimCompleate);
				elem2.bounceRightAnim();
			}
			else
			{
				elem1.bounceRightAnim(bounceAnimCompleate);
				elem2.bounceLeftAnim();
			}
		}
		
		protected function bounceAnimVertically(elem1:GroupElement, elem2:GroupElement):void
		{
			groupElementsLocked = true;
			
			if (elem1.position < elem2.position)
			{
				elem1.bounceDownAnim(bounceAnimCompleate);
				elem2.bounceUpAnim();
			}
			else
			{
				elem1.bounceUpAnim(bounceAnimCompleate);
				elem2.bounceDownAnim();
			}
		}
		
		/**
		 *
		 * @param	elem1 Selected
		 * @param	elem2 Clicked
		 */
		protected function elemPairSelected(elem1:GroupElement, elem2:GroupElement):void
		{
			groupElementsLocked = true;
			
			swapElemProperties(elem1, elem2);
			
			if (elem1.checkAndMarkElemForPoints() || elem2.checkAndMarkElemForPoints())
			{
				removeInactivityMarker();
				
				if (Math.abs(elem1.position - elem2.position) == 1)
					swapAnimHorizontally(elem1, elem2);
				else
					swapAnimVertically(elem1, elem2);
			}
			else
			{
				swapElemProperties(elem1, elem2);
				
				SoundUtil.playMove();
				
				if (Math.abs(elem1.position - elem2.position) == 1)
					bounceAnimHorizontally(elem1, elem2);
				else
					bounceAnimVertically(elem1, elem2);
			}
		}
		
		protected function elemSelected(groupElem:GroupElement):void
		{
			if (_selectedElem == null)
			{
				_selectedElem = groupElem;
				_selectedElem.setElemSelected();
				
				return;
			}
			
			_selectedElem.setElemUnSelected();
			
			if (_selectedElem.position != groupElem.position && !_selectedElem.isElemNeighbour(groupElem))
			{
				groupElem.setElemSelected();
				_selectedElem = groupElem;
			}
			else
			{
				if (_selectedElem.position != groupElem.position)
					elemPairSelected(_selectedElem, groupElem);
				
				_selectedElem = null;
			}
		}
		
		protected function touchEventHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if (touch)
			{
				if (_groupElementsLocked)
					return;
				
				var groupElem:GroupElement = e.target as GroupElement;
				elemSelected(groupElem);
			}
		}
		
		protected function returnNewGroupElementsAboveTopElem(topElem:GroupElement, columnOffset:int):Vector.<GroupElement>
		{
			var retVec:Vector.<GroupElement> = new Vector.<GroupElement>;
			
			var randColor:int;
			var newGroupElement:GroupElement;
			
			var elemDimensionsAndGap:int = GroupElement.ELEM_H_V_DIMENSIONS + Group.ELEM_GAP;
			
			var numberOfNewElems:int = columnOffset / Group.COL_COUNT;
			
			for (var i:int = 0; i < numberOfNewElems; i++)
			{
				randColor = Math.random() * GroupElement.NUMBER_OF_COLORS;
				
				newGroupElement = new GroupElement(randColor, topElem.position + i * Group.COL_COUNT);
				newGroupElement.x = topElem.x;
				newGroupElement.y = topElem.y - ((numberOfNewElems - i) * elemDimensionsAndGap);
				
				Group.GroupElemsVec[newGroupElement.position] = newGroupElement;
				
				_groupElemsSprite.addChild(newGroupElement);
				
				retVec.push(newGroupElement);
			}
			
			return retVec;
		}
		
		protected function pullWholeColumnDown(elem:GroupElement, columnOffset:int = 0):int
		{
			if (elem.markedForRemoval)
				columnOffset += Group.COL_COUNT;
			else
				_tweenMonitor.addTween(elem.pullElemDownAnim(columnOffset));
			
			if (elem.overElemAndBeyond != null)
				columnOffset = pullWholeColumnDown(elem.overElemAndBeyond, columnOffset);
			else
			{
				var newGroupElemsVec:Vector.<GroupElement> = returnNewGroupElementsAboveTopElem(elem, columnOffset);
				
				var length:int = newGroupElemsVec.length;
				for (var i:int; i < length; i++)
					_tweenMonitor.addTween(newGroupElemsVec[i].pullElemDownAnim(columnOffset));
			}
			
			if (!elem.markedForRemoval)
			{
				elem.position += columnOffset;
				Group.GroupElemsVec[elem.position] = elem;
			}
			else
				delete _groupElemsSprite.removeChild(elem, true);
			
			return columnOffset;
		}
	}
}