import os
import shutil

source_path = 'lib/src/features/custom_lab/presentation/widgets/session_complete_dialog.dart'
destination_path = 'lib/src/features/custom_lab/presentation/widgets/recording_screen/session_complete_dialog.dart'

shutil.move(source_path, destination_path)