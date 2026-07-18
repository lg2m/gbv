# Keep the Machine headless and deterministic

`gbv`'s Machine receives every external stimulus explicitly and returns observable output without opening files, querying wall time, creating windows, polling host input, or sending audio to a device. Host Frontends own presentation, persistence, pacing, and platform integration so conformance tests, replay, debugging, and alternate Frontends all exercise the same deterministic hardware core.
