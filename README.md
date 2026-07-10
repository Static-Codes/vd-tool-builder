# VD Tool Builder (VDTB)

## What is the VD Tool?

The VD Tool is the Vector Drawable Conversion Tool used in Android Studio.

## What is VD Tool Builder?

VDTB is a portability-first utility to compile the VD Tool as either a JAR or Native Image for `linux-x64` without requiring the entire AOSP source.

VDTB was forked from Ryan Harter's [VD Tool build process](https://github.com/rharter/vd-tool) which targeted `Java 8+`. The project has since been updated to target `Java 21.X`, which is the latest LTS version offered by Oracle.

## Why should I use VD Tool Builder?

VDTB allows for portable execution of the battle-tested VD Tool, while maintaining a telemetry-free experience from Google.

VDTB supports two build options.

### Option 1: JAR Only

* **Pros:**
  * Compiles a Java Runtime Executable that can be executed on any system with Java 21.X installed.
  * Outputs only one file.


* **Cons:**
  * Uses more RAM compared to Option 2.



### Option 2: Native Image (uses GraalVM)

* **Pros:**
  * Doesn't require Java 21.X to be installed (after compilation is complete).
  * Uses less RAM compared to Option 1.


* **Cons:**
  * Uses around 60% more disk space for the compiled binary compared to Option 1.

---

## Credits

* `vd-tool` | *Copyright (c) 2022 Ryan Harter*
* `Android Studio/AOSP code` | *Copyright (C) 2015 The Android Open Source Project*
