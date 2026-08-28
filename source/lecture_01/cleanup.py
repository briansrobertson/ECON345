import shutil
from pathlib import Path

try: 
    shutil.rmtree('class_materials/slides')
except:
    pass

try:
    shutil.rmtree('class_materials/hw')
except:
    pass

dir_path=Path('./')
ext='*.ttf'

for file_path in dir_path.glob(ext):
    if file_path.is_file():
        file_path.unlink()