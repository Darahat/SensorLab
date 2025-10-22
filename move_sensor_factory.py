import os
import shutil

source_path = 'lib/src/features/custom_lab/presentation/widgets/sensor_component_factory.dart'
destination_path = 'lib/src/features/custom_lab/presentation/widgets/recording_screen/sensor_component_factory.dart'

shutil.move(source_path, destination_path)