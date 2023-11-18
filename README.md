# BrekiTrekker
k
A no-nonsense hiking & walking app for Garmin watches that tries to be as
user-friendly as possible and keep all the relevant information on a single
screen.

## How to run in a ConnectIQ simulator

1. In VS Code, open one of the source files (`.mc` extension).
2. Press `Ctrl+F5` to run the app without the debugger.

In the simulator, you can then use `Ctrl+A` to kill the application.

### Loading activity data

1. When the application is not being run, you can use `Simulation/Activity Data`
   menu item to load the activity data from a FIT file.
2. Choose `FIT/GPX Playable File` as the data source. And then click on the
   `Load File` button. There is a sample FIT file in the `samples` directory.
3. Then press on the `Play` button to start the data simulation.

You do not need to close the dialog, you can use it for starting and stopping
the data simulation.

## Changelog

### 2023-11-18

- ETA should take elevation difference into account.


### 2023-11-05

- Add ETA display.

### 2023-11-01

- Use a more prominent color for temperature.
- Activity saved sound and vibration reminder.

### 2023-10-31

- Use a more prominent font for the time display.
- Add some instructions on how to run the app in the simulator.

### 2023-05-20

- Elapsed distance indicator
- Ascent is no longer calculated, but instead taken from the watch itself
