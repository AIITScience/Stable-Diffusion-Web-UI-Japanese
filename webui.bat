cd %~dp0%
set VENV_DIR=%~dp0%venv
title Stable Diffusion Web UI Japanese - Gitの確認
git version
if %ERRORLEVEL% == 9009 (
echo Gitがインストールされていません。インストールしています。
winget install --id Git.Git -e --source winget
goto :show_stdout_stderr
)
set "GIT_PYTHON_GIT_EXECUTABLE=%GIT%"

title Stable Diffusion Web UI Japanese - pythonの確認
python -c "" >tmp/stdout.txt 2>tmp/stderr.txt
if %ERRORLEVEL% == 0 goto :check_pip
title Stable Diffusion Web UI Japanese - pythonのインストール
echo Pythonがインストールされていません。インストールしてください。
echo ※パスを通してください。
pyinstall
goto :show_stdout_stderr

:check_pip
python -mpip --help >tmp/stdout.txt 2>tmp/stderr.txt
if %ERRORLEVEL% == 0 goto :start_venv
if "%PIP_INSTALLER_LOCATION%" == "" goto :show_stdout_stderr
python "%PIP_INSTALLER_LOCATION%" >tmp/stdout.txt 2>tmp/stderr.txt
if %ERRORLEVEL% == 0 goto :start_venv
echo pipをインストールできませんでした。
goto :show_stdout_stderr

:start_venv
title Stable Diffusion Web UI Japanese - %VENV_DIR%の起動
if ["%VENV_DIR%"] == ["-"] goto :skip_venv
if ["%SKIP_VENV%"] == ["1"] goto :skip_venv

dir "%VENV_DIR%\Scripts\Python.exe" >tmp/stdout.txt 2>tmp/stderr.txt
if %ERRORLEVEL% == 0 goto :activate_venv

for /f "delims=" %%i in ('CALL python -c "import sys; print(sys.executable)"') do set PYTHON_FULLNAME="%%i"
title Stable Diffusion Web UI Japanese - %PYTHON_FULLNAME%による%VENV_DIR%の作成
%PYTHON_FULLNAME% -m venv "%VENV_DIR%" >tmp/stdout.txt 2>tmp/stderr.txt
if %ERRORLEVEL% == 0 goto :upgrade_pip
echo %VENV_DIR%にvenvを作成できません
goto :show_stdout_stderr

:upgrade_pip
"%VENV_DIR%\Scripts\Python.exe" -m pip install --upgrade pip
if %ERRORLEVEL% == 0 goto :activate_venv
echo 警告:PIP バージョンのアップグレードに失敗しました

:activate_venv
set PYTHON="%VENV_DIR%\Scripts\Python.exe"
title Stable Diffusion Web UI Japanese - %PYTHON%の起動
call "%VENV_DIR%\Scripts\activate.bat"

:skip_venv
title Stable Diffusion Web UI Japanese - venvのスキップ
set ACCELERATE="%VENV_DIR%\Scripts\accelerate.exe"
if [%ACCELERATE%] == ["True"] goto :accelerate
goto :launch

:accelerate
title Stable Diffusion Web UI Japanese - %ACCELERATE%の確認
if EXIST %ACCELERATE% goto :accelerate_launch

:launch
title Stable Diffusion Web UI Japanese - 起動
echo ※"No module named 'モジュール名'"と表示されたら、再起動すると直る可能性があります。
%PYTHON% launch.py %*
if EXIST tmp/restart goto :skip_venv
pause
exit /b

:accelerate_launch
title Stable Diffusion Web UI Japanese - %ACCELERATE%での起動
%ACCELERATE% launch --num_cpu_threads_per_process=6 launch.py
if EXIST tmp/restart goto :skip_venv
pause
exit /b

:show_stdout_stderr
echo.
echo 終了コード:%ERRORLEVEL%
for /f %%i in ("tmp\stdout.txt") do set size=%%~zi
if %size% equ 0 goto :show_stderr
echo.
echo 標準出力:
type tmp\stdout.txt

:show_stderr
for /f %%i in ("tmp\stderr.txt") do set size=%%~zi
if %size% equ 0 goto :show_stderr
echo.
echo 標準エラー出力:
type tmp\stderr.txt

:endofscript
title Stable Diffusion Web UI Japanese - 起動失敗
echo.
echo 起動に失敗しました。任意のキーを押すと終了します。
pause>nul
