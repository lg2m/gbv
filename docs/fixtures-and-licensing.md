# Fixtures and licensing

The repository is MIT-licensed. Every third-party source, binary, reference image, and tool retains its own license and provenance.

## Prohibited repository content

Do not commit or upload:

- commercial ROM Images;
- Nintendo Boot ROMs or firmware;
- extracted sprites, maps, audio, fonts, screenshots, or other commercial assets;
- commercial Save Data or Snapshots;
- frame, audio, trace, or memory artifacts derived from private commercial tests;
- links or automation intended to obtain unauthorized copies.

## Fixture classes

**Project-owned** fixtures include source and a reproducible binary build. They are preferred for narrow tracer tests.

**Vendored third-party** fixtures require an explicit redistribution license, retained attribution, an immutable upstream identity, and a recorded SHA-256.

**Fetch-only** fixtures are downloaded by an explicit script after verifying provenance, license policy, and digest. Ambiguous redistribution terms default to fetch-only or local-only; the repository does not assume that a mirror relicenses its contents.

**Local commercial** fixtures are supplied by the user through an ignored manifest and never become CI dependencies or uploaded artifacts.

## Manifest contract

Every external fixture records:

- suite and test identifier;
- canonical upstream URL and immutable revision;
- SHA-256 and byte size;
- license and redistribution status;
- supported Hardware Profiles;
- Boot ROM or Post-boot Start policy;
- completion protocol and Sub-tick budget;
- expected serial, register, Frame, audio, or state result;
- `required`, `known-fail` with issue, or `not-applicable` with reason.

Mooneye, Acid2, Mealybug, and SameSuite have explicit upstream licensing suitable for evaluation, subject to retaining their notices. The exact Blargg source or mirror must have its redistribution terms verified before any binary is vendored.

## Commercial compatibility reports

The local compatibility harness records only metadata safe to publish: title and revision supplied by the user, ROM digest, Hardware Profile, `gbv` version, configuration, checkpoints attempted, and pass/fail notes. The digest identifies the tested revision without distributing its content.

Public reports never include private filesystem paths, ROM bytes, screenshots, Save Data, or Snapshot contents.
