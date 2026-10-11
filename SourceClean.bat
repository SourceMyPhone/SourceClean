@echo off
setlocal EnableDelayedExpansion
title SourceClean
chcp 866 >nul
if not exist "%SCDIR%" md "%SCDIR%" >nul 2>&1
icacls "%SCDIR%" /inheritance:r /grant "*S-1-5-32-544:(OI)(CI)F" /grant "*S-1-5-18:(OI)(CI)F" >nul 2>&1
if not exist "%QDIR%" md "%QDIR%" >nul 2>&1
icacls "%QDIR%" /inheritance:r /grant "*S-1-5-32-544:(OI)(CI)F" /grant "*S-1-5-18:(OI)(CI)F" >nul 2>&1
if exist "%LOCALAPPDATA%\SourceClean_settings.cfg" move /y "%LOCALAPPDATA%\SourceClean_settings.cfg" "%CFG%" >nul 2>&1
if exist "%LOCALAPPDATA%\SourceClean_visual.cfg" move /y "%LOCALAPPDATA%\SourceClean_visual.cfg" "%VCFG%" >nul 2>&1
if exist "%LOCALAPPDATA%\SourceClean_tasks.txt" move /y "%LOCALAPPDATA%\SourceClean_tasks.txt" "%TASKS%" >nul 2>&1

:: ============================================================
::  SourceClean - cleanup and cooler toolkit
::  CLI: SourceClean.bat [/en|/ru] [/cleanup|/calm|/deep|/restore|/turbo|/info|/temps|/antirat|/miner|/visual]
:: ============================================================

cd /d "%~dp0"
set "SCDIR=%ProgramData%\SourceClean"
set "CFG=%SCDIR%\SourceClean_settings.cfg"
set "TASKS=%SCDIR%\SourceClean_tasks.txt"
set "TASKS=%LOCALAPPDATA%\SourceClean_tasks.txt"
set "FLAG=%LOCALAPPDATA%\SourceClean_calm.flag"
set "LOG=%LOCALAPPDATA%\SourceClean.log"
set "BAK=%LOCALAPPDATA%\SourceClean_backup"
set "VCFG=%SCDIR%\SourceClean_visual.cfg"
set "QDIR=%SCDIR%\Quarantine"

fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo    Requesting administrator rights...
    echo    Запрашиваю права администратора...
set "SELF=%~f0"
set "SARGS=%*"
powershell -NoProfile -Command "$p=@{FilePath=$env:SELF;Verb='RunAs'};if($env:SARGS){$p.ArgumentList=$env:SARGS};Start-Process @p"
    exit /b
)

:: ---------------- CLI args ----------------
set "L=R"
set "ACT="
if /i "%~1"=="/en" (set "L=E" & set "ACT=%~2") else if /i "%~1"=="/ru" (set "L=R" & set "ACT=%~2") else set "ACT=%~1"
if defined ACT goto strings
goto lang

:strings
set "S_ON=ON"
set "S_OFF=OFF"
set "S_STATUS=Calm mode"
set "S_M1=Full cleanup - Edge, temp files, junk"
set "S_M2=Calm mode - cooler and quieter, reversible"
set "S_M3=Fine-tune - telemetry, ads, caches"
set "S_M4=Restore settings - undo Calm mode"
set "S_M5=Turbo boost - quick on/off"
set "S_M6=System info - RAM, disk, processes"
set "S_M7=Temperatures - GPU and CPU"
set "S_M0=Exit"
set "S_CHOOSE=Choose"
set "S_C1_TITLE=FULL CLEANUP"
set "S_C1A=creates a system restore point"
set "S_C1B=uninstalls Microsoft Edge"
set "S_C1C=purges temp files and caches"
set "S_C1D=Edge updater stays: WebView2 needs it"
set "S_C1Q=Proceed? (Y/N)"
set "S_WILLFREE=can be freed:"
set "S_FREED=Freed:"
set "S_RECYCLEQ=Empty the Recycle Bin permanently? (Y/N)"
set "S_RECYCLED=Recycle Bin emptied."
set "S_RECYCLEK=Recycle Bin kept."
set "S_C1_DONE=CLEANUP COMPLETE"
set "S_C1_NOTE=Edge removed. A major Windows update may restore it"
set "S_C1_NOTE2=just run cleanup again."
set "S_C2_TITLE=CALM MODE"
set "S_C2A=creates a restore point"
set "S_C2B=saves your settings, first run only"
set "S_C2C=disables SysMain, Search indexer, background"
set "S_C2C2=apps, GameDVR, NVIDIA task, CPU turbo boost"
set "S_ALREADY=Calm mode is already ON"
set "S_ALREADY2=Your original settings are kept safe"
set "S_REAPPLYQ=Re-apply anyway? (Y/N)"
set "S_ENABLEQ=Enable CALM MODE? (Y/N)"
set "SAVING=Saving your current settings..."
set "SAVED=Saved."
set "S_BACKUP=Registry backup:"
set "S_SAVEFAIL=Could not save settings completely"
set "S_SAVEFAIL2=Restore will fall back to defaults"
set "S_CONTINUEQ=Continue anyway? (Y/N)"
set "S_STEP1=SysMain - off"
set "S_STEP2=Windows Search indexer - off"
set "S_STEP3=Background apps - off"
set "S_STEP4=Game DVR - off"
set "S_STEP5=CPU turbo boost - off"
set "S_STEP6=NVIDIA overlay - off"
set "S_SCHEMEWARN=WARNING: could not apply power scheme"
set "S_C2_DONE=CALM MODE ON - reboot recommended"
set "S_C2_NOTE=Idle temps drop; peak FPS may drop 5-15 percent"
set "S_C2_NOTE2=[4] Restore brings your settings back"
set "S_REST_FOUND=Saved settings found. Restoring YOUR values..."
set "S_SCHEMEGONE=Saved power scheme not found - using current one"
set "S_REST_DONE=Your settings are back. Reboot to apply fully."
set "S_DEF_FOUND=No saved settings. Restoring Windows defaults..."
set "S_DEF_DONE=Defaults restored. Reboot."
set "S_TEMP_TITLE=TEMPERATURES"
set "S_TEMP1=GPU 50C at 0 percent fan - excellent"
set "S_TEMP2=CPU 70-85C under load - normal"
set "S_NOGPU=nvidia-smi not found - NVIDIA driver missing?"
set "S_RP_MAKING=Creating a system restore point..."
set "S_RP_OK=Restore point created."
set "S_RP_FAIL=RESTORE POINT FAILED"
set "S_RP_CONTQ=Continue without it? (Y/N)"
set "S_NUKE_WARN=WARNING: could not fully remove"
set "S_NUKE_HINT=run again after reboot"
set "S_REMOVED=removed:"
set "S_D_TITLE=FINE-TUNE"
set "S_D_APPLY=Apply selected? (Y/N)"
set "S_D_NONE=Nothing selected."
set "S_D_HINT=[number] toggle, [A] all, [0] apply, [M] menu"
set "S_D_NOTE=Not covered by [4] Restore"
set "S_D1=Telemetry (DiagTrack, dmwappush)"
set "S_D2=Search ads and highlights"
set "S_D3=Game Bar: capture and DVR off"
set "S_D4=Browser caches (closed browsers)"
set "S_D5=Prefetch (next boots slower)"
set "S_D6=Old restore points (keep last)"
set "S_D7=Event Viewer logs"
set "S_D8=REMOVE Xbox Game Bar + silence popup - not in [A]"
set "S_T_ON=TURBO ON (100 percent)"
set "S_T_OFF=TURBO OFF (99 percent) - cooler"
set "S_INFO_TITLE=SYSTEM"
set "S_TOP=Top processes (RAM):"
set "S_M8=Anti-RAT - keyboard canary + scanner"
set "S_AR_TITLE=ANTI-RAT CHECK"
set "S_AR_HOOKNOTE=The keyboard hook is temporary, it dies with this window (Ctrl+C too)"
set "S_AR_PHRASE=Type this phrase and press Enter"
set "S_AR_GO=Press any key to arm the hook"
set "S_AR_LEGEND1=[OK] clean   [WARN] look at the line   [i] information only"
set "S_AR_LEGEND2=INJECTED_KEYS: Punto Switcher, AutoHotkey and on-screen keyboard also count - judge by context"
set "S_M9=Anti-miner - watches GPU while idle"
set "S_AM_TITLE=ANTI-MINER IDLE SCAN"
set "S_AM_NOTE=Close games and browsers, then do NOT touch the PC for 10-15 minutes"
set "S_MA=Visual effects - transparency, animations"
set "S_MB=System tools - 12 utilities"
set "S_MC=Linux mode - max lightweight"
set "S_LIN_T=LINUX MODE - MAXIMUM LIGHTWEIGHT"
set "S_LIN_W1=Aggressive: visuals off, animations off, notifications off,"
set "S_LIN_W2=SysMain, Search, telemetry, GameDVR, OneDrive autostart off."
set "S_LIN_W3=Undo: restore point (rstrui) or [4] for power/services part."
set "S_LIN_OK=LINUX MODE ON - reboot recommended."
set "S_LIN_OK2=Windows now looks plain but runs as light as possible."
set "S_V_AN=Animations"
set "S_V_T=Transparency"
set "S_B_TITLE=SYSTEM TOOLS"
set "S_B1=Uninstall OneDrive"
set "S_B2=Remove bloatware (Appx)"
set "S_B3=Disable hibernation"
set "S_B4=SFC + DISM system check"
set "S_B5=Full Windows Update cache purge"
set "S_B6=Disable Delivery Optimization"
set "S_B7=Power: USB suspend + PCIe off"
set "S_B8=Reset Winsock / TCP"
set "S_B9=Disable tips and ads"
set "S_B10=Startup manager (read-only)"
set "S_B11=Battery report"
set "S_B12=Font cache cleanup"
set "S_A_DONE=Done."
set "S_INVBAD=Invalid process name (letters, dots, dashes only)"
set "S_ST_SEL=Numbers to quarantine (like 1,3; A=all; Enter=skip)"
set "S_B13=Strange files scan"
set "S_ST_TITLE=STRANGE FILES SCAN"
set "S_ST_NOTE=Scanning Windows folders for unsigned executables (up to a minute)..."
set "S_ST_CLEAN=No unsigned executables in system folders - clean"
set "S_ST_Q=Move to quarantine? (Y/N)"
set "S_ST_QD=moved to quarantine"
set "S_ST_KEEP=kept - decide yourself later"
set "S_ST_FAIL=could not move (file in use?)"
set "S_ST_QDIR=Quarantine folder:"
set "S_DON=Donate (TON):"
set "S_LIN_M1=Enable Linux mode"
set "S_LIN_M2=Disable Linux mode (restore previous state)"
set "S_LIN_OFF=LINUX MODE - DISABLE"
set "S_LIN_SVC=Services restored from saved state"
set "S_LIN_DEF=No saved state - Windows defaults applied"
set "S_LIN_OFFOK=LINUX MODE OFF - reboot recommended"
set "S_LIN_HIB=Hibernation stays off (powercfg /hibernate on to return)"
set "S_VR=Restore visuals as before"
set "S_VRN=Nothing saved yet - nothing to restore"
set "S_VRS=Visuals restored as they were"
set "S_RB=Reboot now? (Y/N)"
set "S_MD=Network"
set "S_N1=Connection:"
set "S_N2=LAN neighbors (devices this PC sees):"
set "S_N3=Active internet connections:"
set "S_N4=Traffic by process (10 sec, approx, includes disk IO):"
set "S_N5=Router client list lives in the router settings (192.168.0.1 or 192.168.1.1)"
set "S_N6=Adapter totals:"
    set "S_VR=Вернуть визуал как было"
    set "S_VRN=Пока нечего возвращать"
    set "S_VRS=Визуал возвращён как был"
    set "S_RB=Перезагрузить сейчас? (Y/N)"
    set "S_MD=Сеть"
    set "S_N1=Подключение:"
    set "S_N2=Соседи по сети (кого видит этот ПК):"
    set "S_N3=Активные соединения с интернетом:"
    set "S_N4=Трафик по процессам (10 сек, примерно, включает диск):"
    set "S_N5=Список клиентов роутера - только в настройках роутера (192.168.0.1 или 192.168.1.1)"
    set "S_N6=Итого по адаптерам:"
set "S_SYS=[SYS] = system (protected)"
set "S_APP=[APP] = app (can close)"
set "S_PROT=REFUSED: that is a system process - killing it can crash Windows. Not touching it."
set "S_BGL=system / app"
set "S_B4N=This takes 10-30 minutes"
set "S_B11N=No battery found (desktop PC?)"
set "S_B10T=Non-Microsoft scheduled tasks"
set "S_B10H=Manage: Task Manager - Startup apps"
set "S_A_TITLE=VISUAL EFFECTS"
set "S_A1=Transparency effects"
set "S_A2=Taskbar transparency"
set "S_A3=Disable animations"
set "S_A_ON=Enabled"
set "S_A_OFF=Disabled"
set "S_A_DONE=Visual effects applied"
set "S_KILL=Kill process by name (0 = back)"
set "S_KILLED=Process killed"
set "S_NOTFOUND=Process not found"
set "S_BG=Background processes (RAM):"

if /i "%L%"=="R" (
    set "S_ON=ВКЛ"
    set "S_OFF=ВЫКЛ"
    set "S_STATUS=Тихий режим"
    set "S_M1=Полная очистка - Edge, Temp, мусор"
    set "S_M2=Тихий режим - холоднее и тише, обратимо"
    set "S_M3=Тонкая настройка - телеметрия, реклама"
    set "S_M4=Вернуть настройки - откат Тихого режима"
    set "S_M5=Турбо-буст - быстрый вкл/выкл"
    set "S_M6=Система - RAM, диск, процессы"
    set "S_M7=Температуры - GPU и CPU"
    set "S_M0=Выход"
    set "S_CHOOSE=Выбор"
    set "S_C1_TITLE=ПОЛНАЯ ОЧИСТКА"
    set "S_C1A=создаст точку восстановления системы"
    set "S_C1B=удалит Microsoft Edge"
    set "S_C1C=очистит временные файлы и кэш"
    set "S_C1D=Обновлятор Edge остается: он нужен для WebView2"
    set "S_C1Q=Продолжить? (Y/N)"
    set "S_WILLFREE=можно освободить:"
    set "S_FREED=Освобождено:"
    set "S_RECYCLEQ=Очистить корзину безвозвратно? (Y/N)"
    set "S_RECYCLED=Корзина очищена."
    set "S_RECYCLEK=Корзина не тронута."
    set "S_C1_DONE=ОЧИСТКА ЗАВЕРШЕНА"
    set "S_C1_NOTE=Edge удален. Крупное обновление Windows может вернуть его,"
    set "S_C1_NOTE2=тогда просто запустите очистку снова."
    set "S_C2_TITLE=ТИХИЙ РЕЖИМ"
    set "S_C2A=создаст точку восстановления"
    set "S_C2B=сохранит ваши настройки, только при первом запуске"
    set "S_C2C=отключит SysMain, индексатор поиска, фоновые"
    set "S_C2C2=приложения, GameDVR, задачу NVIDIA и турбо-буст CPU"
    set "S_ALREADY=Тихий режим уже ВКЛЮЧЕН"
    set "S_ALREADY2=Ваши исходные настройки в безопасности"
    set "S_REAPPLYQ=Применить повторно? (Y/N)"
    set "S_ENABLEQ=Включить ТИХИЙ РЕЖИМ? (Y/N)"
    set "SAVING=Сохраняю ваши текущие настройки..."
    set "SAVED=Сохранено."
    set "S_BACKUP=Копия реестра:"
    set "S_SAVEFAIL=Не удалось сохранить настройки полностью"
    set "S_SAVEFAIL2=Восстановление применит значения по умолчанию"
    set "S_CONTINUEQ=Продолжить все равно? (Y/N)"
    set "S_STEP1=SysMain - выкл"
    set "S_STEP2=Индексатор поиска - выкл"
    set "S_STEP3=Фоновые приложения - выкл"
    set "S_STEP4=Game DVR - выкл"
    set "S_STEP5=Турбо-буст CPU - выкл"
    set "S_STEP6=Оверлей NVIDIA - выкл"
    set "S_SCHEMEWARN=ВНИМАНИЕ: не удалось применить схему питания"
    set "S_C2_DONE=ТИХИЙ РЕЖИМ ВКЛЮЧЕН - нужна перезагрузка"
    set "S_C2_NOTE=В простое температура падает; пиковый FPS может упасть на 5-15 процентов"
    set "S_C2_NOTE2=[4] Вернуть настройки вернет все обратно"
    set "S_REST_FOUND=Найдены сохраненные настройки. Возвращаю ВАШИ значения..."
    set "S_SCHEMEGONE=Сохраненная схема питания не найдена - беру текущую"
    set "S_REST_DONE=Ваши настройки возвращены. Перезагрузите ПК."
    set "S_DEF_FOUND=Сохраненных настроек нет. Возвращаю настройки Windows по умолчанию..."
    set "S_DEF_DONE=Готово. Перезагрузите ПК."
    set "S_TEMP_TITLE=ТЕМПЕРАТУРЫ"
    set "S_TEMP1=GPU 50C при 0 процентов кулера - отлично"
    set "S_TEMP2=CPU 70-85C под нагрузкой - норма"
    set "S_NOGPU=nvidia-smi не найден - нет драйвера NVIDIA?"
    set "S_RP_MAKING=Создаю точку восстановления системы..."
    set "S_RP_OK=Точка восстановления создана."
    set "S_RP_FAIL=ТОЧКА ВОССТАНОВЛЕНИЯ НЕ СОЗДАНА"
    set "S_RP_CONTQ=Продолжить без нее? (Y/N)"
    set "S_NUKE_WARN=ВНИМАНИЕ: не удалось полностью удалить"
    set "S_NUKE_HINT=запустите снова после перезагрузки"
    set "S_REMOVED=удалено:"
    set "S_D_TITLE=ТОНКАЯ НАСТРОЙКА"
    set "S_D_APPLY=Применить выбранное? (Y/N)"
    set "S_D_NONE=Ничего не выбрано."
    set "S_D_HINT=[номер] переключить, [A] все, [0] применить, [M] меню"
    set "S_D_NOTE=Не входит в [4] Вернуть настройки"
    set "S_D1=Телеметрия (DiagTrack, dmwappush)"
    set "S_D2=Реклама и подсказки в поиске"
    set "S_D3=Game Bar: отключить запись (DVR)"
    set "S_D4=Кэш браузеров (если они закрыты)"
    set "S_D5=Prefetch (следующие загрузки медленнее)"
    set "S_D6=Старые точки восстановления (кроме последней)"
    set "S_D7=Журналы событий"
    set "S_D8=УДАЛИТЬ Xbox Game Bar + убрать окно - не входит в [A]"
    set "S_T_ON=ТУРБО ВКЛ (100 процентов)"
    set "S_T_OFF=ТУРБО ВЫКЛ (99 процентов) - холоднее"
    set "S_INFO_TITLE=СИСТЕМА"
    set "S_TOP=Топ процессов (RAM):"
    set "S_M8=Анти-РАТ - канарейка + сканер"
    set "S_AR_TITLE=ПРОВЕРКА АНТИ-РАТ"
    set "S_AR_HOOKNOTE=Перехват клавиатуры временный, он умирает вместе с этим окном (и по Ctrl+C)"
    set "S_AR_PHRASE=Введите фразу и нажмите Enter"
    set "S_AR_GO=Нажмите любую клавишу, чтобы включить перехват"
    set "S_AR_LEGEND1=[OK] чисто   [WARN] проверьте строку   [i] только информация"
    set "S_AR_LEGEND2=INJECTED_KEYS: Punto Switcher, AutoHotkey и экранная клавиатура тоже считаются - смотрите по контексту"
    set "S_M9=Анти-майнер - следит за GPU в простое"
    set "S_AM_TITLE=ПРОВЕРКА АНТИ-МАЙНЕР В ПРОСТОЕ"
    set "S_AM_NOTE=Закройте игры и браузеры и не трогайте ПК 10-15 минут"
    set "S_MA=Визуальные эффекты - прозрачность, анимации"
    set "S_MB=Системные инструменты - 12 утилит"
    set "S_A_DONE=Готово."
    set "S_INVBAD=Некорректное имя процесса (только буквы, точки, дефисы)"
    set "S_ST_SEL=Номера в карантин (например 1,3; A=все; Enter=пропустить)"
    set "S_B13=Поиск странных файлов"
    set "S_ST_TITLE=ПОИСК СТРАННЫХ ФАЙЛОВ"
    set "S_ST_NOTE=Ищу неподписанные .exe в системных папках (до минуты)..."
    set "S_ST_CLEAN=Неподписанных .exe в системных папках нет - чисто"
    set "S_ST_Q=Переместить в карантин? (Y/N)"
    set "S_ST_QD=перемещено в карантин"
    set "S_ST_KEEP=оставлен - решите сами позже"
    set "S_ST_FAIL=не удалось переместить (файл занят?)"
    set "S_ST_QDIR=Папка карантина:"
    set "S_DON=Донат (TON):"
    set "S_LIN_M1=Включить режим Linux"
    set "S_LIN_M2=Отключить режим Linux (вернуть как было)"
    set "S_LIN_OFF=РЕЖИМ LINUX - ОТКЛЮЧЕНИЕ"
    set "S_LIN_SVC=Службы возвращены из сохранённого состояния"
    set "S_LIN_DEF=Сохранений нет - применены значения Windows по умолчанию"
    set "S_LIN_OFFOK=РЕЖИМ LINUX ОТКЛЮЧЁН - нужна перезагрузка"
    set "S_LIN_HIB=Гибернация остаётся выкл (вернуть: powercfg /hibernate on)"
    set "S_SYS=[SYS] = системный (защищён)"
    set "S_APP=[APP] = приложение (можно закрыть)"
    set "S_PROT=ОТКАЗ: это системный процесс - если его убить, Windows может сломаться. Не трогаю."
    set "S_BGL=системный / приложение"
    set "S_MC=Режим Linux - максимум лёгкости"
    set "S_LIN_T=РЕЖИМ LINUX - МАКСИМАЛЬНАЯ ЛЁГКОСТЬ"
    set "S_LIN_W1=Агрессивно: визуал выкл, анимации выкл, уведомления выкл,"
    set "S_LIN_W2=SysMain, Поиск, телеметрия, GameDVR, автозапуск OneDrive выкл."
    set "S_LIN_W3=Откат: точка восстановления (rstrui) или [4] для служб питания."
    set "S_LIN_OK=РЕЖИМ LINUX ВКЛЮЧЁН - нужна перезагрузка."
    set "S_LIN_OK2=Windows теперь выглядит просто, но работает максимально легко."
    set "S_V_AN=Анимации"
    set "S_V_T=Прозрачность"
    set "S_B10T=╪ ¤ з ў-? Microsoft"
    set "S_B10H="Їа ў<?-Ё?: "ЁбЇ?вз?а  ¤ з"
    set "S_A_TITLE=ВИЗУАЛЬНЫЕ ЭФФЕКТЫ"
    set "S_A1=Прозрачность эффектов"
    set "S_A2=Прозрачность панели задач"
    set "S_A3=Отключить анимации"
    set "S_A_ON=Включено"
    set "S_A_OFF=Выключено"
    set "S_A_DONE=Визуальные эффекты применены"
    set "S_KILL=Убить процесс по имени (0 = назад)"
    set "S_KILLED=Процесс убит"
    set "S_NOTFOUND=Процесс не найден"
    set "S_BG=Фоновые процессы (RAM):"
)

if /i "%ACT%"=="/cleanup" goto cleanup
if /i "%ACT%"=="/calm" goto calm
if /i "%ACT%"=="/deep" goto deep
if /i "%ACT%"=="/restore" goto restore
if /i "%ACT%"=="/turbo" goto turbo
if /i "%ACT%"=="/info" goto info
if /i "%ACT%"=="/temps" goto temps
if /i "%ACT%"=="/antirat" goto antirat
if /i "%ACT%"=="/miner" goto miner
if /i "%ACT%"=="/adv" goto adv
if /i "%ACT%"=="/linux" goto linux
if /i "%ACT%"=="/net" goto net
if /i "%ACT%"=="/strange" goto strange
if /i "%ACT%"=="/visual" goto visual
goto menu

:lang
cls
color 07
echo.
echo   SourceClean
echo.
echo    [R]  Русский
echo    [E]  English
echo.
set "L="
set /p L="   Enter = Русский > "
if /i "%L%"=="E" set "L=E"
if /i "%L%"=="R" set "L=R"
if not defined L set "L=R"
if /i not "%L%"=="E" if /i not "%L%"=="R" goto lang
goto strings

:menu
cls
color 07
set "S_STATE=%S_OFF%"
if exist "%FLAG%" set "S_STATE=%S_ON%"
echo.
echo   SourceClean
echo   %S_STATUS%: %S_STATE%
echo.
echo    [1]  %S_M1%
echo    [2]  %S_M2%
echo    [3]  %S_M3%
echo    [4]  %S_M4%
echo    [5]  %S_M5%
echo    [6]  %S_M6%
echo    [7]  %S_M7%
echo    [8]  %S_M8%
echo    [9]  %S_M9%
echo    [A]  %S_MA%
echo    [B]  %S_MB%
echo    [C]  %S_MC%
echo    [D]  %S_MD%
echo    [0]  %S_M0%
echo.
echo    %S_DON% UQAv-7oVunTisIQFtMY0z7qKRyZ_Gy0VZvT6VT1zOxNQQtl_
set "choice="
set /p choice="   %S_CHOOSE% > "
if /i "%choice%"=="1" goto cleanup
if /i "%choice%"=="2" goto calm
if /i "%choice%"=="3" goto deep
if /i "%choice%"=="4" goto restore
if /i "%choice%"=="5" goto turbo
if /i "%choice%"=="6" goto info
if /i "%choice%"=="7" goto temps
if /i "%choice%"=="8" goto antirat
if /i "%choice%"=="9" goto miner
if /i "%choice%"=="A" goto visual
if /i "%choice%"=="B" goto adv
if /i "%choice%"=="C" goto linux
if /i "%choice%"=="D" goto net
if "%choice%"=="0" exit /b
goto menu

:cleanup
cls
color 07
echo.
echo   %S_C1_TITLE%
echo.
echo    -  %S_C1A%
echo    -  %S_C1B%
echo    -  %S_C1C%
echo    -  %S_C1D%
echo.
for /f "delims=" %%s in ('powershell -NoProfile -Command "$t=0;foreach($p in @($env:TEMP,('C:\Windows\Temp'),('C:\Windows\SoftwareDistribution\Download'),($env:LOCALAPPDATA+'\Microsoft\Windows\Explorer'),($env:LOCALAPPDATA+'\CrashDumps'))){if(Test-Path $p){$t+=(Get-ChildItem $p -Recurse -Force -EA 0|Measure-Object Length -Sum).Sum}};'{0:N1} GB' -f ($t/1GB)"') do set "WILLFREE=%%s"
echo    %S_WILLFREE% ~!WILLFREE!
echo.
set "conf1="
set /p conf1="   %S_C1Q% > "
if /i not "!conf1!"=="y" goto menu
call :restorepoint
if "%RP_ABORT%"=="1" goto menu
for /f %%f in ('powershell -NoProfile -Command "[int64](Get-PSDrive C).Free"') do set "FREESTART=%%f"
call :log "cleanup started"

echo.
echo    [1/4] msedge.exe...
taskkill /f /im msedge.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo    [2/4] Edge setup...
reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdateDev" /v AllowUninstall /t REG_DWORD /d 1 /f >nul
for /f "delims=" %%i in ('dir /b /s "C:\Program Files (x86)\Microsoft\Edge\Application\setup.exe" 2^>nul') do "%%i" --uninstall --system-level --force-uninstall >nul 2>&1
timeout /t 3 /nobreak >nul

echo    [3/4] Edge leftovers...
call :nuke "C:\Program Files (x86)\Microsoft\Edge"
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f >nul 2>&1

echo    [4/4] junk files...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q "%TEMP%\*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
rd /s /q "C:\Windows\SoftwareDistribution\Download" >nul 2>&1
md "C:\Windows\SoftwareDistribution\Download" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
del /f /s /q "%LOCALAPPDATA%\CrashDumps\*" >nul 2>&1
ipconfig /flushdns >nul 2>&1

echo.
set "conf2="
set /p conf2="   %S_RECYCLEQ% > "
if /i "!conf2!"=="y" (
    rd /s /q "C:\$Recycle.Bin" >nul 2>&1
    echo    %S_RECYCLED%
    call :log "recycle bin emptied"
) else (
    echo    %S_RECYCLEK%
)

set "FREED="
for /f "delims=" %%f in ('powershell -NoProfile -Command "'{0:N1} GB' -f (((Get-PSDrive C).Free-%FREESTART%)/1GB)"') do set "FREED=%%f"
call :log "cleanup finished, freed %FREED%"
echo.
echo   %S_C1_DONE%
echo   %S_FREED% %FREED%
echo   %S_C1_NOTE% %S_C1_NOTE2%
echo.
pause
goto menu

:calm
cls
color 07
echo.
echo   %S_C2_TITLE%
echo.
echo    -  %S_C2A%
echo    -  %S_C2B%
echo    -  %S_C2C% %S_C2C2%
echo.
set "cp="
if exist "%FLAG%" (
    echo    %S_ALREADY%
    echo    %S_ALREADY2%
    echo.
    set /p cp="   %S_REAPPLYQ% > "
    if /i not "!cp!"=="y" goto menu
    call :loadcfg
    goto calm_apply
)
set /p cp="   %S_ENABLEQ% > "
if /i not "!cp!"=="y" goto menu
call :restorepoint
if "%RP_ABORT%"=="1" goto menu

echo.
echo    %SAVING%
if exist "%CFG%" del "%CFG%" >nul 2>&1
if exist "%TASKS%" del "%TASKS%" >nul 2>&1
powershell -NoProfile -Command "$c='HKLM:\SYSTEM\CurrentControlSet\Services';$s1=[int](Get-ItemProperty ($c+'\SysMain') -Name Start -EA 0).Start;$d1=[int](Get-ItemProperty ($c+'\SysMain') -Name DelayedAutostart -EA 0).DelayedAutostart;$s2=[int](Get-ItemProperty ($c+'\WSearch') -Name Start -EA 0).Start;$d2=[int](Get-ItemProperty ($c+'\WSearch') -Name DelayedAutostart -EA 0).DelayedAutostart;$gr=(Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name GlobalUserDisabled -EA 0);$vr=(Get-ItemProperty 'HKCU:\System\GameConfigStore' -Name GameDVR_Enabled -EA 0);$rr=(Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name AppCaptureEnabled -EA 0);$sc=([regex]::Matches((powercfg /getactivescheme|Out-String),'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}')[0].Value);$mx=[regex]::Matches((powercfg /q SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX|Out-String),'0x[0-9a-fA-F]{8}');$mn=[regex]::Matches((powercfg /q SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN|Out-String),'0x[0-9a-fA-F]{8}');('Scheme={0}' -f $sc);('SysMainStart={0}' -f $s1);('SysMainDelayed={0}' -f $d1);('WSearchStart={0}' -f $s2);('WSearchDelayed={0}' -f $d2);if($null -eq $gr.GlobalUserDisabled){'GlobalUserDisabled=ABSENT'}else{('GlobalUserDisabled={0}' -f [int]$gr.GlobalUserDisabled)};if($null -eq $vr.GameDVR_Enabled){'GameDVR_Enabled=ABSENT'}else{('GameDVR_Enabled={0}' -f [int]$vr.GameDVR_Enabled)};if($null -eq $rr.AppCaptureEnabled){'AppCaptureEnabled=ABSENT'}else{('AppCaptureEnabled={0}' -f [int]$rr.AppCaptureEnabled)};('ThrottleMaxAC={0}' -f [convert]::ToInt32($mx[$mx.Count-2].Value,16));('ThrottleMaxDC={0}' -f [convert]::ToInt32($mx[$mx.Count-1].Value,16));('ThrottleMinAC={0}' -f [convert]::ToInt32($mn[$mn.Count-2].Value,16));('ThrottleMinDC={0}' -f [convert]::ToInt32($mn[$mn.Count-1].Value,16))" > "%CFG%" 2>nul
call :checkcfg
if "%CFG_OK%"=="0" (
    del "%CFG%" >nul 2>&1
    echo    %S_SAVEFAIL%
    echo    %S_SAVEFAIL2%
    set "cp="
    set /p cp="   %S_CONTINUEQ% > "
    if /i not "!cp!"=="y" goto menu
    set "CALMSCHEME=SCHEME_CURRENT"
) else (
    echo    %SAVED%  %CFG%
    call :loadcfg
)

echo    %S_BACKUP% %BAK%
if not exist "%BAK%" md "%BAK%" >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "%BAK%\bgapps.reg" /y >nul 2>&1
reg export "HKCU\System\GameConfigStore" "%BAK%\gamedvr.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" "%BAK%\gamedvr2.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Services\SysMain" "%BAK%\sysmain.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Services\WSearch" "%BAK%\wsearch.reg" /y >nul 2>&1

for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-ScheduledTask -EA SilentlyContinue | Where-Object { $_.TaskName -like 'NVIDIA App SelfUpdate*' -and $_.State -ne 'Disabled' } | ForEach-Object { $_.TaskPath + $_.TaskName }"') do echo %%t>>"%TASKS%"
powershell -NoProfile -Command "$f='%TASKS%';if(Test-Path $f){$ok=Get-Content $f|Where-Object {$_ -match '^[A-Za-z0-9_{}\\ .-]+$'};Set-Content $f $ok -Encoding ASCII}"

:calm_apply
echo ON>"%FLAG%"
call :log "calm mode ON"

echo.
echo    [1/6] %S_STEP1%
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1

echo    [2/6] %S_STEP2%
sc stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1

echo    [3/6] %S_STEP3%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul

echo    [4/6] %S_STEP4%
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul

echo    [5/6] %S_STEP5%
powercfg /setacvalueindex !CALMSCHEME! SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
powercfg /setacvalueindex !CALMSCHEME! SUB_PROCESSOR PROCTHROTTLEMAX 99 >nul 2>&1
powercfg /setdcvalueindex !CALMSCHEME! SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
powercfg /setdcvalueindex !CALMSCHEME! SUB_PROCESSOR PROCTHROTTLEMAX 99 >nul 2>&1
powercfg /setactive !CALMSCHEME! >nul 2>&1
if errorlevel 1 echo        %S_SCHEMEWARN% !CALMSCHEME!

echo    [6/6] %S_STEP6%
taskkill /f /im "NVIDIA Overlay.exe" >nul 2>&1
if exist "%TASKS%" (
    for /f "usebackq delims=" %%t in ("%TASKS%") do schtasks /Change /TN %%t /DISABLE >nul 2>&1
)

echo.
echo   %S_C2_DONE%
echo   %S_C2_NOTE%
echo   %S_C2_NOTE2%
echo.
pause
goto menu

:deep
cls
color 07
echo.
echo   %S_D_TITLE%
echo   %S_D_NOTE%
echo.
echo    [1]  [!D1!]  %S_D1%
echo    [2]  [!D2!]  %S_D2%
echo    [3]  [!D3!]  %S_D3%
echo    [4]  [!D4!]  %S_D4%
echo    [5]  [!D5!]  %S_D5%
echo    [6]  [!D6!]  %S_D6%
echo    [7]  [!D7!]  %S_D7%
echo    [8]  [!D8!]  %S_D8%
echo.
echo    %S_D_HINT%
echo.
set "din="
set /p din="   %S_CHOOSE% > "
if /i "%din%"=="m" goto menu
if "%din%"=="0" goto deep_apply
if /i "%din%"=="a" (
    set "D1=1" & set "D2=1" & set "D3=1" & set "D4=1" & set "D5=1" & set "D6=1" & set "D7=1"
    goto deep
)
if "%din%"=="1" if "!D1!"=="1" (set "D1=0") else (set "D1=1")
if "%din%"=="2" if "!D2!"=="1" (set "D2=0") else (set "D2=1")
if "%din%"=="3" if "!D3!"=="1" (set "D3=0") else (set "D3=1")
if "%din%"=="4" if "!D4!"=="1" (set "D4=0") else (set "D4=1")
if "%din%"=="5" if "!D5!"=="1" (set "D5=0") else (set "D5=1")
if "%din%"=="6" if "!D6!"=="1" (set "D6=0") else (set "D6=1")
if "%din%"=="7" if "!D7!"=="1" (set "D7=0") else (set "D7=1")
if "%din%"=="8" if "!D8!"=="1" (set "D8=0") else (set "D8=1")
goto deep

:deep_apply
set "DSEL="
if "!D1!"=="1" set "DSEL=1"
if "!D2!"=="1" set "DSEL=!DSEL!2"
if "!D3!"=="1" set "DSEL=!DSEL!3"
if "!D4!"=="1" set "DSEL=!DSEL!4"
if "!D5!"=="1" set "DSEL=!DSEL!5"
if "!D6!"=="1" set "DSEL=!DSEL!6"
if "!D7!"=="1" set "DSEL=!DSEL!7"
if "!D8!"=="1" set "DSEL=!DSEL!8"
if not defined DSEL (
    echo    %S_D_NONE%
    timeout /t 2 /nobreak >nul
    goto deep
)
echo.
set "dconf="
set /p dconf="   %S_D_APPLY% > "
if /i not "!dconf!"=="y" goto deep

if "!D1!"=="1" (
    echo    [1] !S_D1!...
    sc stop DiagTrack >nul 2>&1
    sc config DiagTrack start= disabled >nul 2>&1
    sc stop dmwappushservice >nul 2>&1
    sc config dmwappushservice start= disabled >nul 2>&1
)
if "!D2!"=="1" (
    echo    [2] !S_D2!...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v IsDynamicSearchBoxEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1
)
if "!D3!"=="1" (
    echo    [3] !S_D3!...
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    taskkill /f /im XboxGameBar.exe >nul 2>&1
)
if "!D4!"=="1" (
    echo    [4] !S_D4!...
    for /f "delims=" %%l in ('powershell -NoProfile -Command "$r=@();if(-not (Get-Process firefox -EA 0)){foreach($p in (Get-Item ($env:LOCALAPPDATA+'\Mozilla\Firefox\Profiles\*\cache2') -EA 0)){$s=0;foreach($x in (Get-ChildItem $p.FullName -Recurse -Force -EA 0)){$s+=$x.Length};Remove-Item ($p.FullName+'\*') -Recurse -Force -EA 0;if($s){$r+=('{0:N0} MB Firefox' -f ($s/1MB))}}};if(-not (Get-Process chrome -EA 0)){foreach($p in (Get-Item ($env:LOCALAPPDATA+'\Google\Chrome\User Data\*\Cache') -EA 0)){$s=0;foreach($x in (Get-ChildItem $p.FullName -Recurse -Force -EA 0)){$s+=$x.Length};Remove-Item ($p.FullName+'\*') -Recurse -Force -EA 0;if($s){$r+=('{0:N0} MB Chrome' -f ($s/1MB))}}};if($r.Count -eq 0){'0 MB'}else{$r}"') do echo        %%l
)
if "!D5!"=="1" (
    echo    [5] !S_D5!...
    del /f /q "C:\Windows\Prefetch\*.pf" >nul 2>&1
)
if "!D6!"=="1" (
    echo    [6] !S_D6!...
    for /f "delims=" %%l in ('powershell -NoProfile -Command "$v=Get-CimInstance Win32_ShadowCopy -EA 0;while(@($v).Count -gt 1){$o=@($v)[0];foreach($x in @($v)){if($x.InstallDate -lt $o.InstallDate){$o=$x}};Remove-CimInstance -InputObject $o -EA 0;$v=Get-CimInstance Win32_ShadowCopy -EA 0};'left: '+@($v).Count"') do echo        %%l
)
if "!D7!"=="1" (
    echo    [7] !S_D7!...
    wevtutil cl System >nul 2>&1
    wevtutil cl Application >nul 2>&1
    wevtutil cl Setup >nul 2>&1
)
if "!D8!"=="1" (
    echo    [8] !S_D8!...
    powershell -NoProfile -Command "Get-AppxPackage -AllUsers Microsoft.XboxGamingOverlay | Remove-AppxPackage -AllUsers; Get-AppxPackage -AllUsers Microsoft.XboxGameOverlay | Remove-AppxPackage -AllUsers" >nul 2>&1
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f >nul 2>&1
    for %%u in (ms-gamingoverlay ms-gamebar ms-gamebarservices) do (
        reg add "HKCR\%%u" /ve /d "URL:%%u" /f >nul 2>&1
        reg add "HKCR\%%u" /v "URL Protocol" /d "" /f >nul 2>&1
        reg add "HKCR\%%u\shell\open\command" /ve /d "rundll32.exe" /f >nul 2>&1
    )
)
call :log "deep-tune applied: %DSEL%"
echo.
echo   %SAVED%
echo.
pause
goto menu

:restore
cls
color 07
echo.
if not exist "%CFG%" goto restore_defaults
echo   %S_REST_FOUND%
call :loadcfg
set "RSSCHEME=!CALMSCHEME!"
powercfg /query !RSSCHEME! >nul 2>&1
if errorlevel 1 (
    echo   %S_SCHEMEGONE%
    set "RSSCHEME=SCHEME_CURRENT"
)

set "SS=auto"
if "!S_SysMainStart!"=="3" set "SS=demand"
if "!S_SysMainStart!"=="4" set "SS=disabled"
if "!S_SysMainStart!"=="2" if "!S_SysMainDelayed!"=="1" set "SS=delayed-auto"
sc config SysMain start= !SS! >nul 2>&1
if not "!SS!"=="disabled" sc start SysMain >nul 2>&1

set "WS=auto"
if "!S_WSearchStart!"=="3" set "WS=demand"
if "!S_WSearchStart!"=="4" set "WS=disabled"
if "!S_WSearchStart!"=="2" if "!S_WSearchDelayed!"=="1" set "WS=delayed-auto"
sc config WSearch start= !WS! >nul 2>&1
if not "!WS!"=="disabled" sc start WSearch >nul 2>&1

if "!S_GlobalUserDisabled!"=="ABSENT" (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /f >nul 2>&1
) else (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d !S_GlobalUserDisabled! /f >nul 2>&1
)
if "!S_GameDVR_Enabled!"=="ABSENT" (
    reg delete "HKCU\System\GameConfigStore" /v GameDVR_Enabled /f >nul 2>&1
) else (
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d !S_GameDVR_Enabled! /f >nul 2>&1
)
if "!S_AppCaptureEnabled!"=="ABSENT" (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /f >nul 2>&1
) else (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d !S_AppCaptureEnabled! /f >nul 2>&1
)

powercfg /setacvalueindex !RSSCHEME! SUB_PROCESSOR PROCTHROTTLEMIN !S_ThrottleMinAC! >nul 2>&1
powercfg /setacvalueindex !RSSCHEME! SUB_PROCESSOR PROCTHROTTLEMAX !S_ThrottleMaxAC! >nul 2>&1
powercfg /setdcvalueindex !RSSCHEME! SUB_PROCESSOR PROCTHROTTLEMIN !S_ThrottleMinDC! >nul 2>&1
powercfg /setdcvalueindex !RSSCHEME! SUB_PROCESSOR PROCTHROTTLEMAX !S_ThrottleMaxDC! >nul 2>&1
powercfg /setactive !RSSCHEME! >nul 2>&1
if errorlevel 1 echo   %S_SCHEMEWARN% !RSSCHEME!

if exist "%TASKS%" (
    for /f "usebackq delims=" %%t in ("%TASKS%") do schtasks /Change /TN %%t /ENABLE >nul 2>&1
)
del "%CFG%" >nul 2>&1
del "%TASKS%" >nul 2>&1
del "%FLAG%" >nul 2>&1
call :log "calm mode restored"
echo.
echo   %S_REST_DONE%
echo.
pause
goto menu

:restore_defaults
echo   %S_DEF_FOUND%
sc config SysMain start= auto >nul 2>&1
sc start SysMain >nul 2>&1
sc config WSearch start= delayed-auto >nul 2>&1
sc start WSearch >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f >nul
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg /setactive SCHEME_CURRENT >nul 2>&1
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-ScheduledTask -EA SilentlyContinue | Where-Object { $_.TaskName -like 'NVIDIA App SelfUpdate*' } | ForEach-Object { $_.TaskPath + $_.TaskName }"') do schtasks /Change /TN %%t /ENABLE >nul 2>&1
del "%TASKS%" >nul 2>&1
del "%FLAG%" >nul 2>&1
call :log "defaults restored"
echo.
echo   %S_DEF_DONE%
echo.
pause
goto menu

:turbo
cls
color 07
echo.
echo   %S_M5%
echo.
for /f "delims=" %%r in ('powershell -NoProfile -Command "$m=[regex]::Matches((powercfg /q SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX|Out-String),'0x[0-9a-fA-F]{8}');$cur=[convert]::ToInt32($m[$m.Count-2].Value,16);if($cur -gt 99){powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99;powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99;powercfg /setactive SCHEME_CURRENT;'TURBO_OFF'}else{powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100;powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100;powercfg /setactive SCHEME_CURRENT;'TURBO_ON'}"') do set "TRES=%%r"
if "!TRES!"=="TURBO_OFF" (
    echo   %S_T_OFF%
    call :log "turbo off"
) else (
    echo   %S_T_ON%
    call :log "turbo on"
)
echo.
pause
goto menu

:info
cls
color 07
echo.
echo   %S_INFO_TITLE%
echo.
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem;$d=Get-CimInstance Win32_LogicalDisk -Filter \"DeviceID='C:'\";$up=(Get-Date)-$os.LastBootUpTime;('RAM: {0:N1} / {1:N1} GB used' -f (($os.TotalVisibleMemorySize-$os.FreePhysicalMemory)/1MB),($os.TotalVisibleMemorySize/1MB));('Disk C: {0:N1} GB free of {1:N1} GB' -f ($d.FreeSpace/1GB),($d.Size/1GB));('Uptime: {0} d {1} h {2} m' -f $up.Days,$up.Hours,$up.Minutes)"
echo.
echo   %S_BG%   (%S_SYS% / %S_APP%)
powershell -NoProfile -Command "$sys=@('system','registry','smss','csrss','wininit','winlogon','services','lsass','svchost','msmpeng','nissrv','memory compression','memcompression','dwm','explorer','runtimebroker','fontdrvhost','audiodg','spoolsv','conhost','dllhost','taskhostw','sihost','textinputhost','startmenuexperiencehost','searchhost','shellexperiencehost','securityhealthservice','nvcontainer','applicationframehost','wudfhost','wmiprvse','searchindexer','smartscreen');Get-Process|Group-Object ProcessName|ForEach-Object{[PSCustomObject]@{n=$_.Name;m=[math]::Round(($_.Group|Measure-Object WorkingSet64 -Sum).Sum/1MB,0)}}|Sort-Object m -Descending|Select-Object -First 12|ForEach-Object{$isS=($sys -contains $_.n.ToLower());if(-not $isS){$gp=Get-Process -Name $_.n -EA 0|Select-Object -First 1;if($gp.Path -and $gp.Path.StartsWith('C:\Windows\')){$isS=$true}};if($isS){$t=if($env:L -eq 'E'){'[SYS] '}else{'[SYS] '}}else{$t=if($env:L -eq 'E'){'[APP] '}else{'[APP] '}};('{0}{1,-25} {2,6} MB' -f $t,$_.n,$_.m)}"
echo.
:info_kill
set "killname="
set /p killname="   %S_KILL% > "
if "%killname%"=="0" goto menu
if "%killname%"=="" goto info_kill
set "KN=%killname%"
for /f "delims=" %%v in ('powershell -NoProfile -Command "if($env:KN -match ''^[A-Za-z0-9._-]+$''){''OK''}else{''BAD''}"') do set "KVAL=%%v"
if not "%KVAL%"=="OK" (
    echo    %S_INVBAD%
    call :log "kill refused: invalid name"
    goto info_kill
)
for /f "delims=" %%v in ('powershell -NoProfile -Command "$n=$env:KN -replace ''\.exe$'','''';$sys=@(''system'',''registry'',''smss'',''csrss'',''wininit'',''winlogon'',''services'',''lsass'',''svchost'',''msmpeng'',''nissrv'',''memory compression'',''memcompression'',''dwm'',''explorer'',''runtimebroker'',''fontdrvhost'',''audiodg'',''spoolsv'',''conhost'',''dllhost'',''taskhostw'',''sihost'',''textinputhost'',''startmenuexperiencehost'',''searchhost'',''shellexperiencehost'',''securityhealthservice'',''nvcontainer'',''applicationframehost'',''wudfhost'',''wmiprvse'',''searchindexer'',''smartscreen'');$ok=$true;if($sys -contains $n){$ok=$false}else{$gp=Get-Process -Name $n -EA 0|Select-Object -First 1;if($gp.Path -and $gp.Path.StartsWith(''C:\Windows\'')){$ok=$false}};if($ok){''KILL_OK''}else{''PROTECTED''}"') do set "KCHK=%%v"
if "%KCHK%"=="PROTECTED" (
    echo    %S_PROT%
    call :log "kill refused: %killname% is a system process"
    goto info_kill
)
taskkill /f /im "%killname%.exe" >nul 2>&1
if errorlevel 1 (
    taskkill /f /im "%killname%" >nul 2>&1
    if errorlevel 1 (
        echo    %S_NOTFOUND%
    ) else (
        echo    %S_KILLED%: %killname%
        call :log "killed process %killname%"
    )
) else (
    echo    %S_KILLED%: %killname%.exe
    call :log "killed process %killname%.exe"
)
echo.
goto info_kill

:temps
cls
color 07
echo.
echo   %S_TEMP_TITLE%
echo.
where nvidia-smi >nul 2>&1
if %errorlevel%==0 (
    nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,fan.speed --format=csv,noheader 2>nul
) else (
    echo   %S_NOGPU%
)
powershell -NoProfile -Command "Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue | ForEach-Object { 'CPU zone [{0}]: {1:N1} C' -f $_.InstanceName, (($_.CurrentTemperature/10)-273.15) };foreach($ns in 'root\LibreHardwareMonitor','root\OpenHardwareMonitor'){try{$s=Get-CimInstance -Namespace $ns -ClassName Sensor -EA Stop|Where-Object{$_.SensorType -eq 'Temperature' -and $_.Name -match 'CPU'}|Measure-Object -Property Value -Maximum;if($s.Maximum){('CPU (LHM): {0:N1} C' -f $s.Maximum)}}catch{}}"
echo.
echo   %S_TEMP1%
echo   %S_TEMP2%
echo.
pause
goto menu

:visual
cls
color 07
echo.
echo   %S_A_TITLE%
echo.
echo    [1]  %S_A1%
echo    [2]  %S_A2%
echo    [3]  %S_A3%
echo    [4]  %S_V_AN% (on/off)
echo    [5]  %S_V_T% off
echo    [6]  %S_VR%
echo    [0]  %S_M0%
echo.
echo    %S_DON% UQAv-7oVunTisIQFtMY0z7qKRyZ_Gy0VZvT6VT1zOxNQQtl_
set "vch="
set /p vch="   %S_CHOOSE% > "
if "%vch%"=="0" goto menu
if "%vch%"=="1" goto vis_trans
if "%vch%"=="2" goto vis_taskbar
if "%vch%"=="3" goto vis_anim
if "%vch%"=="4" goto vis_atog
if "%vch%"=="5" goto vis_toff
if "%vch%"=="6" goto vis_restore
goto visual

:vis_trans
call :vis_save
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f >nul
echo    %S_A1%: %S_A_ON%
call :log "transparency enabled"
echo.
pause
call :askreboot
goto visual

:vis_taskbar
call :vis_save
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAcrylicOpacity /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f >nul
echo    %S_A2%: %S_A_ON%
call :log "taskbar transparency enabled"
echo.
pause
call :askreboot
goto visual

:vis_anim
call :vis_save
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul
echo    %S_A3%: %S_A_ON%
call :log "animations disabled"
echo.
pause
call :askreboot
goto visual

:vis_atog
call :vis_save
for /f %%v in ('powershell -NoProfile -Command "(Get-ItemProperty 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name MinAnimate -EA 0).MinAnimate"') do set "MINAN=%%v"
if "%MINAN%"=="0" (
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 1 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f >nul
    echo    %S_V_AN%: %S_ON%
    call :log "visual: animations on"
) else (
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul
    echo    %S_V_AN%: %S_OFF%
    call :log "visual: animations off"
)
echo.
pause
call :askreboot
goto visual

:vis_toff
call :vis_save
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul
call :log "visual: transparency off"
echo    %S_V_T%: %S_OFF%
echo.
pause
call :askreboot
goto visual

:linux
cls
color 0E
echo.
echo   %S_LIN_T%
echo.
echo    [1]  %S_LIN_M1%
echo    [2]  %S_LIN_M2%
echo    [0]  %S_M0%
echo.
echo    %S_DON% UQAv-7oVunTisIQFtMY0z7qKRyZ_Gy0VZvT6VT1zOxNQQtl_
set "lch="
set /p lch="   %S_CHOOSE% > "
if "%lch%"=="1" goto linux_on
if "%lch%"=="2" goto linuxoff
goto linux

:linuxoff
cls
color 0D
echo.
echo   %S_LIN_OFF%
echo.
if exist "%VCFG%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%VCFG%") do call :vr_apply "%%a" "%%b"
    del "%VCFG%" >nul 2>&1
    echo    %S_VRS%
) else (
    echo    %S_VRN%
)
if exist "%CFG%" (
    call :svc_restore_from_cfg
    if not exist "%FLAG%" del "%CFG%" >nul 2>&1
    echo    %S_LIN_SVC%
) else (
    sc config SysMain start= auto >nul 2>&1
    sc start SysMain >nul 2>&1
    sc config WSearch start= delayed-auto >nul 2>&1
    sc start WSearch >nul 2>&1
    sc config DiagTrack start= auto >nul 2>&1
    net start DiagTrack >nul 2>&1
    sc config DoSvc start= delayed-auto >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul 2>&1
    echo    %S_LIN_DEF%
)
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul 2>&1
call :log "linux mode disabled"
echo    %S_LIN_HIB%
echo.
echo   %S_LIN_OFFOK%
call :askreboot
echo.
pause
goto menu

:svc_restore_from_cfg
call :loadcfg
set "RSSCHEME=!CALMSCHEME!"
powercfg /query !RSSCHEME! >nul 2>&1
if errorlevel 1 set "RSSCHEME=SCHEME_CURRENT"
set "SS=auto"
if "!S_SysMainStart!"=="3" set "SS=demand"
if "!S_SysMainStart!"=="4" set "SS=disabled"
if "!S_SysMainStart!"=="2" if "!S_SysMainDelayed!"=="1" set "SS=delayed-auto"
sc config SysMain start= !SS! >nul 2>&1
if not "!SS!"=="disabled" sc start SysMain >nul 2>&1
set "WS=auto"
if "!S_WSearchStart!"=="3" set "WS=demand"
if "!S_WSearchStart!"=="4" set "WS=disabled"
if "!S_WSearchStart!"=="2" if "!S_WSearchDelayed!"=="1" set "WS=delayed-auto"
sc config WSearch start= !WS! >nul 2>&1
if not "!WS!"=="disabled" sc start WSearch >nul 2>&1
if "!S_GlobalUserDisabled!"=="ABSENT" (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /f >nul 2>&1
) else (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d !S_GlobalUserDisabled! /f >nul 2>&1
)
if "!S_GameDVR_Enabled!"=="ABSENT" (
    reg delete "HKCU\System\GameConfigStore" /v GameDVR_Enabled /f >nul 2>&1
) else (
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d !S_GameDVR_Enabled! /f >nul 2>&1
)
if "!S_AppCaptureEnabled!"=="ABSENT" (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /f >nul 2>&1
) else (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d !S_AppCaptureEnabled! /f >nul 2>&1
)
powercfg /setacvalueindex !RSSCHEME! SUB_PROCESSOR PROCTHROTTLEMIN !S_ThrottleMinAC! >nul 2>&1
powercfg /setacvalueindex !RSSCHEME! SUB_PROCESSOR PROCTHROTTLEMAX !S_ThrottleMaxAC! >nul 2>&1
powercfg /setdcvalueindex !RSSCHEME! SUB_PROCESSOR PROCTHROTTLEMIN !S_ThrottleMinDC! >nul 2>&1
powercfg /setdcvalueindex !RSSCHEME! SUB_PROCESSOR PROCTHROTTLEMAX !S_ThrottleMaxDC! >nul 2>&1
powercfg /setactive !RSSCHEME! >nul 2>&1
exit /b

:linux_on

cls
color 0E
echo.
echo   %S_LIN_T%
echo.
echo    %S_LIN_W1%
echo    %S_LIN_W2%
echo    %S_LIN_W3%
echo.
call :restorepoint
if "%RP_ABORT%"=="1" goto menu
call :vis_save
call :svcsave
echo.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1
sc stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
net stop DoSvc /y >nul 2>&1
sc config DoSvc start= disabled >nul 2>&1
powercfg /hibernate off >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul
taskkill /f /im OneDrive.exe >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f >nul 2>&1
call :log "linux mode applied"
echo.
echo   %S_LIN_OK%
echo   %S_LIN_OK2%
echo.
pause
call :askreboot
goto menu
:antirat
cls
color 07
echo.
echo   %S_AR_TITLE%
echo   %S_AR_HOOKNOTE%
echo.
echo   %S_AR_PHRASE%:
echo.
echo   Жили были два кота и пили чай по утрам
echo.
echo   %S_AR_GO%
pause >nul
call :runblock ARB
call :log "anti-rat check run"
echo.
echo.
pause
goto menu

:miner
cls
color 07
echo.
echo   %S_AM_TITLE%
echo   %S_AM_NOTE%
echo.
call :runblock ARM
call :log "anti-miner idle scan run"
echo.
pause
goto menu


:vis_save
if exist "%VCFG%" exit /b
powershell -NoProfile -Command "$a='HKCU:\Control Panel\Desktop\WindowMetrics';$b='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced';$c='HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize';$d='HKCU:\Software\Microsoft\Windows\DWM';$e='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects';$f='HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications';function G($k,$n){$v=(Get-ItemProperty $k -Name $n -EA 0).$n;if($null -eq $v){'ABSENT'}else{$v}};'MinAnimate='+$(G $a 'MinAnimate');'TaskbarAnimations='+$(G $b 'TaskbarAnimations');'EnableTransparency='+$(G $c 'EnableTransparency');'EnableAeroPeek='+$(G $d 'EnableAeroPeek');'ListviewAlphaSelect='+$(G $b 'ListviewAlphaSelect');'IconsOnly='+$(G $b 'IconsOnly');'VisualFXSetting='+$(G $e 'VisualFXSetting');'ToastEnabled='+$(G $f 'ToastEnabled')" > "%VCFG%" 2>nul
exit /b

:vis_restore
if not exist "%VCFG%" (
    echo    %S_VRN%
    echo.
    pause
    goto visual
)
for /f "usebackq tokens=1,* delims==" %%a in ("%VCFG%") do call :vr_apply "%%a" "%%b"
del "%VCFG%" >nul 2>&1
call :log "visual: restored saved state"
echo    %S_VRS%
call :askreboot
echo.
pause
goto visual

:vr_apply
set "VKEY=%~1"
set "VVAL=%~2"
if "%VKEY%"=="" exit /b
echo %VKEY%|findstr /r /x "MinAnimate TaskbarAnimations EnableTransparency EnableAeroPeek ListviewAlphaSelect IconsOnly VisualFXSetting ToastEnabled" >nul 2>&1
if errorlevel 1 exit /b
if "%VVAL%"=="ABSENT" (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v %VKEY% /f >nul 2>&1
    reg delete "HKCU\Control Panel\Desktop\WindowMetrics" /v %VKEY% /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v %VKEY% /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\DWM" /v %VKEY% /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v %VKEY% /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v %VKEY% /f >nul 2>&1
    exit /b
)
echo %VVAL%|findstr /r /x "[0-9][0-9]*" >nul 2>&1
if errorlevel 1 exit /b
if "%VKEY%"=="MinAnimate" (
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d %VVAL% /f >nul
    exit /b
)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v %VKEY% /t REG_DWORD /d %VVAL% /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v %VKEY% /t REG_DWORD /d %VVAL% /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v %VKEY% /t REG_DWORD /d %VVAL% /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v %VKEY% /t REG_DWORD /d %VVAL% /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v %VKEY% /t REG_DWORD /d %VVAL% /f >nul 2>&1
exit /b

:svcsave
if exist "%CFG%" exit /b
if exist "%FLAG%" exit /b
powershell -NoProfile -Command "$c='HKLM:\SYSTEM\CurrentControlSet\Services';$s1=[int](Get-ItemProperty ($c+'\SysMain') -Name Start -EA 0).Start;$d1=[int](Get-ItemProperty ($c+'\SysMain') -Name DelayedAutostart -EA 0).DelayedAutostart;$s2=[int](Get-ItemProperty ($c+'\WSearch') -Name Start -EA 0).Start;$d2=[int](Get-ItemProperty ($c+'\WSearch') -Name DelayedAutostart -EA 0).DelayedAutostart;$g=[int](Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name GlobalUserDisabled -EA 0).GlobalUserDisabled;$v=[int](Get-ItemProperty 'HKCU:\System\GameConfigStore' -Name GameDVR_Enabled -EA 0).GameDVR_Enabled;$r=[int](Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name AppCaptureEnabled -EA 0).AppCaptureEnabled;$sc=([regex]::Matches((powercfg /getactivescheme|Out-String),'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}')[0].Value);$mx=[regex]::Matches((powercfg /q SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX|Out-String),'0x[0-9a-fA-F]{8}');$mn=[regex]::Matches((powercfg /q SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN|Out-String),'0x[0-9a-fA-F]{8}');('Scheme={0}' -f $sc);('SysMainStart={0}' -f $s1);('SysMainDelayed={0}' -f $d1);('WSearchStart={0}' -f $s2);('WSearchDelayed={0}' -f $d2);('GlobalUserDisabled={0}' -f $g);('GameDVR_Enabled={0}' -f $v);('AppCaptureEnabled={0}' -f $r);('ThrottleMaxAC={0}' -f [convert]::ToInt32($mx[$mx.Count-2].Value,16));('ThrottleMaxDC={0}' -f [convert]::ToInt32($mx[$mx.Count-1].Value,16));('ThrottleMinAC={0}' -f [convert]::ToInt32($mn[$mn.Count-2].Value,16));('ThrottleMinDC={0}' -f [convert]::ToInt32($mn[$mn.Count-1].Value,16))" > "%CFG%" 2>nul
call :log "linux mode: service state saved for [4] restore"
exit /b

:askreboot
set "rb="
set /p rb="   %S_RB% > "
if /i "%rb%"=="y" shutdown /r /t 5 /c "SourceClean"
exit /b

:net
cls
color 07
echo.
echo   %S_MD%
echo.
echo   %S_N1%
powershell -NoProfile -Command "$ip=Get-NetIPConfiguration -EA 0|Where-Object {$_.IPv4DefaultGateway};foreach($i in $ip){('  IP: ' + $i.IPv4Address.IPAddress + '   GW: ' + $i.IPv4DefaultGateway.NextHop + '   DNS: ' + (($i.DNSServer | Select-Object -First 2 | ForEach-Object {$_.ServerAddresses}) -join ', '))}"
echo.
echo   %S_N2%
powershell -NoProfile -Command "$n=Get-NetNeighbor -EA 0|Where-Object {$_.State -in 'Reachable','Stale','Permanent' -and $_.IPAddress -match '^192\.168\.|^10\.|^172\.(1[6-9]|2[0-9]|3[01])\.' -and $_.IPAddress -notmatch '^169\.254'};if($n){$n|Sort-Object IPAddress -Unique|ForEach-Object{('  '+$_.IPAddress+'   '+$_.LinkLayerAddress)};('  total: '+@($n|Sort-Object IPAddress -Unique).Count)}else{'  (none yet - open a couple of sites and run again)'}"
echo.
echo   %S_N3%
powershell -NoProfile -Command "$c=Get-NetTCPConnection -State Established -EA 0|Where-Object {$_.RemoteAddress -notmatch '^127\.|^::1|^10\.|^192\.168\.|^172\.(1[6-9]|2[0-9]|3[01])\.|^::'}|Sort-Object OwningProcess -Unique|Select-Object -First 12;if($c){foreach($x in $c){$p=Get-Process -Id $x.OwningProcess -EA 0;('  '+$x.RemoteAddress+':'+$x.RemotePort+'  <-  '+$p.Name)}}else{'  (none)'}"
echo.
echo   %S_N4%
powershell -NoProfile -Command "$a=Get-WmiObject Win32_PerfFormattedData_PerfProc_Process -EA 0|Where-Object {$_.Name -notin '_Total','Idle'}|Select-Object IDProcess,Name,IODataBytesPersec;Start-Sleep -Seconds 10;$b=Get-WmiObject Win32_PerfFormattedData_PerfProc_Process -EA 0|Where-Object {$_.Name -notin '_Total','Idle'};$r=@{};foreach($x in $b){$o=$a|Where-Object {$_.IDProcess -eq $x.IDProcess};if($o){$d=$x.IODataBytesPersec-$o.IODataBytesPersec;if($d -gt 0){if(-not $r.ContainsKey($x.Name)){$r[$x.Name]=0};$r[$x.Name]+=[math]::Round($d/5,0)}}};if($r.Count -eq 0){'  (no measurable activity)'}else{$r.GetEnumerator()|Sort-Object Value -Descending|Select-Object -First 8|ForEach-Object{('  {0,-28} {1,8} KB/s' -f $_.Key,[math]::Round($_.Value/1KB,0))}}"
echo.
echo   %S_N6%
powershell -NoProfile -Command "Get-NetAdapterStatistics -EA 0|Where-Object {$_.ReceivedBytes -gt 0 -or $_.SentBytes -gt 0}|Sort-Object {$_.ReceivedBytes+$_.SentBytes} -Descending|Select-Object -First 3|ForEach-Object{('  {0,-20} in {1:N1} GB   out {2:N1} GB' -f $_.Name,($_.ReceivedBytes/1GB),($_.SentBytes/1GB))}"
echo.
echo   %S_N5%
echo.
pause
goto menu
::ARB JGxhbmcgPSBpZiAoJGVudjpTQ0xBTkcgLWVxICdFJykgeyAnRScgfSBlbHNlIHsgJ1InIH0KZnVuY3Rpb24gVCgkZW4sICRydSkg
::ARB eyBpZiAoJGxhbmcgLWVxICdFJykgeyAkZW4gfSBlbHNlIHsgJHJ1IH0gfQokY3MgPSBAJwp1c2luZyBTeXN0ZW07CnVzaW5nIFN5
::ARB c3RlbS5SdW50aW1lLkludGVyb3BTZXJ2aWNlczsKdXNpbmcgU3lzdGVtLlRleHQ7CnVzaW5nIFN5c3RlbS5UaHJlYWRpbmc7CnVz
::ARB aW5nIFN5c3RlbS5XaW5kb3dzLkZvcm1zOwpwdWJsaWMgY2xhc3MgS0wgewogIFtTdHJ1Y3RMYXlvdXQoTGF5b3V0S2luZC5TZXF1
::ARB ZW50aWFsKV0gcHVibGljIHN0cnVjdCBLQkRMTCB7IHB1YmxpYyB1aW50IHZrOyBwdWJsaWMgdWludCBzY2FuOyBwdWJsaWMgdWlu
::ARB dCBmbGFnczsgcHVibGljIHVpbnQgdGltZTsgcHVibGljIEludFB0ciBleHRyYTsgfQogIHB1YmxpYyBkZWxlZ2F0ZSBJbnRQdHIg
::ARB SFAoaW50IG4sIEludFB0ciB3LCBJbnRQdHIgbCk7CiAgW0RsbEltcG9ydCgidXNlcjMyLmRsbCIpXSBwdWJsaWMgc3RhdGljIGV4
::ARB dGVybiBJbnRQdHIgU2V0V2luZG93c0hvb2tFeChpbnQgaWQsIEhQIHAsIEludFB0ciBtLCB1aW50IHQpOwogIFtEbGxJbXBvcnQo
::ARB InVzZXIzMi5kbGwiKV0gcHVibGljIHN0YXRpYyBleHRlcm4gYm9vbCBVbmhvb2tXaW5kb3dzSG9va0V4KEludFB0ciBoKTsKICBb
::ARB RGxsSW1wb3J0KCJ1c2VyMzIuZGxsIildIHB1YmxpYyBzdGF0aWMgZXh0ZXJuIEludFB0ciBDYWxsTmV4dEhvb2tFeChJbnRQdHIg
::ARB aCwgaW50IG4sIEludFB0ciB3LCBJbnRQdHIgbCk7CiAgW0RsbEltcG9ydCgia2VybmVsMzIuZGxsIildIHB1YmxpYyBzdGF0aWMg
::ARB ZXh0ZXJuIEludFB0ciBHZXRNb2R1bGVIYW5kbGUoc3RyaW5nIHMpOwogIFtEbGxJbXBvcnQoInVzZXIzMi5kbGwiKV0gcHVibGlj
::ARB IHN0YXRpYyBleHRlcm4gaW50IFRvVW5pY29kZUV4KHVpbnQgdmssIHVpbnQgc2MsIGJ5dGVbXSBrcywgU3RyaW5nQnVpbGRlciBi
::ARB LCBpbnQgc3osIHVpbnQgZiwgSW50UHRyIGhrbCk7CiAgW0RsbEltcG9ydCgidXNlcjMyLmRsbCIpXSBwdWJsaWMgc3RhdGljIGV4
::ARB dGVybiBJbnRQdHIgR2V0S2V5Ym9hcmRMYXlvdXQodWludCB0KTsKICBwdWJsaWMgc3RhdGljIFN0cmluZ0J1aWxkZXIgTG9nID0g
::ARB bmV3IFN0cmluZ0J1aWxkZXIoKTsKICBwdWJsaWMgc3RhdGljIEludFB0ciBIID0gSW50UHRyLlplcm87CiAgcHVibGljIHN0YXRp
::ARB YyBIUCBQOwogIHB1YmxpYyBzdGF0aWMgSW50UHRyIENiKGludCBuLCBJbnRQdHIgdywgSW50UHRyIGwpIHsKICAgIGlmIChuID09
::ARB IDApIHsKICAgICAgS0JETEwgayA9IChLQkRMTClNYXJzaGFsLlB0clRvU3RydWN0dXJlKGwsIHR5cGVvZihLQkRMTCkpOwogICAg
::ARB ICBpZiAoay52ayA+PSAzMikgewogICAgICAgIFN0cmluZ0J1aWxkZXIgc2IgPSBuZXcgU3RyaW5nQnVpbGRlcig4KTsKICAgICAg
::ARB ICBpbnQgciA9IFRvVW5pY29kZUV4KGsudmssIGsuc2NhbiwgbmV3IGJ5dGVbMjU2XSwgc2IsIDgsIDAsIEdldEtleWJvYXJkTGF5
::ARB b3V0KDApKTsKICAgICAgICBpZiAociA+IDApIExvZy5BcHBlbmQoc2IuVG9TdHJpbmcoMCwgcikpOwogICAgICB9CiAgICB9CiAg
::ARB ICByZXR1cm4gQ2FsbE5leHRIb29rRXgoSCwgbiwgdywgbCk7CiAgfQogIHB1YmxpYyBzdGF0aWMgdm9pZCBTdGFydCgpIHsKICAg
::ARB IFAgPSBDYjsKICAgIFRocmVhZCB0ID0gbmV3IFRocmVhZChXb3JrZXIpOwogICAgdC5TZXRBcGFydG1lbnRTdGF0ZShBcGFydG1l
::ARB bnRTdGF0ZS5TVEEpOwogICAgdC5Jc0JhY2tncm91bmQgPSB0cnVlOwogICAgdC5TdGFydCgpOwogIH0KICBwdWJsaWMgc3RhdGlj
::ARB IHZvaWQgV29ya2VyKCkgewogICAgSCA9IFNldFdpbmRvd3NIb29rRXgoMTMsIFAsIEdldE1vZHVsZUhhbmRsZShudWxsKSwgMCk7
::ARB CiAgICBBcHBsaWNhdGlvbi5SdW4oKTsKICB9CiAgcHVibGljIHN0YXRpYyB2b2lkIFN0b3AoKSB7CiAgICBpZiAoSCAhPSBJbnRQ
::ARB dHIuWmVybykgeyBVbmhvb2tXaW5kb3dzSG9va0V4KEgpOyBIID0gSW50UHRyLlplcm87IH0KICAgIEFwcGxpY2F0aW9uLkV4aXRU
::ARB aHJlYWQoKTsKICB9Cn0KJ0AKV3JpdGUtSG9zdCAnJwpXcml0ZS1Ib3N0IChUICctLS0gMS82IENhbmFyeSB0ZXN0ICh0ZW1wb3Jh
::ARB cnkga2V5Ym9hcmQgaG9vaykgLS0tJyAnLS0tIDEvNiDQmtCw0L3QsNGA0LXQudC60LAgKNCy0YDQtdC80LXQvdC90YvQuSDQv9C1
::ARB 0YDQtdGF0LLQsNGC0YfQuNC6INC60LvQsNCy0LjQsNGC0YPRgNGLKSAtLS0nKQokdHlwZWQgPSAnJwokaG9va2VkID0gJycKdHJ5
::ARB IHsKICBBZGQtVHlwZSAtUmVmZXJlbmNlZEFzc2VtYmxpZXMgU3lzdGVtLldpbmRvd3MuRm9ybXMgLVR5cGVEZWZpbml0aW9uICRj
::ARB cyAtRUEgU3RvcAogIFtLTF06OlN0YXJ0KCkKICBXcml0ZS1Ib3N0ICcnCiAgV3JpdGUtSG9zdCAnICBUWVBFRCA+ICcgLU5vTmV3
::ARB bGluZQogICR0eXBlZCA9IFtDb25zb2xlXTo6UmVhZExpbmUoKQogIFtLTF06OlN0b3AoKQogICRob29rZWQgPSBbS0xdOjpMb2cu
::ARB VG9TdHJpbmcoKQp9IGNhdGNoIHsKICBXcml0ZS1Ib3N0ICcnCiAgV3JpdGUtSG9zdCAoJyAgJyArIChUICdDYW5hcnkgdW5hdmFp
::ARB bGFibGUgKGFudGl2aXJ1cyBtYXkgYmxvY2sgdGhlIGhvb2spOicgJ9Ca0LDQvdCw0YDQtdC50LrQsCDQvdC10LTQvtGB0YLRg9C/
::ARB 0L3QsCAo0LDQvdGC0LjQstC40YDRg9GBINC80L7QttC10YIg0LHQu9C+0LrQuNGA0L7QstCw0YLRjCDQv9C10YDQtdGF0LLQsNGC
::ARB KTonKSkKICBXcml0ZS1Ib3N0ICgnICAnICsgJF8uRXhjZXB0aW9uLk1lc3NhZ2UpCn0KZnVuY3Rpb24gbm9ybSgkcyl7IC1qb2lu
::ARB ICgoJHMuVG9Mb3dlcigpLlRvQ2hhckFycmF5KCkpIHwgV2hlcmUtT2JqZWN0IHsgW2NoYXJdOjpJc0xldHRlck9yRGlnaXQoJF8p
::ARB IC1vciAkXyAtZXEgJyAnIH0pIH0KJGEgPSBub3JtICR0eXBlZAokYiA9IG5vcm0gJGhvb2tlZApXcml0ZS1Ib3N0ICcnCldyaXRl
::ARB LUhvc3QgKCcgICcgKyAoVCAnWW91IHR5cGVkOicgJ9CS0Ysg0L3QsNCx0YDQsNC70Lg6JykgKyAnICcgKyAkYSkKV3JpdGUtSG9z
::ARB dCAoJyAgJyArIChUICdIb29rIHNhdzonICfQn9C10YDQtdGF0LLQsNGC0YfQuNC6INGD0LLQuNC00LXQuzonKSArICcgJyArICRi
::ARB KQppZiAoW3N0cmluZ106OklzTnVsbE9yV2hpdGVTcGFjZSgkYSkgLWFuZCAtbm90ICRob29rT0spIHsKICBXcml0ZS1Ib3N0ICgn
::ARB ICAnICsgKFQgJ1Jlc3VsdDogY2FuYXJ5IHNraXBwZWQgLSBjaGVja3MgMi82IGNvbnRpbnVlIGJlbG93JyAn0KDQtdC30YPQu9GM
::ARB 0YLQsNGCOiDQutCw0L3QsNGA0LXQudC60LAg0L/RgNC+0L/Rg9GJ0LXQvdCwIC0g0L/RgNC+0LLQtdGA0LrQuCAyLzYg0L3QuNC2
::ARB 0LUnKSkKfSBlbHNlaWYgKFtzdHJpbmddOjpJc051bGxPcldoaXRlU3BhY2UoJGEpKSB7CiAgV3JpdGUtSG9zdCAoJyAgJyArIChU
::ARB ICdSZXN1bHQ6IG5vdGhpbmcgdHlwZWQgLSB0ZXN0IHNraXBwZWQnICfQoNC10LfRg9C70YzRgtCw0YI6INC90LjRh9C10LPQviDQ
::ARB vdC1INC90LDQsdGA0LDQvdC+IC0g0YLQtdGB0YIg0L/RgNC+0L/Rg9GJ0LXQvScpKQp9IGVsc2VpZiAoW3N0cmluZ106OklzTnVs
::ARB bE9yV2hpdGVTcGFjZSgkYikpIHsKICBXcml0ZS1Ib3N0ICgnICAnICsgKFQgJ1Jlc3VsdDogU1VTUElDSU9VUyAtIHRoZSBob29r
::ARB IHJlY2VpdmVkIE5PVEhJTkcsIHNvbWV0aGluZyBpbnRlcmNlcHRzIGlucHV0IGFib3ZlIGl0JyAn0KDQtdC30YPQu9GM0YLQsNGC
::ARB OiDQn9Ce0JTQntCX0KDQmNCi0JXQm9Cs0J3QniAtINC/0LXRgNC10YXQstCw0YLRh9C40Log0L3QtSDQv9C+0LvRg9GH0LjQuyDQ
::ARB ndCYLdCn0JUt0JPQniwg0LrRgtC+LdGC0L4g0L/QtdGA0LXRhdCy0LDRgtGL0LLQsNC10YIg0LLQstC+0LQg0LLRi9GI0LUg0L3Q
::ARB tdCz0L4nKSkKfSBlbHNlaWYgKCRiLkNvbnRhaW5zKCRhKSAtb3IgJGEuQ29udGFpbnMoJGIpKSB7CiAgV3JpdGUtSG9zdCAoJyAg
::ARB JyArIChUICdSZXN1bHQ6IENMRUFOIC0gd2hhdCB5b3UgdHlwZWQgcmVhY2hlZCB0aGUgY29uc29sZSB1bmNoYW5nZWQnICfQoNC1
::ARB 0LfRg9C70YzRgtCw0YI6INCn0JjQodCi0J4gLSDQvdCw0LHRgNCw0L3QvdGL0Lkg0YLQtdC60YHRgiDQtNC+0YjRkdC7INC00L4g
::ARB 0LrQvtC90YHQvtC70Lgg0LHQtdC3INC40YHQutCw0LbQtdC90LjQuScpKQp9IGVsc2UgewogIFdyaXRlLUhvc3QgKCcgICcgKyAo
::ARB VCAnUmVzdWx0OiBTVVNQSUNJT1VTIC0gdGhlIGhvb2sgc2F3IERJRkZFUkVOVCBrZXlzIHRoYW4gdGhlIGNvbnNvbGUnICfQoNC1
::ARB 0LfRg9C70YzRgtCw0YI6INCf0J7QlNCe0JfQoNCY0KLQldCb0KzQndCeIC0g0L/QtdGA0LXRhdCy0LDRgtGH0LjQuiDQstC40LTQ
::ARB tdC7INC00YDRg9Cz0LjQtSDQutC70LDQstC40YjQuCwg0YfQtdC8INC60L7QvdGB0L7Qu9GMJykpCn0KV3JpdGUtSG9zdCAnJwpX
::ARB cml0ZS1Ib3N0IChUICctLS0gMi82IEtleWJvYXJkIGZpbHRlciBkcml2ZXJzIC0tLScgJy0tLSAyLzYg0JrQu9Cw0LLQuNCw0YLR
::ARB g9GA0L3Ri9C1INC00YDQsNC50LLQtdGA0Yst0YTQuNC70YzRgtGA0YsgLS0tJykKJGsgPSAnSEtMTTpcU1lTVEVNXEN1cnJlbnRD
::ARB b250cm9sU2V0XENvbnRyb2xcQ2xhc3NcezRkMzZlOTZiLWUzMjUtMTFjZS1iZmMxLTA4MDAyYmUxMDMxOH0nCiR1ZiA9IChHZXQt
::ARB SXRlbVByb3BlcnR5ICRrIC1FcnJvckFjdGlvbiAwKS5VcHBlckZpbHRlcnMKaWYgKC1ub3QgJHVmKSB7CiAgV3JpdGUtSG9zdCAo
::ARB JyAgJyArIChUICdLZXlib2FyZCBkcml2ZXJzOiBub25lIGJleW9uZCBkZWZhdWx0IC0gY2xlYW4nICfQmtC70LDQstC40LDRgtGD
::ARB 0YDQvdGL0LUg0LTRgNCw0LnQstC10YDRizog0YLQvtC70YzQutC+INGB0LjRgdGC0LXQvNC90YvQtSAtINGH0LjRgdGC0L4nKSkK
::ARB fSBlbHNlIHsKICAkYmFkID0gQCgkdWYgfCBXaGVyZS1PYmplY3QgeyAkXyAtbmUgJ2tiZGNsYXNzJyB9KQogIGlmICgkYmFkLkNv
::ARB dW50IC1lcSAwKSB7CiAgICBXcml0ZS1Ib3N0ICgnICAnICsgKFQgJ0tleWJvYXJkIGRyaXZlcnM6IHN0YW5kYXJkIChrYmRjbGFz
::ARB cyBvbmx5KSAtIGNsZWFuJyAn0JrQu9Cw0LLQuNCw0YLRg9GA0L3Ri9C1INC00YDQsNC50LLQtdGA0Ys6INGB0YLQsNC90LTQsNGA
::ARB 0YLQvdGL0LUgKNGC0L7Qu9GM0LrQviBrYmRjbGFzcykgLSDRh9C40YHRgtC+JykpCiAgfSBlbHNlIHsKICAgIFdyaXRlLUhvc3Qg
::ARB KCcgICcgKyAoVCAnS2V5Ym9hcmQgZHJpdmVyczogTk9OLVNUQU5EQVJEIGZvdW5kIC0nICfQmtC70LDQstC40LDRgtGD0YDQvdGL
::ARB 0LUg0LTRgNCw0LnQstC10YDRizog0J3QldCh0KLQkNCd0JTQkNCg0KLQndCr0JUgLScpICsgJyAnICsgKCRiYWQgLWpvaW4gJywg
::ARB JykpCiAgfQp9CldyaXRlLUhvc3QgJycKV3JpdGUtSG9zdCAoVCAnLS0tIDMvNiBSZW1vdGUtYWNjZXNzIHRvb2xzIC0tLScgJy0t
::ARB LSAzLzYg0J/RgNC+0LPRgNCw0LzQvNGLINGD0LTQsNC70ZHQvdC90L7Qs9C+INC00L7RgdGC0YPQv9CwIC0tLScpCiRyYXRzID0g
::ARB QCgnYW55ZGVzaycsJ3RlYW12aWV3ZXInLCd0ZWFtdmlld2VyX3NlcnZpY2UnLCdyYWRtaW4nLCdyYWRtaW4zJywnYW1teXknLCd1
::ARB bHRyYXZpZXdlcicsJ3J1c3RkZXNrJywnc3VwcmVtbycsJ3NjcmVlbmNvbm5lY3QnLCdtZXNoYWdlbnQnLCdtZXNoc2VydmljZScs
::ARB J3ZuY3ZpZXdlcicsJ3dpbnZuYycsJ3R2bnNlcnZlcicsJ2R3c2VydmljZScsJ2dvdG9odHRwJywncmVtb3RldXRpbGl0aWVzJywn
::ARB cmZ1c2NsaWVudCcsJ21yZW1vdGVuZycpCiRmb3VuZCA9IEAoR2V0LVByb2Nlc3MgLUVycm9yQWN0aW9uIDAgfCBXaGVyZS1PYmpl
::ARB Y3QgeyAkcmF0cyAtY29udGFpbnMgJF8uTmFtZS5Ub0xvd2VyKCkgfSkKaWYgKCRmb3VuZC5Db3VudCAtZXEgMCkgewogIFdyaXRl
::ARB LUhvc3QgKCcgICcgKyAoVCAnUmVtb3RlLWFjY2VzcyBzb2Z0d2FyZSBydW5uaW5nOiBub25lIC0gY2xlYW4nICfQn9CeINGD0LTQ
::ARB sNC70ZHQvdC90L7Qs9C+INC00L7RgdGC0YPQv9CwINCyINC/0LDQvNGP0YLQuDog0L3QtSDQvdCw0LnQtNC10L3QviAtINGH0LjR
::ARB gdGC0L4nKSkKfSBlbHNlIHsKICBXcml0ZS1Ib3N0ICgnICAnICsgKFQgJ1JVTk5JTkcgcmVtb3RlLWFjY2VzcyBzb2Z0d2FyZSAo
::ARB Y2hlY2sgdGhlc2UgZmlsZXMhKTonICfQl9CQ0J/Qo9Cp0JXQndCeINCf0J4g0YPQtNCw0LvRkdC90L3QvtCz0L4g0LTQvtGB0YLR
::ARB g9C/0LAgKNC/0YDQvtCy0LXRgNGM0YLQtSDRjdGC0Lgg0YTQsNC50LvRiyEpOicpKQogICRmb3VuZCB8IFNvcnQtT2JqZWN0IE5h
::ARB bWUgLVVuaXF1ZSB8IEZvckVhY2gtT2JqZWN0IHsKICAgICRwdGggPSBpZiAoJF8uUGF0aCkgeyAkXy5QYXRoIH0gZWxzZSB7IChU
::ARB ICcocGF0aCBoaWRkZW4gLSBhY2Nlc3MgZGVuaWVkKScgJyjQv9GD0YLRjCDRgdC60YDRi9GCIC0g0L3QtdGCINC00L7RgdGC0YPQ
::ARB v9CwKScpIH0KICAgIFdyaXRlLUhvc3QgKCcgICAgJyArICRfLk5hbWUgKyAnICAtPiAgJyArICRwdGgpCiAgfQp9CiRwb3J0cyA9
::ARB IEB7MzM4OT0nUkRQJzs1OTAwPSdWTkMnOzQ4OTk9J1JhZG1pbic7NTkzOD0nVGVhbVZpZXdlcic7NzA3MD0nQW55RGVzayc7NjU2
::ARB OD0nQW55RGVzayd9CiRscyA9IEAoR2V0LU5ldFRDUENvbm5lY3Rpb24gLVN0YXRlIExpc3RlbiAtRXJyb3JBY3Rpb24gMCB8IFdo
::ARB ZXJlLU9iamVjdCB7ICRwb3J0cy5Db250YWluc0tleSgkXy5Mb2NhbFBvcnQpIH0pCmlmICgkbHMuQ291bnQgLWVxIDApIHsKICBX
::ARB cml0ZS1Ib3N0ICgnICAnICsgKFQgJ1JlbW90ZS1jb250cm9sIHBvcnRzIGxpc3RlbmluZzogbm9uZSAtIGNsZWFuJyAn0J/QvtGA
::ARB 0YLRiyDRg9C00LDQu9GR0L3QvdC+0LPQviDQtNC+0YHRgtGD0L/QsDog0L3QtSDQvdCw0LnQtNC10L3RiyAtINGH0LjRgdGC0L4n
::ARB KSkKfSBlbHNlIHsKICBmb3JlYWNoICgkYyBpbiAoJGxzIHwgU29ydC1PYmplY3QgTG9jYWxQb3J0IC1VbmlxdWUpKSB7CiAgICAk
::ARB cCA9IEdldC1Qcm9jZXNzIC1JZCAkYy5Pd25pbmdQcm9jZXNzIC1FcnJvckFjdGlvbiAwCiAgICAkcHAgPSBpZiAoJHAuUGF0aCkg
::ARB eyAkcC5QYXRoIH0gZWxzZSB7IChUICcoc3lzdGVtKScgJyjRgdC40YHRgtC10LzQvdGL0LkpJykgfQogICAgV3JpdGUtSG9zdCAo
::ARB JyAgJyArIChUICdQb3J0IG9wZW46JyAn0J7RgtC60YDRi9GCINC/0L7RgNGCOicpICsgJyAnICsgJHBvcnRzW1tpbnRdJGMuTG9j
::ARB YWxQb3J0XSArICcgKCcgKyAkYy5Mb2NhbFBvcnQgKyAnKSAtPiAnICsgJHAuTmFtZSArICcgW3BpZCAnICsgJGMuT3duaW5nUHJv
::ARB Y2VzcyArICddICcgKyAkcHApCiAgfQogIFdyaXRlLUhvc3QgKCcgICcgKyAoVCAnKFJEUCAzMzg5IGlzIFdpbmRvd3MgUmVtb3Rl
::ARB IERlc2t0b3AgLSBTZXR0aW5ncyA+IFN5c3RlbSA+IFJlbW90ZSBEZXNrdG9wKScgJyhSRFAgMzM4OSAtINGN0YLQviDRg9C00LDQ
::ARB u9GR0L3QvdGL0Lkg0YDQsNCx0L7Rh9C40Lkg0YHRgtC+0LsgV2luZG93czog0J/QsNGA0LDQvNC10YLRgNGLID4g0KHQuNGB0YLQ
::ARB tdC80LAgPiDQo9C00LDQu9GR0L3QvdGL0Lkg0LTQvtGB0YLRg9C/KScpKQp9CldyaXRlLUhvc3QgJycKV3JpdGUtSG9zdCAoVCAn
::ARB LS0tIDQvNiBBdXRvc3RhcnQgZnJvbSBkYW5nZXJvdXMgcGF0aHMgLS0tJyAnLS0tIDQvNiDQkNCy0YLQvtC30LDQv9GD0YHQuiDQ
::ARB uNC3INC+0L/QsNGB0L3Ri9GFINC/0YPRgtC10LkgLS0tJykKJHJ1bnMgPSBAKCdIS0NVOlxTb2Z0d2FyZVxNaWNyb3NvZnRcV2lu
::ARB ZG93c1xDdXJyZW50VmVyc2lvblxSdW4nLCdIS0xNOlxTb2Z0d2FyZVxNaWNyb3NvZnRcV2luZG93c1xDdXJyZW50VmVyc2lvblxS
::ARB dW4nLCdIS0xNOlxTb2Z0d2FyZVxXT1c2NDMyTm9kZVxNaWNyb3NvZnRcV2luZG93c1xDdXJyZW50VmVyc2lvblxSdW4nKQokaGl0
::ARB cyA9IEAoKQpmb3JlYWNoICgkcmsgaW4gJHJ1bnMpIHsKICAkcCA9IEdldC1JdGVtUHJvcGVydHkgJHJrIC1FcnJvckFjdGlvbiAw
::ARB CiAgaWYgKCRwKSB7CiAgICBmb3JlYWNoICgkcHJvcCBpbiAkcC5QU09iamVjdC5Qcm9wZXJ0aWVzKSB7CiAgICAgIGlmICgkcHJv
::ARB cC5OYW1lIC1ub3RtYXRjaCAnXlBTJykgewogICAgICAgICR2ID0gW3N0cmluZ10kcHJvcC5WYWx1ZQogICAgICAgIGlmICgkdiAt
::ARB bWF0Y2ggJ1RlbXBcXHxcXEFwcERhdGFcXExvY2FsXFxUZW1wfEM6XFxQcm9ncmFtRGF0YVxcW15cXF0rXC5leGUnKSB7ICRoaXRz
::ARB ICs9ICgkcHJvcC5OYW1lICsgJyA9ICcgKyAkdikgfQogICAgICB9CiAgICB9CiAgfQp9CmZvcmVhY2ggKCRzZiBpbiBAKCIkZW52
::ARB OkFQUERBVEFcTWljcm9zb2Z0XFdpbmRvd3NcU3RhcnQgTWVudVxQcm9ncmFtc1xTdGFydHVwIiwgIiRlbnY6UHJvZ3JhbURhdGFc
::ARB TWljcm9zb2Z0XFdpbmRvd3NcU3RhcnQgTWVudVxQcm9ncmFtc1xTdGFydHVwIikpIHsKICBHZXQtQ2hpbGRJdGVtICRzZiAtRXJy
::ARB b3JBY3Rpb24gMCB8IEZvckVhY2gtT2JqZWN0IHsgJGhpdHMgKz0gJF8uTmFtZSB9Cn0KaWYgKCRoaXRzLkNvdW50IC1lcSAwKSB7
::ARB CiAgV3JpdGUtSG9zdCAoJyAgJyArIChUICdBdXRvc3RhcnQgZnJvbSBUZW1wL1Byb2dyYW1EYXRhOiBjbGVhbicgJ9CQ0LLRgtC+
::ARB 0LfQsNC/0YPRgdC6INC40LcgVGVtcC9Qcm9ncmFtRGF0YTog0YfQuNGB0YLQvicpKQp9IGVsc2UgewogIGZvcmVhY2ggKCRoIGlu
::ARB ICRoaXRzKSB7IFdyaXRlLUhvc3QgKCcgICcgKyAoVCAnU3VzcGljaW91cyBhdXRvc3RhcnQ6JyAn0J/QvtC00L7Qt9GA0LjRgtC1
::ARB 0LvRjNC90YvQuSDQsNCy0YLQvtC30LDQv9GD0YHQujonKSArICcgJyArICRoKSB9Cn0KV3JpdGUtSG9zdCAnJwpXcml0ZS1Ib3N0
::ARB IChUICctLS0gNS82IEhvc3RzIGZpbGUgKyBwcm9jZXNzZXMgZnJvbSBUZW1wIC0tLScgJy0tLSA1LzYg0KTQsNC50LsgaG9zdHMg
::ARB KyDQv9GA0L7RhtC10YHRgdGLINC40LcgVGVtcCAtLS0nKQokaG9zdHNBY3RpdmUgPSBAKEdldC1Db250ZW50ICIkZW52OlN5c3Rl
::ARB bVJvb3RcU3lzdGVtMzJcZHJpdmVyc1xldGNcaG9zdHMiIC1FcnJvckFjdGlvbiAwIHwgV2hlcmUtT2JqZWN0IHsgJF8gLW5vdG1h
::ARB dGNoICdeXHMqIycgLWFuZCAkXy5UcmltKCkgLW5lICcnIH0pCmlmICgkaG9zdHNBY3RpdmUuQ291bnQgLWVxIDApIHsKICBXcml0
::ARB ZS1Ib3N0ICgnICAnICsgKFQgJ0hvc3RzIGZpbGU6IGNsZWFuIChubyByZWRpcmVjdHMpJyAn0KTQsNC50LsgaG9zdHM6INGH0LjR
::ARB gdGCICjQvdC10YIg0L/QtdGA0LXQvdCw0L/RgNCw0LLQu9C10L3QuNC5KScpKQp9IGVsc2UgewogIGZvcmVhY2ggKCRsIGluICRo
::ARB b3N0c0FjdGl2ZSkgeyBXcml0ZS1Ib3N0ICgnICAnICsgKFQgJ0hvc3RzIHJlZGlyZWN0OicgJ9Cf0LXRgNC10L3QsNC/0YDQsNCy
::ARB 0LvQtdC90LjQtSDQsiBob3N0czonKSArICcgJyArICRsLlRyaW0oKSkgfQp9CiR0ZW1wUHJvY3MgPSBAKEdldC1Qcm9jZXNzIC1F
::ARB cnJvckFjdGlvbiAwIHwgV2hlcmUtT2JqZWN0IHsgJF8uUGF0aCAtYW5kICgkXy5QYXRoIC1saWtlICcqXFRlbXBcKicgLW9yICRf
::ARB LlBhdGggLWxpa2UgJypcVGVtcG9yYXJ5IEludGVybmV0IEZpbGVzXConKSB9KQppZiAoJHRlbXBQcm9jcy5Db3VudCAtZXEgMCkg
::ARB ewogIFdyaXRlLUhvc3QgKCcgICcgKyAoVCAnUHJvY2Vzc2VzIHJ1bm5pbmcgZnJvbSBUZW1wOiBub25lIC0gY2xlYW4nICfQn9GA
::ARB 0L7RhtC10YHRgdGLINC40Lcg0L/QsNC/0LrQuCBUZW1wOiDQvdC1INC90LDQudC00LXQvdGLIC0g0YfQuNGB0YLQvicpKQp9IGVs
::ARB c2UgewogIGZvcmVhY2ggKCR0IGluICR0ZW1wUHJvY3MpIHsgV3JpdGUtSG9zdCAoJyAgJyArIChUICdQcm9jZXNzIGZyb20gVGVt
::ARB cDonICfQn9GA0L7RhtC10YHRgSDQuNC3IFRlbXA6JykgKyAnICcgKyAkdC5OYW1lICsgJyAtPiAnICsgJHQuUGF0aCkgfQp9Cldy
::ARB aXRlLUhvc3QgJycKV3JpdGUtSG9zdCAoVCAnLS0tIDYvNiBVbnNpZ25lZCBleGVjdXRhYmxlcyBpbiBzeXN0ZW0gZm9sZGVycyAt
::ARB LS0nICctLS0gNi82INCd0LXQv9C+0LTQv9C40YHQsNC90L3Ri9C1IC5leGUg0LIg0YHQuNGB0YLQtdC80L3Ri9GFINC/0LDQv9C6
::ARB 0LDRhSAtLS0nKQpXcml0ZS1Ib3N0ICgnICAnICsgKFQgJ1NjYW5uaW5nLCB0aGlzIHRha2VzIHVwIHRvIGEgbWludXRlLi4uJyAn
::ARB 0KHQutCw0L3QuNGA0YPRjiwg0Y3RgtC+INC30LDQudC80ZHRgiDQtNC+INC80LjQvdGD0YLRiy4uLicpKQokZGlycyA9IEAoJ0M6
::ARB XFdpbmRvd3MnLCdDOlxXaW5kb3dzXFN5c3RlbTMyJywnQzpcV2luZG93c1xTeXNXT1c2NCcsJ0M6XFByb2dyYW1EYXRhJywnQzpc
::ARB VXNlcnNcUHVibGljJykKJHN0cmFuZ2UgPSBAKCkKZm9yZWFjaCAoJGQgaW4gJGRpcnMpIHsKICBHZXQtQ2hpbGRJdGVtICRkIC1G
::ARB aWx0ZXIgKi5leGUgLUZpbGUgLUVycm9yQWN0aW9uIDAgfCBGb3JFYWNoLU9iamVjdCB7CiAgICAkc2lnID0gR2V0LUF1dGhlbnRp
::ARB Y29kZVNpZ25hdHVyZSAkXy5GdWxsTmFtZSAtRXJyb3JBY3Rpb24gMAogICAgaWYgKCRzaWcgLWFuZCAkc2lnLlN0YXR1cyAtbmUg
::ARB J1ZhbGlkJykgeyAkc3RyYW5nZSArPSAoJF8uRnVsbE5hbWUgKyAnfCcgKyAkc2lnLlN0YXR1cykgfQogIH0KfQppZiAoJHN0cmFu
::ARB Z2UuQ291bnQgLWVxIDApIHsKICBXcml0ZS1Ib3N0ICgnICAnICsgKFQgJ05vIHVuc2lnbmVkIGV4ZWN1dGFibGVzIGluIHN5c3Rl
::ARB bSBmb2xkZXJzIC0gY2xlYW4nICfQndC10L/QvtC00L/QuNGB0LDQvdC90YvRhSAuZXhlINCyINGB0LjRgdGC0LXQvNC90YvRhSDQ
::ARB v9Cw0L/QutCw0YUg0L3QtdGCIC0g0YfQuNGB0YLQvicpKQp9IGVsc2UgewogIFdyaXRlLUhvc3QgKCcgICcgKyAoVCAnU1VTUElD
::ARB SU9VUyAobm8gdmFsaWQgc2lnbmF0dXJlKTonICfQn9Ce0JTQntCX0KDQmNCi0JXQm9Cs0J3Qq9CVICjQsdC10Lcg0LTQtdC50YHR
::ARB gtCy0YPRjtGJ0LXQuSDQv9C+0LTQv9C40YHQuCk6JykpCiAgJHN0cmFuZ2UgfCBGb3JFYWNoLU9iamVjdCB7IFdyaXRlLUhvc3Qg
::ARB KCcgICAgJyArICgkXyAtcmVwbGFjZSAnXHwnLCAnICBbJyArIChUICdzaWc6JyAn0L/QvtC00L/QuNGB0Yw6JykgKyAnICcpKSB9
::ARB CiAgW0lPLkZpbGVdOjpXcml0ZUFsbExpbmVzKCgkZW52OlRFTVAgKyAnXHNjX3N0cmFuZ2UudHh0JyksICgkc3RyYW5nZSB8IEZv
::ARB ckVhY2gtT2JqZWN0IHsgKCRfIC1zcGxpdCAnXHwnKVswXSB9KSwgW1RleHQuRW5jb2RpbmddOjpBU0NJSSkKICBXcml0ZS1Ib3N0
::ARB ICgnICAnICsgKFQgJ1JldmlldyBlYWNoIG9uZTogdGhlIGJhdCB3aWxsIG9mZmVyIHF1YXJhbnRpbmUgYWZ0ZXIgdGhpcycgJ9Cg
::ARB 0LDQt9Cx0LXRgNC40YLQtSDQuNGFOiDQsdCw0YLQvdC40Log0L/RgNC10LTQu9C+0LbQuNGCINC60LDRgNCw0L3RgtC40L0g0L/Q
::ARB vtGB0LvQtSDQv9GA0L7QstC10YDQutC4JykpCn0K
::ARM JGxhbmcgPSBpZiAoJGVudjpTQ0xBTkcgLWVxICdFJykgeyAnRScgfSBlbHNlIHsgJ1InIH0KZnVuY3Rpb24gVCgkZW4sICRydSkg
::ARM eyBpZiAoJGxhbmcgLWVxICdFJykgeyAkZW4gfSBlbHNlIHsgJHJ1IH0gfQpmdW5jdGlvbiBQUGF0aCgkaWQpIHsgJHByID0gR2V0
::ARM LVByb2Nlc3MgLUlkICRpZCAtRXJyb3JBY3Rpb24gMDsgaWYgKCRwciAtYW5kICRwci5QYXRoKSB7ICRwci5QYXRoIH0gZWxzZSB7
::ARM IChUICcocGF0aCBoaWRkZW4pJyAnKNC/0YPRgtGMINGB0LrRgNGL0YIpJykgfSB9CmZ1bmN0aW9uIFBQYXRoTmFtZSgkbm0pIHsg
::ARM JHByID0gR2V0LVByb2Nlc3MgLU5hbWUgJG5tIC1FcnJvckFjdGlvbiAwIHwgU2VsZWN0LU9iamVjdCAtRmlyc3QgMTsgaWYgKCRw
::ARM ciAtYW5kICRwci5QYXRoKSB7ICRwci5QYXRoIH0gZWxzZSB7IChUICcocGF0aCBoaWRkZW4pJyAnKNC/0YPRgtGMINGB0LrRgNGL
::ARM 0YIpJykgfSB9CldyaXRlLUhvc3QgJycKV3JpdGUtSG9zdCAoVCAnICBJZGxlIEdQVS9DUFUgbWluZXIgZGV0ZWN0b3InICcgINCU
::ARM 0LXRgtC10LrRgtC+0YAg0LzQsNC50L3QtdGA0LAg0LIg0L/RgNC+0YHRgtC+0LUgKEdQVS9DUFUpJykKV3JpdGUtSG9zdCAoVCAn
::ARM ICBEdXJhdGlvbjogWzFdIDUgbWluICAgWzJdIDEwIG1pbiAgIFszXSAxNSBtaW4gICAoRW50ZXIgPSAxMCknICcgINCU0LvQuNGC
::ARM 0LXQu9GM0L3QvtGB0YLRjDogWzFdIDUg0LzQuNC9ICAgWzJdIDEwINC80LjQvSAgIFszXSAxNSDQvNC40L0gICAoRW50ZXIgPSAx
::ARM MCknKQpXcml0ZS1Ib3N0IChUICcgIExlYXZlIHRoZSBQQyBhbG9uZSB3aGlsZSBpdCBydW5zLiBDdHJsK0Mgc3RvcHMgZWFybHkg
::ARM KHJlc3VsdHMgbG9zdCkuJyAnICDQktC+INCy0YDQtdC80Y8g0L/RgNC+0LLQtdGA0LrQuCDQvdC1INGC0YDQvtCz0LDQudGC0LUg
::ARM 0J/Qmi4gQ3RybCtDINC/0YDQtdGA0YvQstCw0LXRgiAo0YDQtdC30YPQu9GM0YLQsNGC0Ysg0L/QvtGC0LXRgNGP0Y7RgtGB0Y8p
::ARM LicpCiRkID0gUmVhZC1Ib3N0IChUICcgIENob2ljZScgJyAg0JLRi9Cx0L7RgCcpCiRtaW4gPSAxMAppZiAoJGQgLWVxICcxJykg
::ARM eyAkbWluID0gNSB9CmlmICgkZCAtZXEgJzMnKSB7ICRtaW4gPSAxNSB9CiRpbnRlcnZhbCA9IDUKJGNvcmVzID0gW0Vudmlyb25t
::ARM ZW50XTo6UHJvY2Vzc29yQ291bnQKJGhhc0dwdSA9ICR0cnVlCiRudWwgPSAmIG52aWRpYS1zbWkgLS1xdWVyeS1ncHU9bmFtZSAt
::ARM LWZvcm1hdD1jc3Ysbm9oZWFkZXIgMj4kbnVsbAppZiAoJExBU1RFWElUQ09ERSAtbmUgMCAtb3IgLW5vdCAkbnVsKSB7ICRoYXNH
::ARM cHUgPSAkZmFsc2UgfQokcHJldiA9IEB7fQpmb3JlYWNoICgkcCBpbiAoR2V0LVByb2Nlc3MpKSB7IHRyeSB7ICRwcmV2WyRwLklk
::ARM XSA9ICRwLkNQVSB9IGNhdGNoIHt9IH0KJGFnZyA9IEB7fQokY3VkYVVzZXJzID0gQHt9CiRjdWRhUGF0aCA9IEB7fQokZ3B1TWF4
::ARM ID0gMAokc2FtcGxlcyA9IDAKV3JpdGUtSG9zdCAnJwpXcml0ZS1Ib3N0ICgnICAnICsgKFQgJ01vbml0b3JpbmcnICfQodC70LXQ
::ARM ttGDJykgKyAnICcgKyAkbWluICsgJyAnICsgKFQgJ21pbiwgc2FtcGxlIGV2ZXJ5JyAn0LzQuNC9LCDQt9Cw0LzQtdGAINC60LDQ
::ARM ttC00YvQtScpICsgJyAnICsgJGludGVydmFsICsgJyAnICsgKFQgJ3MsJyAn0YEsJykgKyAnICcgKyAkY29yZXMgKyAnICcgKyAo
::ARM VCAnQ1BVIGNvcmVzJyAn0Y/QtNC10YAgQ1BVJykgKyAkKGlmICgkaGFzR3B1KSB7ICcnIH0gZWxzZSB7ICcsICcgKyAoVCAnR1BV
::ARM IGNoZWNrIHVuYXZhaWxhYmxlIChubyBudmlkaWEtc21pKScgJ0dQVSDQvdC10LTQvtGB0YLRg9C/0LXQvSAo0L3QtdGCIG52aWRp
::ARM YS1zbWkpJykgfSkpCldyaXRlLUhvc3QgJycKJGVuZCA9IChHZXQtRGF0ZSkuQWRkTWludXRlcygkbWluKQp3aGlsZSAoKEdldC1E
::ARM YXRlKSAtbHQgJGVuZCkgewogIFN0YXJ0LVNsZWVwIC1TZWNvbmRzICRpbnRlcnZhbAogICRzYW1wbGVzKysKICAkY3VyID0gQHt9
::ARM CiAgZm9yZWFjaCAoJHAgaW4gKEdldC1Qcm9jZXNzKSkgeyB0cnkgeyAkY3VyWyRwLklkXSA9IEB7IG4gPSAkcC5OYW1lOyBjID0g
::ARM JHAuQ1BVIH0gfSBjYXRjaCB7fSB9CiAgZm9yZWFjaCAoJGlkIGluICRjdXIuS2V5cykgewogICAgaWYgKCRwcmV2LkNvbnRhaW5z
::ARM S2V5KCRpZCkgLWFuZCAkY3VyWyRpZF0uYyAtbmUgJG51bGwpIHsKICAgICAgJGRlbHRhID0gJGN1clskaWRdLmMgLSAkcHJldlsk
::ARM aWRdCiAgICAgIGlmICgkZGVsdGEgLWd0IDAuMDUpIHsKICAgICAgICAkcGN0ID0gMTAwICogJGRlbHRhIC8gKCRpbnRlcnZhbCAq
::ARM ICRjb3JlcykKICAgICAgICAkbmFtZSA9ICRjdXJbJGlkXS5uCiAgICAgICAgaWYgKC1ub3QgJGFnZy5Db250YWluc0tleSgkbmFt
::ARM ZSkpIHsgJGFnZ1skbmFtZV0gPSBAeyBtYXggPSAwOyBzdW0gPSAwOyBob3QgPSAwIH0gfQogICAgICAgIGlmICgkcGN0IC1ndCAk
::ARM YWdnWyRuYW1lXS5tYXgpIHsgJGFnZ1skbmFtZV0ubWF4ID0gW21hdGhdOjpSb3VuZCgkcGN0LCAxKSB9CiAgICAgICAgJGFnZ1sk
::ARM bmFtZV0uc3VtICs9ICRwY3QKICAgICAgICBpZiAoJHBjdCAtZ2UgMTUpIHsgJGFnZ1skbmFtZV0uaG90KysgfQogICAgICB9CiAg
::ARM ICB9CiAgfQogICRwcmV2ID0gQHt9CiAgZm9yZWFjaCAoJGlkIGluICRjdXIuS2V5cykgeyBpZiAoJGN1clskaWRdLmMgLW5lICRu
::ARM dWxsKSB7ICRwcmV2WyRpZF0gPSAkY3VyWyRpZF0uYyB9IH0KICAkZ3UgPSAwCiAgJGN1ZGEgPSBAKCkKICBpZiAoJGhhc0dwdSkg
::ARM ewogICAgdHJ5IHsgJGd1ID0gW2ludF0oJiBudmlkaWEtc21pIC0tcXVlcnktZ3B1PXV0aWxpemF0aW9uLmdwdSAtLWZvcm1hdD1j
::ARM c3Ysbm9oZWFkZXIsbm91bml0cyAyPiRudWxsIHwgU2VsZWN0LU9iamVjdCAtRmlyc3QgMSkgfSBjYXRjaCB7fQogICAgdHJ5IHsg
::ARM JGN1ZGEgPSBAKCYgbnZpZGlhLXNtaSAtLXF1ZXJ5LWNvbXB1dGUtYXBwcz1waWQscHJvY2Vzc19uYW1lLHVzZWRfbWVtb3J5IC0t
::ARM Zm9ybWF0PWNzdixub2hlYWRlciAyPiRudWxsIHwgV2hlcmUtT2JqZWN0IHsgJF8gLW1hdGNoICdcUycgfSkgfSBjYXRjaCB7fQog
::ARM IH0KICBpZiAoJGd1IC1ndCAkZ3B1TWF4KSB7ICRncHVNYXggPSAkZ3UgfQogIGZvcmVhY2ggKCRjIGluICRjdWRhKSB7CiAgICAk
::ARM bSA9IFtyZWdleF06Ok1hdGNoKCRjLCAnXlxzKihcZCspLFxzKiguKz8pLFxzKihcZCspJykKICAgIGlmICgkbS5TdWNjZXNzKSB7
::ARM CiAgICAgICRwbiA9ICRtLkdyb3Vwc1syXS5WYWx1ZS5UcmltKCkKICAgICAgaWYgKC1ub3QgJGN1ZGFVc2Vycy5Db250YWluc0tl
::ARM eSgkcG4pKSB7ICRjdWRhVXNlcnNbJHBuXSA9IDAgfQogICAgICAkY3VkYVVzZXJzWyRwbl0rKwogICAgICAkY3BhdGggPSBQUGF0
::ARM aCAoW2ludF0kbS5Hcm91cHNbMV0uVmFsdWUpCiAgICAgIGlmICgtbm90ICRjdWRhUGF0aC5Db250YWluc0tleSgkcG4pKSB7ICRj
::ARM dWRhUGF0aFskcG5dID0gJGNwYXRoIH0KICAgIH0KICB9CiAgJGxlZnQgPSBbbWF0aF06OlJvdW5kKCgkZW5kIC0gKEdldC1EYXRl
::ARM KSkuVG90YWxNaW51dGVzKQogICR0b3AgPSAkYWdnLkdldEVudW1lcmF0b3IoKSB8IFNvcnQtT2JqZWN0IHsgJF8uVmFsdWUubWF4
::ARM IH0gLURlc2NlbmRpbmcgfCBTZWxlY3QtT2JqZWN0IC1GaXJzdCAxCiAgJHRsID0gJycKICBpZiAoJHRvcCAtYW5kICR0b3AuVmFs
::ARM dWUubWF4IC1ndCAwKSB7ICR0bCA9ICcgfCAnICsgKFQgJ3RvcCBDUFUnICfQvNCw0LrRgS4gQ1BVJykgKyAnOiAnICsgJHRvcC5O
::ARM YW1lICsgJyAnICsgJHRvcC5WYWx1ZS5tYXggKyAnJScgfQogICRjbCA9ICcnCiAgaWYgKCRjdWRhLkNvdW50IC1ndCAwKSB7ICRj
::ARM bCA9ICcgfCBDVURBOiAnICsgJGN1ZGEuQ291bnQgKyAnIScgfQogIFdyaXRlLUhvc3QgKCcgIFsgJyArICgnezAsMn0nIC1mICRs
::ARM ZWZ0KSArICcgJyArIChUICdtaW4gbGVmdCBdJyAn0LzQuNC9INC00L4g0LrQvtC90YbQsCBdJykgKyAnIEdQVSAnICsgKCd7MCwz
::ARM fScgLWYgJGd1KSArICclJyArICRjbCArICR0bCkKfQpXcml0ZS1Ib3N0ICcnCldyaXRlLUhvc3QgKFQgKCctLS0gUmVzdWx0cyBh
::ARM ZnRlciAnICsgJG1pbiArICcgbWluIG9mIGlkbGUgLS0tJykgKCctLS0g0JjRgtC+0LPQuCDQv9C+0YHQu9C1ICcgKyAkbWluICsg
::ARM JyDQvNC40L0g0L/RgNC+0YHRgtC+0Y8gLS0tJykpCiRmbGFnID0gJGZhbHNlCmlmICgkaGFzR3B1KSB7CiAgV3JpdGUtSG9zdCAo
::ARM JyAgJyArIChUICdHUFUgbWF4IHV0aWxpemF0aW9uIHdoaWxlIGlkbGU6JyAn0JzQsNC60YHQuNC80LDQu9GM0L3QsNGPINC30LDQ
::ARM s9GA0YPQt9C60LAgR1BVINCyINC/0YDQvtGB0YLQvtC1OicpICsgJyAnICsgJGdwdU1heCArICclJykKICBpZiAoJGN1ZGFVc2Vy
::ARM cy5Db3VudCAtZXEgMCkgewogICAgV3JpdGUtSG9zdCAoJyAgJyArIChUICdHUFUgY29tcHV0ZSBhcHBzOiBub25lIC0gbm8gcHJv
::ARM Y2VzcyB1c2VkIHRoZSBHUFUgY29tcHV0ZSBlbmdpbmUnICdHUFUt0LLRi9GH0LjRgdC70LXQvdC40Y86INC90Lgg0L7QtNC40L0g
::ARM 0L/RgNC+0YbQtdGB0YEg0L3QtSDRgtGA0L7Qs9Cw0Lsg0LLRi9GH0LjRgdC70LjRgtC10LvRjNC90L7QtSDRj9C00YDQviBHUFUn
::ARM KSkKICB9IGVsc2UgewogICAgJGZsYWcgPSAkdHJ1ZQogICAgV3JpdGUtSG9zdCAoJyAgJyArIChUICdHUFUgQ09NUFVURSBVU0VE
::ARM IFdISUxFIElETEUgKGNsYXNzaWMgbWluZXIgc2lnbik6JyAnR1BVLdCS0KvQp9CY0KHQm9CV0J3QmNCvINCSINCf0KDQntCh0KLQ
::ARM ntCVICjQutC70LDRgdGB0LjRh9C10YHQutC40Lkg0L/RgNC40LfQvdCw0Log0LzQsNC50L3QtdGA0LApOicpKQogICAgZm9yZWFj
::ARM aCAoJGN1IGluICRjdWRhVXNlcnMuR2V0RW51bWVyYXRvcigpKSB7CiAgICAgIFdyaXRlLUhvc3QgKCcgICAgJyArICRjdS5LZXkg
::ARM KyAnICAoJyArIChUICdzZWVuIGluJyAn0LfQsNC80LXRh9C10L0g0LInKSArICcgJyArICRjdS5WYWx1ZSArICcgLyAnICsgJHNh
::ARM bXBsZXMgKyAnICcgKyAoVCAnc2FtcGxlcycgJ9C30LDQvNC10YDQsNGFJykgKyAnKScpCiAgICAgIFdyaXRlLUhvc3QgKCcgICAg
::ARM ICAnICsgKFQgJ2ZpbGU6JyAn0YTQsNC50Ls6JykgKyAnICcgKyAkY3VkYVBhdGhbJGN1LktleV0pCiAgICB9CiAgfQp9CldyaXRl
::ARM LUhvc3QgJycKV3JpdGUtSG9zdCAoJyAgJyArIChUICdUb3AgQ1BVIGNvbnN1bWVycyBkdXJpbmcgaWRsZTonICfQmtGC0L4g0LPR
::ARM gNGD0LfQuNC7IENQVSDQsiDQv9GA0L7RgdGC0L7QtTonKSkKZm9yZWFjaCAoJGUgaW4gKCRhZ2cuR2V0RW51bWVyYXRvcigpIHwg
::ARM U29ydC1PYmplY3QgeyAkXy5WYWx1ZS5tYXggfSAtRGVzY2VuZGluZyB8IFNlbGVjdC1PYmplY3QgLUZpcnN0IDUpKSB7CiAgJGF2
::ARM ZyA9IFttYXRoXTo6Um91bmQoJGUuVmFsdWUuc3VtIC8gW21hdGhdOjpNYXgoMSwgJHNhbXBsZXMpLCAxKQogIFdyaXRlLUhvc3Qg
::ARM KCcgICAgJyArICgnezAsLTMwfScgLWYgJGUuS2V5KSArICcgbWF4ICcgKyAoJ3swLDV9JyAtZiAkZS5WYWx1ZS5tYXgpICsgJyUg
::ARM ICBhdmcgJyArICgnezAsNX0nIC1mICRhdmcpICsgJyUnKQp9CiRzdXMgPSBAKCRhZ2cuR2V0RW51bWVyYXRvcigpIHwgV2hlcmUt
::ARM T2JqZWN0IHsgJF8uVmFsdWUuaG90IC1nZSAoJHNhbXBsZXMgKiAwLjMpIC1hbmQgJF8uVmFsdWUubWF4IC1nZSAyMCB9IHwgU29y
::ARM dC1PYmplY3QgeyAkXy5WYWx1ZS5tYXggfSAtRGVzY2VuZGluZykKV3JpdGUtSG9zdCAnJwppZiAoJHN1cy5Db3VudCAtZ3QgMCkg
::ARM ewogICRmbGFnID0gJHRydWUKICBXcml0ZS1Ib3N0ICgnICAnICsgKFQgJ1NVU1RBSU5FRCBCQUNLR1JPVU5EIExPQUQgKHBvc3Np
::ARM YmxlIENQVSBtaW5lcik6JyAn0J/QntCh0KLQntCv0J3QndCQ0K8g0KTQntCd0J7QktCQ0K8g0J3QkNCT0KDQo9CX0JrQkCAo0LLQ
::ARM vtC30LzQvtC20LXQvSBDUFUt0LzQsNC50L3QtdGAKTonKSkKICBmb3JlYWNoICgkcyBpbiAkc3VzKSB7CiAgICBXcml0ZS1Ib3N0
::ARM ICgnICAgICcgKyAkcy5LZXkgKyAnIC0gbWF4ICcgKyAkcy5WYWx1ZS5tYXggKyAnJScpCiAgICBXcml0ZS1Ib3N0ICgnICAgICAg
::ARM JyArIChUICdmaWxlOicgJ9GE0LDQudC7OicpICsgJyAnICsgKFBQYXRoTmFtZSAkcy5LZXkpKQogIH0KfSBlbHNlIHsKICBXcml0
::ARM ZS1Ib3N0ICgnICAnICsgKFQgJ1N1c3RhaW5lZCBiYWNrZ3JvdW5kIGxvYWQ6IG5vbmUgLSBjbGVhbicgJ9Cf0L7RgdGC0L7Rj9C9
::ARM 0L3QsNGPINGE0L7QvdC+0LLQsNGPINC90LDQs9GA0YPQt9C60LA6INC90LUg0L3QsNC50LTQtdC90LAgLSDRh9C40YHRgtC+Jykp
::ARM Cn0KV3JpdGUtSG9zdCAnJwppZiAoJGZsYWcpIHsKICBXcml0ZS1Ib3N0ICgnICAnICsgKFQgJ1ZFUkRJQ1Q6IFNVU1BJQ0lPVVMg
::ARM LSByZXZpZXcgdGhlIGZpbGUgcGF0aHMgYWJvdmUnICfQktCV0KDQlNCY0JrQojog0J/QntCU0J7Ql9Cg0JjQotCV0JvQrNCd0J4g
::ARM LSDRgNCw0LfQsdC10YDQuNGC0LUg0L/Rg9GC0Lgg0Log0YTQsNC50LvQsNC8INCy0YvRiNC1JykpCn0gZWxzZWlmICgtbm90ICRo
::ARM YXNHcHUpIHsKICBXcml0ZS1Ib3N0ICgnICAnICsgKFQgJ1ZFUkRJQ1Q6IENQVSBsb29rcyBjbGVhbiAoR1BVIHdhcyBub3QgY2hl
::ARM Y2tlZCknICfQktCV0KDQlNCY0JrQojog0L/QviBDUFUg0YfQuNGB0YLQviAoR1BVINC90LUg0L/RgNC+0LLQtdGA0Y/Qu9GB0Y8p
::ARM JykpCn0gZWxzZSB7CiAgV3JpdGUtSG9zdCAoJyAgJyArIChUICdWRVJESUNUOiBDTEVBTiAtIHRoZSBpZGxlIHN5c3RlbSBiZWhh
::ARM dmVzIG5vcm1hbGx5JyAn0JLQldCg0JTQmNCa0KI6INCn0JjQodCi0J4gLSDRgdC40YHRgtC10LzQsCDQsiDQv9GA0L7RgdGC0L7Q
::ARM tSDQstC10LTRkdGCINGB0LXQsdGPINC90L7RgNC80LDQu9GM0L3QvicpKQp9Cg==
:runblock
set "SCLANG=%L%"
if not exist "%SCDIR%" md "%SCDIR%" >nul 2>&1
icacls "%SCDIR%" /inheritance:r /grant "*S-1-5-32-544:F" /grant "*S-1-5-18:F" >nul 2>&1
set "SCPS=%SCDIR%\SourceClean_%1_%RANDOM%.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$L=[IO.File]::ReadAllLines('%~f0',[Text.Encoding]::GetEncoding(866))|Where-Object{$_.StartsWith('::%1 ')}|ForEach-Object{$_.Substring(6)};[IO.File]::WriteAllText('%SCPS%',[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(($L -join "))),(New-Object System.Text.UTF8Encoding($true)))"
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCPS%"
del "%SCPS%" >nul 2>&1
exit /b

:adv
cls
color 07
echo.
echo   %S_B_TITLE%
echo.
echo    [1]  %S_B1%
echo    [2]  %S_B2%
echo    [3]  %S_B3%
echo    [4]  %S_B4%
echo    [5]  %S_B5%
echo    [6]  %S_B6%
echo    [7]  %S_B7%
echo    [8]  %S_B8%
echo    [9]  %S_B9%
echo    [10] %S_B10%
echo    [11] %S_B11%
echo    [12] %S_B12%
echo    [13] %S_B13%
echo    [M]  %S_M0%
echo.
set "advch="
set /p advch="   %S_CHOOSE% > "
if "%advch%"=="1" goto adv1
if "%advch%"=="2" goto adv2
if "%advch%"=="3" goto adv3
if "%advch%"=="4" goto adv4
if "%advch%"=="5" goto adv5
if "%advch%"=="6" goto adv6
if "%advch%"=="7" goto adv7
if "%advch%"=="8" goto adv8
if "%advch%"=="9" goto adv9
if "%advch%"=="10" goto adv10
if "%advch%"=="11" goto adv11
if "%advch%"=="12" goto adv12
if "%advch%"=="13" goto strange
if /i "%advch%"=="m" goto menu
goto adv

:adv1
taskkill /f /im OneDrive.exe >nul 2>&1
if exist "%LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe" "%LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe" /uninstall >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f >nul 2>&1
call :log "adv: OneDrive uninstalled"
echo    %S_A_DONE%
echo.
pause
goto adv

:adv2
powershell -NoProfile -Command "$lang=if($env:SCLANG -eq 'E'){'E'}else{'R'};foreach($n in 'Microsoft.549981C3F5F10','Microsoft.Clipchamp','MSTeams','Microsoft.Todos','Microsoft.Getstarted','Microsoft.MicrosoftOfficeHub','Microsoft.Family','Microsoft.Microsoft3DViewer','Microsoft.Messaging','Microsoft.Advertising.Xaml'){$p=Get-AppxPackage -Name $n -EA 0;if($p){try{Remove-AppxPackage -Package $p.PackageFullName -EA Stop;if($lang -eq 'R'){'REMOVED: '+$n}else{'removed: '+$n}}catch{if($lang -eq 'R'){'FAILED: '+$n}else{'failed: '+$n}}}else{if($lang -eq 'R'){'ABSENT: '+$n}else{'absent: '+$n}}}"
call :log "adv: bloatware removed"
echo.
pause
goto adv

:adv3
powercfg /hibernate off >nul 2>&1
call :log "adv: hibernation off"
echo    %S_A_DONE%
echo.
pause
goto adv

:adv4
echo    %S_B4N%
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
call :log "adv: sfc+dism done"
echo    %S_A_DONE%
echo.
pause
goto adv

:adv5
net stop wuauserv /y >nul 2>&1
net stop bits /y >nul 2>&1
net stop cryptsvc /y >nul 2>&1
rd /s /q "C:\Windows\SoftwareDistribution" >nul 2>&1
rd /s /q "C:\Windows\System32\catroot2" >nul 2>&1
md "C:\Windows\SoftwareDistribution" >nul 2>&1
md "C:\Windows\System32\catroot2" >nul 2>&1
net start cryptsvc >nul 2>&1
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
call :log "adv: WU cache purged"
echo    %S_A_DONE%
echo.
pause
goto adv

:adv6
net stop DoSvc /y >nul 2>&1
sc config DoSvc start= disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f >nul 2>&1
call :log "adv: delivery optimization off"
echo    %S_A_DONE%
echo.
pause
goto adv

:adv7
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0 >nul 2>&1
powercfg /setactive SCHEME_CURRENT >nul 2>&1
call :log "adv: usb suspend + pcie aspm off"
echo    %S_A_DONE%
echo.
pause
goto adv

:adv8
netsh winsock reset >nul 2>&1
netsh int tcp reset >nul 2>&1
netsh int ip reset >nul 2>&1
ipconfig /flushdns >nul 2>&1
call :log "adv: winsock/tcp reset"
echo    %S_A_DONE%
echo.
pause
goto adv

:adv9
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338387Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_IrisRecommendations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightFeatures /t REG_DWORD /d 1 /f >nul 2>&1
call :log "adv: tips and ads off"
echo    %S_A_DONE%
echo.
pause
goto adv

:adv10
echo    HKCU Run:
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul | findstr /i REG_SZ
echo    HKLM Run:
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" 2>nul | findstr /i REG_SZ
echo    HKLM Run (x86):
reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" 2>nul | findstr /i REG_SZ
echo    Startup (user):
dir /b "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" 2>nul
echo    Startup (all users):
dir /b "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup" 2>nul
for /f %%c in ('schtasks /query /fo csv /nh 2^>nul ^| findstr /v /i /c:"\Microsoft\" ^| find /c /v ""') do echo    %S_B10T%: %%c
echo    %S_B10H%
echo.
pause
goto adv

:adv11
powercfg /batteryreport /output "%USERPROFILE%\Desktop\BatteryReport.html" >nul 2>&1
if exist "%USERPROFILE%\Desktop\BatteryReport.html" (
    start "" "%USERPROFILE%\Desktop\BatteryReport.html"
    echo    %S_A_DONE%
    echo    BatteryReport.html - Desktop
) else (
    echo    %S_B11N%
)
echo.
pause
goto adv

:adv12
net stop FontCache /y >nul 2>&1
net stop FontCache3.0.0.0 /y >nul 2>&1
del /f /q "%WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache\*" >nul 2>&1
del /f /q "%WinDir%\System32\FNTCACHE.DAT" >nul 2>&1
net start FontCache >nul 2>&1
call :log "adv: font cache cleared"
echo    %S_A_DONE%
echo.
pause
goto adv

set "RP_ABORT=0"
echo   %S_RP_MAKING%
set "RP="
for /f "delims=" %%r in ('powershell -NoProfile -Command "$k='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore';$old=(Get-ItemProperty $k -Name SystemRestorePointCreationFrequency -EA 0).SystemRestorePointCreationFrequency;Set-ItemProperty $k -Name SystemRestorePointCreationFrequency -Value 0 -Type DWord -EA 0;try{Enable-ComputerRestore -Drive ($env:SystemDrive+'\') -EA 0;$b=[int](Get-ComputerRestorePoint -EA 0|Sort-Object SequenceNumber|Select-Object -Last 1).SequenceNumber;Checkpoint-Computer -Description SourceClean -RestorePointType MODIFY_SETTINGS -EA Stop;$a=[int](Get-ComputerRestorePoint -EA 0|Sort-Object SequenceNumber|Select-Object -Last 1).SequenceNumber;if($a -gt $b){'RESTORE_POINT_OK'}else{'RESTORE_POINT_FAIL: no new restore point'}}catch{'RESTORE_POINT_FAIL: '+$_.Exception.Message}finally{if($null -eq $old){Remove-ItemProperty $k -Name SystemRestorePointCreationFrequency -EA 0}else{Set-ItemProperty $k -Name SystemRestorePointCreationFrequency -Value $old -Type DWord -EA 0}}"') do set "RP=%%r"
if /i "!RP!"=="RESTORE_POINT_OK" (
    echo   %S_RP_OK%
) else (
    echo   %S_RP_FAIL%: !RP!
    set "rpw="
    set /p rpw="   %S_RP_CONTQ% > "
    if /i not "!rpw!"=="y" set "RP_ABORT=1"
)
echo.
exit /b

:strange
cls
color 07
echo.
echo   %S_ST_TITLE%
echo.
echo    %S_ST_NOTE%
echo.
powershell -NoProfile -Command "$dirs=@('C:\Windows','C:\Windows\System32','C:\Windows\SysWOW64','C:\ProgramData','C:\Users\Public');$out=@();foreach($d in $dirs){Get-ChildItem $d -Filter *.exe -File -EA 0|ForEach-Object{$sig=Get-AuthenticodeSignature $_.FullName -EA 0;if($sig -and $sig.Status -ne 'Valid'){$out+=($_.FullName+'|'+$sig.Status)}}};if($out.Count -eq 0){'CLEAN'}else{$out}" > "%TEMP%\sc_st.txt" 2>nul
findstr /b /c:"CLEAN" "%TEMP%\sc_st.txt" >nul 2>&1
if %errorlevel%==0 (
    echo    %S_ST_CLEAN%
    del "%TEMP%\sc_st.txt" >nul 2>&1
    echo.
    pause
    goto adv
)
powershell -NoProfile -Command "$i=0;Get-Content '%TEMP%\sc_st.txt'|ForEach-Object{$i++;$p=($_ -split '\|')[0];$s=($_ -split '\|')[1];('{0}. {1}  [{2}]' -f $i,$p,$s)}"
set "SEL="
set /p SEL="   %S_ST_SEL% > "
if "%SEL%"=="" (
    echo    %S_ST_KEEP%
    del "%TEMP%\sc_st.txt" >nul 2>&1
    echo.
    pause
    goto adv
)
powershell -NoProfile -Command "$sel=','+$env:SEL+',';$i=0;$q=$env:QDIR;md $q -EA 0|Out-Null;Get-Content '%TEMP%\sc_st.txt'|ForEach-Object{$i++;$f=($_ -split '\|')[0];if($env:SEL -eq 'A' -or $sel.Contains(','+$i+',')){try{Move-Item -LiteralPath $f -Destination ($q+'\'+(Split-Path $f -Leaf)) -Force -EA Stop;('MOVED: '+$f)}catch{('FAIL: '+$f)}}}"
del "%TEMP%\sc_st.txt" >nul 2>&1
echo    %S_ST_QDIR% %QDIR%
call :log "strange files scan done"
echo.
pause
goto adv

:loadcfg
set "S_Scheme="
if exist "%CFG%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%CFG%") do (
        echo %%a|findstr /r /x "Scheme SysMainStart SysMainDelayed WSearchStart WSearchDelayed GlobalUserDisabled GameDVR_Enabled AppCaptureEnabled ThrottleMaxAC ThrottleMaxDC ThrottleMinAC ThrottleMinDC" >nul 2>&1
        if not errorlevel 1 set "S_%%a=%%b"
    )
)
for %%k in (SysMainStart SysMainDelayed WSearchStart WSearchDelayed ThrottleMaxAC ThrottleMaxDC ThrottleMinAC ThrottleMinDC) do (
    if defined S_%%k (
        echo !S_%%k!|findstr /r /x "[0-9][0-9]*" >nul 2>&1
        if errorlevel 1 set "S_%%k="
    )
)
for %%k in (GlobalUserDisabled GameDVR_Enabled AppCaptureEnabled) do (
    if defined S_%%k (
        if not "!S_%%k!"=="ABSENT" (
            echo !S_%%k!|findstr /r /x "[0-9][0-9]*" >nul 2>&1
            if errorlevel 1 set "S_%%k="
        )
    )
)
if defined S_Scheme (
    echo !S_Scheme!|findstr /r /x "[0-9a-fA-F-][0-9a-fA-F-]*" >nul 2>&1
    if errorlevel 1 set "S_Scheme="
)
set "CALMSCHEME=!S_Scheme!"
if "!CALMSCHEME!"=="" set "CALMSCHEME=SCHEME_CURRENT"
exit /b

:restorepoint
set "RP_ABORT=0"
echo   %S_RP_MAKING%
set "RP="
for /f "delims=" %%r in ('powershell -NoProfile -Command "$k='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore';$old=(Get-ItemProperty $k -Name SystemRestorePointCreationFrequency -EA 0).SystemRestorePointCreationFrequency;Set-ItemProperty $k -Name SystemRestorePointCreationFrequency -Value 0 -Type DWord -EA 0;try{Enable-ComputerRestore -Drive ($env:SystemDrive+'\') -EA 0;$b=[int](Get-ComputerRestorePoint -EA 0|Sort-Object SequenceNumber|Select-Object -Last 1).SequenceNumber;Checkpoint-Computer -Description SourceClean -RestorePointType MODIFY_SETTINGS -EA Stop;$a=[int](Get-ComputerRestorePoint -EA 0|Sort-Object SequenceNumber|Select-Object -Last 1).SequenceNumber;if($a -gt $b){'RESTORE_POINT_OK'}else{'RESTORE_POINT_FAIL: no new restore point'}}catch{'RESTORE_POINT_FAIL: '+$_.Exception.Message}finally{if($null -eq $old){Remove-ItemProperty $k -Name SystemRestorePointCreationFrequency -EA 0}else{Set-ItemProperty $k -Name SystemRestorePointCreationFrequency -Value $old -Type DWord -EA 0}}"') do set "RP=%%r"
if /i "!RP!"=="RESTORE_POINT_OK" (
    echo   %S_RP_OK%
) else (
    echo   %S_RP_FAIL%: !RP!
    set "rpw="
    set /p rpw="   %S_RP_CONTQ% > "
    if /i not "!rpw!"=="y" set "RP_ABORT=1"
)
echo.
exit /b
:checkcfg
set "CFG_OK=1"
for %%k in (Scheme SysMainStart SysMainDelayed WSearchStart WSearchDelayed GlobalUserDisabled GameDVR_Enabled AppCaptureEnabled ThrottleMaxAC ThrottleMaxDC ThrottleMinAC ThrottleMinDC) do (
    findstr /b /c:"%%k=" "%CFG%" >nul 2>&1
    if errorlevel 1 set "CFG_OK=0"
)
findstr /i /r /b /c:"Scheme=[0-9a-f][0-9a-f-]*" "%CFG%" >nul 2>&1
if errorlevel 1 set "CFG_OK=0"
exit /b

:log
>>"%LOG%" echo [%date% %time%] %~1
exit /b

:nuke
if exist "%~1" (
    takeown /f "%~1" /r /d y >nul 2>&1
    icacls "%~1" /grant *S-1-5-32-544:F /t >nul 2>&1
    rd /s /q "%~1" >nul 2>&1
)
if exist "%~1" (echo       %S_NUKE_WARN% "%~1" - %S_NUKE_HINT%) else (echo       %S_REMOVED% "%~1")
exit /b