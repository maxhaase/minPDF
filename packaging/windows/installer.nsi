; minPDF Windows installer (NSIS)
; Build with: makensis -DVERSION=1.0.0 installer.nsi

!ifndef VERSION
  !define VERSION "1.0.0"
!endif

Name "minPDF"
OutFile "minpdf-${VERSION}-setup.exe"
InstallDir "$PROGRAMFILES\minPDF"
RequestExecutionLevel admin
SetCompressor /SOLID lzma

Page directory
Page instfiles

Section "minPDF" SecMain
    SetOutPath "$INSTDIR"
    File "minpdf.bat"
    File "README.txt"
    SetOutPath "$INSTDIR\bin"
    File /r "bin\*.*"

    ; Add install dir to PATH
    EnVar::SetHKLM
    EnVar::AddValue "PATH" "$INSTDIR"
SectionEnd
