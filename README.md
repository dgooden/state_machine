# Simple GML State Machine
Simple GML state machine for GameMaker 2.3+

## Usage:

#### Initialize state machine:
```gml
stateMachine = new DTGSM_StateMachine();
```
#### Create states:
```gml
state = new DTGSM_State();
// create a state named "start"
stateMachine.add("start",state);
```
### Events:

Code to run when the state machines enters the state:
This is called automatically.
```gml
state.onEnter = function()
{
    // code here
}
```
Code to run when the state machines exits the state:
This is called automatically
```gml
state.onExit = function()
{
    // code here
}
```

This needs to be added to your step event for the onStep events to fire:
```gml
stateMachine.onStep()
```

Code to run each step:
```gml
state.onStep = function()
{
    // code here
}
```

This needs to be added to yuour draw event for the onDraw events to fire:
```gml
stateMachine.onDraw()
```
Code to run each draw event:
```gml
state.onDraw = function()
{
    // code here
}
```

Note: onStep and onDraw are not actually tied to the Gamemaker step or draw events. You can run them in the begin/end events, or anywhere else for that matter.

### Custom events
You can also make custom events
```gml
state.addCustom("my_custom_eventname", function() {
    // code here
});
```

Execute that code later:
```gml
stateMachine.onCustom("my_custom_eventname");
```
The state machine needs to be in that state in order for this to work.

### User data

Each state can save a simple struct (just key/value pairs, no functions, etc)

Adding user data to the current state:
```gml

foo = {
    bar: "spam"
};

stateMachine.addUserData(foo);
```

Retrieving user data from the current state:
```gml

userData = stateMachine.getUserData();
```

userData would then contain the data from the foo struct.

### Time/Frames since enter state

You can get the amount of time that has passed since the current state has been running.
```gml
timeInMicroseconds = stateMachine.getTime(false);

timeInSeconds = stateMachine.getTime(true);
```

Also the number of frames since the state started.
```gml
frames = stateMachine.getFrames()
```
