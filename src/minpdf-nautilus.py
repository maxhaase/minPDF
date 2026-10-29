import subprocess
from gi.repository import Nautilus, GObject

class MinPdfExtension(GObject.GObject, Nautilus.MenuProvider):
    def get_file_items(self, *args):
        files = args[-1]
        if not files: return []
        for file in files:
            if file.is_directory() or not file.get_name().lower().endswith('.pdf'):
                return []
        item = Nautilus.MenuItem(
            name="MinPdf::Compress", label="Compress with minPDF",
            tip="Compress and/or merge selected PDFs", icon="application-pdf"
        )
        item.connect("activate", self.menu_activate_cb, files)
        return [item]

    def menu_activate_cb(self, menu, files):
        paths = [f.get_location().get_path() for f in files if f.get_location()]
        if paths:
            subprocess.Popen(["/usr/bin/minpdf-gui"] + paths)
