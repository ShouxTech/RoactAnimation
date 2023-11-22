local RunService = game:GetService('RunService');
local TweenService = game:GetService('TweenService');

local React = require(script.Parent.Parent.React);
local Signal = require(script.Parent.Parent.Signal);

local function lerp(start, goal, alpha)
    if typeof(start) ~= typeof(goal) then
        error('start type and goal type mismatch');
    end;

    if typeof(start) == 'number' then
        return start + (goal - start) * alpha;
    else
        return start:Lerp(goal, alpha);
    end;
end;

local function constructAnimationInterface(play, stop, onComplete: Signal.Signal, onCancel: Signal.Signal)
    local Animation = {};

    Animation.play = play;
    Animation.stop = stop;

    Animation.onComplete = onComplete;
    Animation.onCancel = onCancel;

    return Animation;
end;

local function useTween(initialValue: any, tweenInfo: TweenInfo)
    local binding, setBinding = React.useBinding(initialValue);

    local playStartValue = React.useRef();
    local playStartTime = React.useRef();
    local updateThread = React.useRef();

    local onComplete: Signal.Signal = React.useRef(Signal.new()).current;
    local onCancel: Signal.Signal = React.useRef(Signal.new()).current;

    React.useEffect(function()
        return function()
            if updateThread.current then
                updateThread.current:Disconnect();
                updateThread.current = nil;
            end;
        end;
    end, {});

    local function stop(didFullyComplete: boolean)
        if not updateThread.current then return; end;

        updateThread.current:Disconnect();
        updateThread.current = nil;

        (didFullyComplete and onComplete or onCancel):Fire();
    end;

    local function play(goal)
        if updateThread.current then -- Cancel existing tween.
            stop();
        end;

        playStartValue.current = binding:getValue();
        playStartTime.current = tick();

        updateThread.current = RunService.Heartbeat:Connect(function()
            local timeProgress = (tick() - playStartTime.current) / tweenInfo.Time;
            local lerpProgress = math.min(1, TweenService:GetValue(timeProgress, tweenInfo.EasingStyle, tweenInfo.EasingDirection));

            setBinding(lerp(playStartValue.current, goal, lerpProgress));

            if lerpProgress == 1 then
                stop(true);
            end;
        end);
    end;

    local Animation = constructAnimationInterface(play, stop, onComplete, onCancel);

    return binding, Animation;
end;

return useTween;