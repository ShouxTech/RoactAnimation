# RoactAnimation
A simple animation interface for Roact

## Install
Install with [wally](https://wally.run/):\
`RoactAnimation = "shouxtech/roactanimation@0.1.9"`

## Usage
```lua
local ReplicatedStorage = game:GetService('ReplicatedStorage');

local React = require(ReplicatedStorage.Src.Packages.React);
local RoactAnimation = require(ReplicatedStorage.Src.Packages.RoactAnimation);

local function Button(props)
    local backgroundColor, animateBgColor = RoactAnimation.useTween(Color3.fromRGB(255, 255, 255), TweenInfo.new(0.25));

    return React.createElement('TextButton', {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 200, 0, 200),
        Position = UDim2.fromScale(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundColor3 = backgroundColor,
        AutoButtonColor = false,
        TextSize = 16,
        Text = 'Click me!',

        [React.Event.MouseEnter] = function()
            animateBgColor.play(Color3.fromRGB(230, 230, 230));
        end,
        [React.Event.MouseLeave] = function()
            animateBgColor.play(Color3.fromRGB(255, 255, 255));
        end,
        [React.Event.MouseButton1Down] = function()
            animateBgColor.play(Color3.fromRGB(210, 210, 210));
        end,
        [React.Event.MouseButton1Up] = function()
            animateBgColor.play(Color3.fromRGB(230, 230, 230));
        end,
    });
end;

return Button;
```
