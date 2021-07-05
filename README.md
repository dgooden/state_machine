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
state.onEnter = function(obj)
{
    // code here
    // obj references the State() instance    
}
```
Code to run when the state machines exits the state:
This is called automatically
```gml
state.onExit = function(obj)
{
    // code here
    // obj references the State() instance    
}
```

This needs to be added to your step event for the onStep events to fire:
```gml
stateMachine.step()
```

Code to run each step:
```gml
state.onStep = function(obj)
{
    // code here
    // obj references the State() instance    
}
```

This needs to be added to yuour draw event for the onDraw events to fire:
```gml
stateMachine.draw()
```
Code to run each draw event:
```gml
state.onDraw = function(obj)
{
    // code here
    // obj references the State() instance    
}
```

Note: onStep and onDraw are not actually tied to the Gamemaker step or draw events. You can run them in the begin/end events, or anywhere else for that matter.

If you want to use "getFrames()" call, you must call stateMachine.step() in a step event.

### Custom events
You can also make custom events
```gml
state.addCustom("my_custom_eventname", function(obj) {
    // code here
    // obj references the State() instance    
});
```

Execute that code later:
```gml
stateMachine.custom("my_custom_eventname");
```
The state machine needs to be in that state in order for this to work.

### User data

Each state can save a struct as user data

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

userData would then contain the data from the foo struct. This is a copy, not a reference, so it will be independent of the original struct.

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
