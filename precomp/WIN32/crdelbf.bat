del/p bf*.*
if %errorlevel% == 0 (
echo "Deleting Log Files"
dir .\logs
if exist logs\NUL del/p .\logs\bf*.*
)

