# RoactAnimation
A simple animation interface for Roact

## Install
Install with [wally](https://wally.run/):\
`RoactAnimation = "shouxtech/roactanimation@0.1.1"`

## Usage
```lua
local ReplicatedStorage = game:GetService('ReplicatedStorage');

local Roact = require(ReplicatedStorage.Src.Packages.Roact);
local Hooks = require(ReplicatedStorage.Src.Packages.RoactHooks);
local RoactAnimation = require(ReplicatedStorage.Src.Packages.RoactAnimation);

local function Button(props, hooks)
    local backgroundColor, animateBgColor = RoactAnimation.useTween(hooks, Color3.fromRGB(255, 255, 255), TweenInfo.new(0.25));

    return Roact.createElement('TextButton', {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 200, 0, 200),
        Position = UDim2.fromScale(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundColor3 = backgroundColor,
        AutoButtonColor = false,
        TextSize = 16,
        Text = 'Click me!',

        [Roact.Event.MouseEnter] = function()
            animateBgColor.play(Color3.fromRGB(230, 230, 230));
        end,
        [Roact.Event.MouseLeave] = function()
            animateBgColor.play(Color3.fromRGB(255, 255, 255));
        end,
        [Roact.Event.MouseButton1Down] = function()
            animateBgColor.play(Color3.fromRGB(210, 210, 210));
        end,
        [Roact.Event.MouseButton1Up] = function()
            animateBgColor.play(Color3.fromRGB(230, 230, 230));
        end,
    });
end;

return Hooks.new(Roact)(Button);
```
