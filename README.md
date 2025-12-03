## What

This is a project to implement AI to guess from a bugzilla description
which package will need a fix.

For training we can rely on training data since 2013 from mails
that were sent to bugs ML and got updates from Bernhard's [obsbugzilla](https://github.com/bmwiedemann/obsbugzilla/) bot.

## How

With LoRA training - see
https://hackweek.opensuse.org/25/projects/try-ai-training-with-rocm-and-lora

## Why

Manually looking at all incoming bugs is some effort and adds delays.
If we can automate some of the work, that leaves more time to humans for other work.
