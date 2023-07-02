local RunService = game:GetService('RunService');
local TweenService = game:GetService('TweenService');

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

local function useTween(hooks, initialValue, tweenInfo: TweenInfo)
    local binding, setBinding = hooks.Roact.createBinding(initialValue);

    local playStartValue = hooks.useValue();
    local playStartTime = hooks.useValue();
    local updateThread = hooks.useValue();

    local onComplete: Signal.Signal = hooks.useValue(Signal.new()).value;
    local onCancel: Signal.Signal = hooks.useValue(Signal.new()).value;

    hooks.useEffect(function()
        return function()
            if updateThread.value then
                updateThread.value:Disconnect();
                updateThread.value = nil;
            end;
        end;
    end, {});

    local function stop(didFullyComplete)
        if not updateThread.value then return; end;

        updateThread.value:Disconnect();
        updateThread.value = nil;

        (didFullyComplete and onComplete or onCancel):Fire();
    end;

    local function play(goal)
        if updateThread.value then -- Cancel existing tween.
            stop();
        end;

        playStartValue.value = binding:getValue();
        playStartTime.value = tick();

        updateThread.value = RunService.Heartbeat:Connect(function()
            local timeProgress = (tick() - playStartTime.value) / tweenInfo.Time;
            local lerpProgress = math.min(1, TweenService:GetValue(timeProgress, tweenInfo.EasingStyle, tweenInfo.EasingDirection));

            if timeProgress >= 1 then
                stop(true);
                return;
            end;

            setBinding(lerp(playStartValue.value, goal, lerpProgress));
        end);
    end;

    local Animation = constructAnimationInterface(play, stop, onComplete, onCancel);

    return binding, Animation;
end;

return useTween;