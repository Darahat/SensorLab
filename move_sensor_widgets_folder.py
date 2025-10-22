import os
import shutil

source_path = 'lib/src/features/custom_lab/presentation/widgets/sensor_widgets'
destination_path = 'lib/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets'

shutil.move(source_path, destination_path)