# Custom Lab Feature

> Transform your device into a professional multi-sensor data logger with customizable lab configurations.

## 📊 Overview

The **Custom Lab** feature allows users to create personalized sensor combinations for synchronized multi-sensor data collection. Perfect for students, researchers, hobbyists, and professionals who need to record and analyze sensor data.

## ✨ Key Features

### 🧪 Custom Lab Creation

- **Flexible Sensor Selection**: Choose any combination of 15+ sensors
- **Custom Naming**: Give your labs meaningful names
- **Visual Customization**: Select icons and colors for easy identification
- **Adjustable Intervals**: Configure recording frequency (100ms - 10s)

### 📦 Pre-configured Presets

Six ready-to-use lab templates:

1. **Environment Monitor** 🌡️  
   Temperature, Humidity, Light, Noise, Pressure

2. **Motion Analysis** 🔄  
   Accelerometer, Gyroscope, Magnetometer, Compass

3. **Indoor Quality** 🏠  
   Light, Noise, Temperature, Humidity

4. **Outdoor Explorer** 🏔️  
   GPS, Altimeter, Speed, Barometer, Compass

5. **Vehicle Dynamics** 🚗  
   Accelerometer, Gyroscope, GPS, Speed

6. **Health Tracker** ❤️  
   Pedometer, Heart Rate, Accelerometer

### 📈 Recording & Analysis

- **Real-time Monitoring**: Watch sensor values update live
- **Session Management**: Save and organize multiple recording sessions
- **Session Notes**: Add context and observations
- **Data Visualization**: Live charts for each sensor

### 💾 Professional Export

- **CSV Format**: Industry-standard data export
- **Synchronized Timestamps**: All sensors time-aligned
- **Complete Metadata**: Session info, sensor config, and notes included
- **Easy Sharing**: Share files via email, cloud storage, or messaging

## 🏗️ Architecture

```
custom_lab/
├── domain/
│   ├── entities/              # Core business models
│   │   ├── sensor_type.dart   # 15+ sensor types
│   │   ├── lab.dart           # Lab configuration
│   │   ├── lab_session.dart   # Recording session
│   │   ├── sensor_data_point.dart
│   │   └── default_lab_presets.dart
│   └── repositories/
│       └── lab_repository.dart
├── data/
│   ├── models/                # Hive persistence models
│   └── repositories/
│       └── lab_repository_impl.dart
├── application/
│   ├── use_cases/             # Business logic
│   └── providers/             # Riverpod state management
├── presentation/
│   ├── screens/               # UI screens
│   └── widgets/               # Reusable components
└── docs/
    ├── FEATURE_SPEC.md        # Complete technical spec
    ├── IMPLEMENTATION_GUIDE.md # Step-by-step guide
    ├── CSV_FORMAT.md          # Export format spec
    └── README.md              # This file
```

## 📚 Documentation

- **[Feature Specification](./FEATURE_SPEC.md)** - Complete technical documentation
- **[Implementation Guide](./IMPLEMENTATION_GUIDE.md)** - Step-by-step development guide
- **[CSV Format Specification](./CSV_FORMAT.md)** - Data export format details

## 🚀 Quick Start

### For Developers

1. **Generate Code**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Register Hive Adapters**

   - TypeIds 20-24 reserved for Custom Lab
   - See Implementation Guide for details

3. **Initialize Presets**

   ```dart
   final presets = DefaultLabPresets.getDefaultPresets();
   ```

4. **Start Building**
   - Follow the Implementation Guide
   - Use existing sensor implementations as reference

### For Users

1. **Open Custom Lab** from home screen
2. **Choose a Preset** or **Create Custom Lab**
3. **Select Sensors** you want to record
4. **Start Recording**
5. **Export to CSV** when done

## 📱 Screenshots

```
[Labs List]  →  [Create Lab]  →  [Recording]  →  [Export CSV]
```

### Screens

- **Labs List**: Grid view of all your labs
- **Create Lab**: Visual sensor selection with customization
- **Lab Detail**: View configuration and session history
- **Recording**: Live sensor data with charts and controls
- **Session History**: Browse and export past sessions

## 💡 Use Cases

### Education

- Physics experiments
- Environmental science projects
- STEM learning activities

### Research

- Field data collection
- Laboratory experiments
- Behavioral studies

### Professional

- Equipment testing
- Quality control
- Environmental monitoring
- Vehicle diagnostics

### Personal

- Home automation
- Weather tracking
- Fitness analysis
- DIY electronics projects

## 🎯 Competitive Advantages

**vs Physics Toolbox Sensor Suite:**

- ✅ Beautiful modern UI (Material Design 3)
- ✅ Pre-configured templates
- ✅ Custom lab organization
- ✅ Better session management

**vs Sensor Data Logger:**

- ✅ Visual preset selection
- ✅ Real-time charts
- ✅ Easier customization
- ✅ Professional export format

**vs Sensor Logger:**

- ✅ Organized lab structure
- ✅ Session notes and metadata
- ✅ Better UX for common workflows
- ✅ Cloud-ready architecture

## 📊 Data Format

### CSV Export Example

```csv
# Lab Name: Environment Monitor
# Start Time: 2025-10-21T14:30:45.123+06:00
# Duration: 305 seconds
Timestamp,Sequence,Temperature_C,Humidity_Percent,Light_Lux,Noise_dB,Pressure_hPa
2025-10-21T14:30:45.123+06:00,1,22.5,45.2,350.0,42.3,1013.25
2025-10-21T14:30:46.123+06:00,2,22.6,45.1,352.0,43.1,1013.26
...
```

See [CSV_FORMAT.md](./CSV_FORMAT.md) for complete specification.

## 🔧 Technical Details

### Storage

- **Hive Database**: Local persistence
- **TypeIds**: 20-24 (SensorType, Lab, RecordingStatus, LabSession, SensorDataPoint)
- **Boxes**: customLabsBox, labSessionsBox, sensorDataBox

### Performance

- Batch writes every 10 data points
- Background CSV generation
- Lazy loading for large datasets
- Efficient memory management

### Supported Sensors

✅ Accelerometer  
✅ Gyroscope  
✅ Magnetometer  
✅ Barometer  
✅ Light Meter  
✅ Noise Meter  
✅ GPS  
✅ Proximity  
✅ Temperature  
✅ Humidity  
✅ Pedometer  
✅ Compass  
✅ Altimeter  
✅ Speed Meter  
✅ Heart Rate

## 🔮 Future Enhancements

- [ ] Cloud sync and backup
- [ ] Collaborative labs (share with team)
- [ ] Advanced analytics dashboard
- [ ] Automated reports
- [ ] AI-powered pattern detection
- [ ] Lab marketplace (community templates)
- [ ] Real-time collaboration
- [ ] Export to JSON, MATLAB, NumPy
- [ ] Integration with cloud platforms
- [ ] API for external tools

## 📄 License

Part of the SensorLab project. See root LICENSE file.

## 🤝 Contributing

See [IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md) for development setup.

## 📞 Support

For issues or questions:

1. Check the documentation
2. Review existing sensor implementations
3. Create a GitHub issue

---

**Created**: October 2025  
**Status**: In Development  
**Target Release**: v2.0.0  
**Priority**: High
