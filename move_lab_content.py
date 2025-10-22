import os
import shutil

source_path = 'lib/src/features/custom_lab/presentation/widgets/lab_monitoring_content.dart'
destination_path = 'lib/src/features/custom_lab/presentation/widgets/recording_screen/lab_monitoring_content.dart'

shutil.move(source_path, destination_path)