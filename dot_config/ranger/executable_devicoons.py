from ranger.api.linemode import LinemodeBase
from ranger.core.linemode import DEFAULT_LINEMODES
import os

class DevIconsLinemode(LinemodeBase):
    name = "devicons"

    def filetitle(self, file, metadata):
        icons = {
            'dir': "",
            'py': "",
            'c': "",
            'cpp': "",
            'sh': "",
            'txt': "",
            'jpg': "",
            'png': "",
            'md': "",
            'zip': "",
            'tar': "",
            'mp3': "",
            'mp4': "",
            'pdf': "",
        }
        ext = file.extension or ''
        return f"{icons.get(ext, icons.get('dir' if file.is_directory else 'txt'))} {file.relative_path}"
