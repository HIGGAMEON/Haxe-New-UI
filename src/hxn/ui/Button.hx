package hxn.ui;

import hxn.ui.Box.UIStyleData;
import hxn.ui.EventHandler;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Button extends FlxSpriteGroup
{
	public static final CLICK_EVENT = 'button_click';

	public var name:String;
	public var label(default, set):String;
	public var bg:FlxSprite;
	public var text:FlxText;

	public var onChangeState:String->Void;
	public var onClick:Void->Void;

	public var ignore:Bool = false;
	
	public var clickStyle:UIStyleData = {
		bgColor: FlxColor.BLACK,
		textColor: FlxColor.WHITE,
		bgAlpha: 1
	};
	public var hoverStyle:UIStyleData = {
		bgColor: FlxColor.WHITE,
		textColor: FlxColor.BLACK,
		bgAlpha: 1
	};
	public var normalStyle:UIStyleData = {
		bgColor: 0xFFAAAAAA,
		textColor: FlxColor.BLACK,
		bgAlpha: 1
	};

	public function new(x:Float = 0, y:Float = 0, label:String = '', ?onClick:Void->Void = null, ?wid:Int = 80, ?hei:Int = 20)
	{
		super(x, y);
		bg = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
		add(bg);
		bg.color = 0xFFAAAAAA;
		bg.alpha = 0.6;

		text = new FlxText(0, 0, 1, '');
		text.alignment = CENTER;
		add(text);
		resize(wid, hei);
		this.label = label;
		
		this.onClick = onClick;
		forceCheckNext = true;
	}

	public var isClicked:Bool = false;
	public var forceCheckNext:Bool = false;
	public var broadcastButtonEvent:Bool = true;
	var _firstFrame:Bool = true;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if((this.visible && !ignore)) {
			if(_firstFrame)
			{
				bg.color = normalStyle.bgColor;
				bg.alpha = normalStyle.bgAlpha;
				text.color = normalStyle.textColor;
				_firstFrame = false;
			}
			
			if(isClicked && FlxG.mouse.released)
			{
				forceCheckNext = true;
				isClicked = false;
			}

			if(forceCheckNext || FlxG.mouse.justMoved || FlxG.mouse.justPressed || FlxG.mouse.justReleased)
			{
				var overlapped:Bool = (FlxG.mouse.overlaps(bg, camera));

				forceCheckNext = false;

				if(!isClicked)
				{
					var style:UIStyleData = (overlapped) ? hoverStyle : normalStyle;
					bg.color = style.bgColor;
					bg.alpha = style.bgAlpha;
					text.color = style.textColor;
				}

				if(overlapped && (FlxG.mouse.justPressed || FlxG.mouse.justReleased))
				{
					isClicked = true;
					bg.color = clickStyle.bgColor;
					bg.alpha = clickStyle.bgAlpha;
					text.color = clickStyle.textColor;
					if(FlxG.mouse.justReleased) {
						if(onClick != null) onClick();
						if(broadcastButtonEvent) EventHandler.event(CLICK_EVENT, this);
					}
				}
			}
		}
	}

	public function resize(width:Int, height:Int)
	{
		bg.setGraphicSize(width, height);
		bg.updateHitbox();
		text.fieldWidth = width;
		text.x = bg.x;
		text.y = bg.y + height/2 - text.height/2;
	}

	function set_label(v:String)
	{
		if(text != null && text.exists) text.text = v;
		return (label = v);
	}
}