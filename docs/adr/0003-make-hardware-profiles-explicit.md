# Make Hardware Profiles explicit

Every `gbv` Machine is configured with an explicit Hardware Profile covering physical model, revision, and execution mode rather than an `is_color` flag or an unspecified generic console. Boot Policy remains independent run configuration. Cartridge metadata constrains valid modes but does not silently select the emulated hardware; tests and Compatibility Reports record the complete profile so revision-dependent behavior remains visible and reproducible.
