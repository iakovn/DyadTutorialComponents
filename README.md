# DyadTutorialComponents

This repository serves as a playground for the Dyad Tutorial, as described in the [Getting Started guide](https://help.juliahub.com/dyad/dev/tutorials/getting-started.html).

**Notes:**
- Use of Dyad based on this container is covered by https://github.com/DyadLang/dyad-lang/blob/main/LICENSE.md
- Starting the Julia REPL from the terminal does not provide full integration with VS Code. Use the extension command (`Julia: Start REPL`, shortcut: `Alt-j-o`). 
The first launch requires additional package compilation.
- Authorization with JuliaHub need some attention. Click on the JuliaHub extension icon in the left panel and wait for the
extension to load. In some cases clicking on the "Change account" and reloading the window was required. Note that initial loading may takes
some time as packages are compiled. You can monitor progress in the Output pane (View->Output, Ctrl-Shift-U, pick JuliaHub from drop-down).

 
## Getting Started
  
This library was created with the Dyad Studio VS Code extension.  Your Dyad
models should be placed in the `dyad` directory and the files should be
given the `.dyad` extension.  Several such files have already been placed
in there to get you started.  The Dyad compiler will compile the Dyad models
into Julia code and place it in the `generated` folder.  Do not edit the
files in that directory or remove/rename that directory.

A complete tutorial on using Dyad Studio can be found [here](#).  But you
can run the provided example models by doing the following:

1. Run `Julia: Start REPL` from the command palette (Alt-j-o).

2. Type `]`.  This will take you to the package manager prompt.

3. At the `pkg>` prompt, type `instantiate` (this downloads all the Julia libraries
   you will need, and the very first time you do it it might take a while).

4. From the same `pkg>` prompt, type `test`.  This will test to make sure the models
   are working as expected.  It may also take some time but you should eventually
   see a result that indicates 2 of 2 tests passed.

5. Use the `Backspace`/`Delete` key to return to the normal Julia REPL, it should
   look like this: `julia>`.

6. Type `using DyadTutorialComponents`.  This will load your model library.

7. Type `World()` to run a simulation of the `Hello` model.  The first time you run it,
   this might take a few seconds, but each successive time you run it, it should be very fast.

8. To see simulation results type `using Plots` (and answer `y` if asked if you want
   to add it as a dependency).

9. To plot results of the `World` simulation, simply type `plot(World())`.

10. You can plot variations on that simulation using keyword arguments.  For example,
    try `plot(World(stop=20, k=4))`.
