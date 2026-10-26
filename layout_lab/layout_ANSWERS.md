# Layout Lab: Team Board - Answers

Name: MUHAMMAD ABUBAKAR
Roll no: 04072313027

## Numeric answers

A1: 29
A2: 8
A3: 4
A4: 60

## Written answers

B1: Stateless and Stateful classes

Stateless: LabApp, HomePage, SettingsCard, Probe, Welcome, InfoPanel,
SummaryRow, ShareRow, InfoBox, StampStack. They only show values that are
given to them or fixed values. Nothing inside them changes by itself, so they
don't need a State object. Probe is rebuilt only because its parent (Clock)
passes it a new number.

Stateful: Clock, Tile, SwapBoard. Their data changes while the app runs, so
they need a State object to remember it and setState to redraw. Clock keeps the
seconds, the build counter and the Timer. Tile keeps its own number of taps.
SwapBoard keeps the list of tiles that is reversed when Swap is pressed.

B2: Widget, Element, RenderObject

The Widget is rebuilt (created new) on every setState. It is only a cheap
description, so it is thrown away each time. The Element and the RenderObject
are kept. The Element sits in the element tree and holds the State. The
RenderObject does layout (size and position) and painting.

Probe showed this: every second the Widget number changed (a new Probe object),
but the Element number stayed the same (the same Element was reused). Probe
also showed that its context belongs to Probe and that a Scaffold is above it.

B3: Constraints go down, sizes go up

In Step 7, the Row gives its children unlimited width, so each long Text kept
its one-line width and overflowed (yellow and black stripes). After wrapping
each Text in Expanded, the Row split its width into three equal parts and passed
each part DOWN to its child as a fixed width (the constraint). Each Text had
to fit inside that width, so it wrapped onto more lines. The Text then reported
its size back UP: the same width, but taller. The parent then used these sizes
to position the children.
