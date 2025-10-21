# CSV Export Format Specification

## Overview

This document defines the CSV export format for Custom Lab recording sessions. The format is designed to be:

- **Human-readable**: Easy to open in Excel/Google Sheets
- **Machine-readable**: Simple parsing for Python/R/MATLAB
- **Standards-compliant**: Follows RFC 4180 CSV specification
- **Self-documenting**: Includes metadata as comments

## File Naming Convention

```
[LabName]_[YYYY-MM-DD]_[HH-MM-SS].csv
```

### Examples

```
Environment_Monitor_2025-10-21_14-30-45.csv
Motion_Analysis_2025-10-21_15-45-12.csv
Indoor_Quality_2025-10-22_09-15-33.csv
```

### Rules

- Lab name with spaces replaced by underscores
- Date in ISO 8601 format (YYYY-MM-DD)
- Time in 24-hour format with hyphens (HH-MM-SS)
- Extension: `.csv`
- Max filename length: 255 characters

## File Structure

### Complete Example

```csv
# ==================================================
# Custom Lab Session Export
# ==================================================
# Lab Name: Environment Monitor
# Lab ID: abc123-def456-ghi789
# Session ID: session-001-xyz
# Session Status: completed
# ==================================================
# Recording Details
# ==================================================
# Start Time: 2025-10-21T14:30:45.123+06:00
# End Time: 2025-10-21T14:35:50.456+06:00
# Duration: 305 seconds (5 minutes 5 seconds)
# Recording Interval: 1000ms
# Total Data Points: 305
# ==================================================
# Sensor Configuration
# ==================================================
# Sensors: temperature, humidity, lightMeter, noiseMeter, barometer
# Temperature Unit: Celsius
# Humidity Unit: Percent
# Light Unit: Lux
# Noise Unit: Decibels
# Pressure Unit: hPa
# ==================================================
# Session Notes
# ==================================================
# Monitoring office environment during work hours
# ==================================================
# Data Section
# ==================================================
Timestamp,Sequence,Temperature_C,Humidity_Percent,Light_Lux,Noise_dB,Pressure_hPa
2025-10-21T14:30:45.123+06:00,1,22.5,45.2,350.0,42.3,1013.25
2025-10-21T14:30:46.123+06:00,2,22.6,45.1,352.0,43.1,1013.26
2025-10-21T14:30:47.123+06:00,3,22.5,45.3,351.0,42.8,1013.24
...
2025-10-21T14:35:50.456+06:00,305,23.1,44.8,355.0,41.9,1013.30
```

## Metadata Section (Comments)

### Header Block

```csv
# ==================================================
# Custom Lab Session Export
# ==================================================
```

- Fixed header identifying file type
- Helps with file recognition

### Lab Information

```csv
# Lab Name: [lab_name]
# Lab ID: [uuid]
# Session ID: [uuid]
# Session Status: [status]
```

### Recording Details

```csv
# Start Time: [ISO 8601 timestamp with timezone]
# End Time: [ISO 8601 timestamp with timezone]
# Duration: [seconds] ([human readable])
# Recording Interval: [milliseconds]ms
# Total Data Points: [count]
```

### Sensor Configuration

```csv
# Sensors: [comma-separated sensor list]
# [Sensor Name] Unit: [unit]
```

### Session Notes (Optional)

```csv
# Session Notes
# ==================================================
# [User-provided notes, multi-line supported]
```

## Data Section

### Column Structure

#### Required Columns

1. **Timestamp**

   - Format: ISO 8601 with milliseconds and timezone
   - Example: `2025-10-21T14:30:45.123+06:00`
   - Always first column
   - Never empty

2. **Sequence**
   - Format: Positive integer
   - Range: 1 to N
   - Sequential, no gaps
   - Used for data integrity verification

#### Sensor Columns

Format: `[SensorName]_[Unit]`

Examples:

- `Temperature_C` (Celsius)
- `Temperature_F` (Fahrenheit)
- `Humidity_Percent`
- `Light_Lux`
- `Noise_dB`
- `Pressure_hPa`
- `Acceleration_X_ms2` (m/s²)
- `Acceleration_Y_ms2`
- `Acceleration_Z_ms2`
- `GPS_Latitude_deg`
- `GPS_Longitude_deg`
- `GPS_Altitude_m`
- `Speed_kmh`
- `HeartRate_bpm`

### Data Types

| Sensor        | Data Type | Format       | Example   |
| ------------- | --------- | ------------ | --------- |
| Temperature   | float     | 1 decimal    | 22.5      |
| Humidity      | float     | 1 decimal    | 45.2      |
| Light         | float     | 1 decimal    | 350.0     |
| Noise         | float     | 1 decimal    | 42.3      |
| Pressure      | float     | 2 decimals   | 1013.25   |
| Accelerometer | float     | 6 decimals   | 0.123456  |
| Gyroscope     | float     | 6 decimals   | 0.987654  |
| GPS Lat/Lon   | float     | 6 decimals   | 23.810331 |
| GPS Altitude  | float     | 2 decimals   | 12.50     |
| Speed         | float     | 2 decimals   | 45.67     |
| Heart Rate    | integer   | whole number | 72        |
| Steps         | integer   | whole number | 1234      |

### Missing Data

- Use empty string (not NULL, NA, or 0)
- Example: `2025-10-21T14:30:45.123+06:00,1,22.5,,350.0,42.3,`
- Indicates sensor temporarily unavailable
- Document in metadata if persistent

## Sensor-Specific Formats

### Accelerometer & Gyroscope

```csv
Timestamp,Sequence,Accel_X_ms2,Accel_Y_ms2,Accel_Z_ms2,Gyro_X_rads,Gyro_Y_rads,Gyro_Z_rads
2025-10-21T14:30:45.123+06:00,1,0.123456,-0.987654,9.806650,0.001234,-0.005678,0.000123
```

### GPS

```csv
Timestamp,Sequence,GPS_Lat_deg,GPS_Lon_deg,GPS_Alt_m,GPS_Accuracy_m,GPS_Speed_ms,GPS_Bearing_deg
2025-10-21T14:30:45.123+06:00,1,23.810331,90.412518,12.50,5.0,0.00,0.0
```

### Magnetometer & Compass

```csv
Timestamp,Sequence,Mag_X_uT,Mag_Y_uT,Mag_Z_uT,Compass_Heading_deg
2025-10-21T14:30:45.123+06:00,1,45.123,-12.456,23.789,285.5
```

### Environmental Sensors

```csv
Timestamp,Sequence,Temp_C,Humidity_Percent,Pressure_hPa,Light_Lux,Noise_dB
2025-10-21T14:30:45.123+06:00,1,22.5,45.2,1013.25,350.0,42.3
```

### Health Sensors

```csv
Timestamp,Sequence,Steps_count,HeartRate_bpm,Cadence_spm
2025-10-21T14:30:45.123+06:00,1,1234,72,0
```

## File Encoding

- **Encoding**: UTF-8 with BOM (for Excel compatibility)
- **Line Endings**: CRLF (`\r\n`) for Windows compatibility
- **Delimiter**: Comma (`,`)
- **Quote Character**: Double quote (`"`) for values containing commas
- **Escape Character**: Double quote (`""`) for quotes within values

## File Size Estimation

### Per Data Point

- Timestamp: ~32 bytes
- Sequence: ~8 bytes
- Each sensor value: ~10 bytes average
- Total: ~50 + (10 × number_of_sensors) bytes

### Example Calculations

| Scenario       | Interval | Duration | Sensors | Data Points | Size    |
| -------------- | -------- | -------- | ------- | ----------- | ------- |
| Quick Test     | 1s       | 1 min    | 3       | 60          | ~5 KB   |
| Short Session  | 1s       | 10 min   | 5       | 600         | ~60 KB  |
| Medium Session | 1s       | 1 hour   | 5       | 3,600       | ~350 KB |
| Long Session   | 1s       | 8 hours  | 5       | 28,800      | ~2.7 MB |
| High Frequency | 100ms    | 10 min   | 8       | 6,000       | ~600 KB |

## Import Examples

### Python (pandas)

```python
import pandas as pd

# Read CSV, skipping metadata comments
df = pd.read_csv('Environment_Monitor_2025-10-21_14-30-45.csv',
                 comment='#',
                 parse_dates=['Timestamp'])

# Access data
print(df.head())
print(f"Average temperature: {df['Temperature_C'].mean():.2f}°C")

# Plot
df.plot(x='Timestamp', y='Temperature_C', title='Temperature Over Time')
```

### R

```r
library(readr)

# Read CSV
data <- read_csv('Environment_Monitor_2025-10-21_14-30-45.csv',
                 comment = '#')

# Summary
summary(data$Temperature_C)

# Plot
plot(data$Timestamp, data$Temperature_C, type='l',
     main='Temperature Over Time', xlab='Time', ylab='Temperature (°C)')
```

### MATLAB

```matlab
% Read CSV
data = readtable('Environment_Monitor_2025-10-21_14-30-45.csv', ...
                 'CommentStyle', '#');

% Access data
meanTemp = mean(data.Temperature_C);

% Plot
plot(data.Timestamp, data.Temperature_C);
title('Temperature Over Time');
xlabel('Time');
ylabel('Temperature (°C)');
```

### Excel/Google Sheets

1. Open file directly (Excel recognizes CSV)
2. Metadata comments appear as first rows (can hide)
3. Use Data > Text to Columns if needed
4. Create charts using column data

## Validation

### Data Integrity Checks

1. **Sequence Continuity**: Verify no gaps in sequence numbers
2. **Timestamp Monotonicity**: Ensure timestamps always increase
3. **Interval Consistency**: Check time difference matches recording interval
4. **Value Ranges**: Validate sensor values within expected ranges
5. **Missing Data**: Count and report empty values

### Example Validation Script (Python)

```python
def validate_csv(filepath):
    df = pd.read_csv(filepath, comment='#')

    # Check sequence continuity
    expected_seq = list(range(1, len(df) + 1))
    assert df['Sequence'].tolist() == expected_seq, "Sequence gaps detected"

    # Check timestamp monotonicity
    timestamps = pd.to_datetime(df['Timestamp'])
    assert timestamps.is_monotonic_increasing, "Timestamps not increasing"

    # Check for missing data
    missing = df.isnull().sum()
    if missing.any():
        print(f"Warning: Missing values detected:\n{missing[missing > 0]}")

    print("✓ CSV validation passed")
```

## Best Practices

### For App Developers

1. Always write metadata first
2. Flush buffer regularly during recording
3. Use transaction/batch writes for performance
4. Validate data before writing
5. Handle disk space errors gracefully
6. Compress large files (gzip) for storage/sharing

### For Data Analysts

1. Always inspect metadata section first
2. Check for missing data patterns
3. Verify timestamp ranges and intervals
4. Plot data to identify anomalies
5. Save processed data separately
6. Document any transformations applied

## Future Enhancements

Potential additions to CSV format:

- [ ] JSON metadata section (in addition to comments)
- [ ] Checksum/hash for data integrity
- [ ] Compressed CSV variants (.csv.gz)
- [ ] Binary format option for large datasets
- [ ] Parquet export for big data applications
- [ ] Real-time streaming export

## References

- RFC 4180: Common Format and MIME Type for CSV Files
- ISO 8601: Date and time format
- IEEE 754: Floating-point arithmetic
- [pandas CSV documentation](https://pandas.pydata.org/docs/reference/api/pandas.read_csv.html)
- [R readr package](https://readr.tidyverse.org/)
