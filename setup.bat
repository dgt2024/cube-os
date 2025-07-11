@echo off
setlocal enabledelayedexpansion
cd C:\Users\ENVY\Desktop\Proyects\Cube OS
del os.img
fasm kernel.asm k.bin || goto error
fasm ramload.asm r.bin || goto error
fasm pointers.asm p.bin || goto error
fasm config.asm c.bin || goto error
fasm fileload.asm l.bin || goto error
fasm explorer.asm explorer.bin || goto error
fasm notepad.asm notepad.bin || goto error
fasm binary.asm binary.bin || goto error
fasm font.asm font.bin || goto error
copy /b k.bin + r.bin + p.bin + c.bin + l.bin + explorer.bin + notepad.bin + binary.bin + font.bin os.img
del k.bin
del r.bin
del c.bin
del l.bin
del p.bin
del explorer.bin
del binary.bin
del notepad.bin
del font.bin
powershell -Command "$f = [System.IO.File]::Open('os.img', 'Open', 'Write'); $f.Seek(1474560 - 1, 'Begin') > $null; $f.WriteByte(0); $f.Close()" || goto error
goto end
:error
pause
:end
"C:\Program Files\qemu\qemu-system-i386.exe" -fda os.img -full-screen
endlocal