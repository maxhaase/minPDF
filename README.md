# minPDF

**Multi-use utility for PDF files.**

`minPDF` is a small, dependency-light shell utility that currently
**shrinks** and **merges** PDF files, with more utilities planned. It
preserves color and quality by default, and can optionally produce
grayscale output. It is designed for command-line users who want a
straightforward, transparent tool that never overwrites their source
files.

Author: **Max Haase** &lt;<maxhaase@gmail.com>&gt;

---

## Features

- **Compress** PDF files while keeping color and readable quality.
- **Merge** several PDFs into a single document (via `pdfunite`) before
  compression.
- **Grayscale mode** (`-g`) for smaller outputs.
- **Adjustable quality** (`-q 0..100`) so you can trade size for fidelity.
- **Safe output naming** — by default the output is written as
  `<basename>_YYYYMMDD_hhmmss.pdf`, so your original file is never
  modified. You can still override the name with `-o NAME`.
- **Wildcard input** — `minpdf *.pdf` (or the literal `*`) picks up every
  PDF in the current directory.
- **Automatic dependency installation** — if `ghostscript` or
  `pdfunite` is missing, the script tells you in red and offers to
  install it via `apt`, `dnf`, `yum`, `zypper`, or `pacman`.

---

## Requirements

| Program      | Purpose                         | Debian / Ubuntu | Fedora / RHEL | Arch        |
|--------------|---------------------------------|-----------------|---------------|-------------|
| `gs`         | Ghostscript PDF rendering       | `ghostscript`   | `ghostscript` | `ghostscript` |
| `pdfunite`   | PDF merging (Poppler)           | `poppler-utils` | `poppler-utils` | `poppler`   |

On first run, `minPDF` detects missing programs and offers to install
them for you (you will be asked for your `sudo` password).

---

## Installation

```sh
git clone https://github.com/maxhaase/minPDF.git
cd minPDF

chmod +x minpdf
sudo install -m 0755 minpdf /usr/local/bin/minpdf
