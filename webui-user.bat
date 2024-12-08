@echo off
title Stable Diffusion Web UI Japanese - ようこそ
echo Stable Diffusionへようこそ！このアプリは、AUTOMATIC1111さんのものを改造した、AIで画像を生成したり編集したりするソフトです。ソフト自体は英語です。任意のキーを押すとセットアップを開始します。
pause > nul
title Stable Diffusion Web UI Japanese - 変数の確認
set COMMANDLINE_ARGS=--use-cpu all --precision full --no-half --skip-torch-cuda-test
set SD_WEBUI_RESTART=tmp/restart
set ERROR_REPORTING=FALSE

call webui.bat
