local RunService = game:GetService('RunService');

local React = require(script.Parent.Parent.React);
local Signal = require(script.Parent.Parent.Signal);
local spr = require(script.Parent.spr);

local function constructAnimationInterface(play, onComplete: Signal.Signal)
    local Animation = {};

    Animation.play = play;

    Animation.onComplete = onComplete;

    return Animation;
end;

local function useTween(dampingRatio: number, frequency: number, initialValue: any)
    local binding, setBinding = React.useBinding(initialValue);

    local spring = React.useRef(spr.new(dampingRatio, frequency, initialValue)).current;

    local updateThread = React.useRef();

    local onComplete: Signal.Signal = React.useRef(Signal.new()).current;

    local function disconnectUpdateThread()
        if updateThread.current then
            updateThread.current:Disconnect();
            updateThread.current = nil;
        end;
    end;

    React.useEffect(function()
        spring:SetOnCompletedCallback(function()
            onComplete:Fire();
            disconnectUpdateThread();
        end);

        return function()
            disconnectUpdateThread();
            spring:Destroy();
        end;
    end, {});

    local function play(goal)
        spring:SetGoal(goal);

        if spring:IsGoalMet() then return; end;

        disconnectUpdateThread();
        updateThread.current = RunService.Heartbeat:Connect(function()
            setBinding(spring.Value);
        end);
    end;

    local Animation = constructAnimationInterface(play, onComplete);

    return binding, Animation;
end;

return useTween;