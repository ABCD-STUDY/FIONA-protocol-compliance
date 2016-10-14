# FIONA-protocol-compliance
Matlab script for ABCD study protocol compliance

## Version history

### 0.0.15 (latest stable)

- Fixes issue with null Additional series in json file
- Warns about coil error in series message (for SIEMENS)
- Assign category C to complete phantom QA acquisitions


### 0.0.14

- Fixes bug that prevented phantom pfiles to appear in the web interface

### 0.0.13

- Ignores PMU series to allow compliance of consecutive fMRI runs

### 0.0.12

- Allows Philips scans
- Updated compliance message for clarity

### 0.0.11

- Searches for dicom and k-space files for each of the additional series exams

### 0.0.10

- supports phantom QA acquisitions from GE as long as at least one series presents a valid phantom classify type
- includes expected filename for all series

### 0.0.9

- supports SIEMENS and GE classify tipe compliance checks.
- fix bug that produced an error when tar and tgz files existed for the same series.
- fix minor bugs.
- differentiates between human and phantom scans (in progress).

### 0.0.8

- supports GE classify type study compliance checks
