@setlocal
@echo off
setLocal EnableDelayedExpansion

set MYGPG_EMAIL="darren.q@gmail.com"

FOR /F "Tokens=1" %%A IN (
    'gpg --fingerprint %MYGPG_EMAIL% 2^>NUL ^| gawk -F"=" "/Key fingerprint/ {print $2}" ^| sed "s/ //g"'
) DO (
    set MYGPG_FP=%%A
)

@REM #######################################################
@REM ### ENCRYPT USING MY GPG KEY
if "%1"=="-e" (
  gpg --encrypt --armor -r %MYGPG_EMAIL% %2
)

@REM #######################################################
@REM ### ENCRYPT USING PASSPHRASE
if "%1"=="-s" (
  gpg --symmetric --cipher-algo AES256 --armor --verbose %2
)

@REM #######################################################
@REM ### IMPORT GPG KEY (SUPPORTS .ASC)
if "%1"=="-i" (
  set MYGPG_KEY=%2
  set MYGPG_ASC=%MYGPG_KEY:asc=%

@rem if the string does contain asc
if not !MYGPG_ASC!==!MYGPG_KEY! ( 
gpg -d %2 2>NUL | gpg --import
) else (
 gpg --import %2
)

FOR /F "Tokens=1" %%A IN (
    'gpg --fingerprint %MYGPG_EMAIL% 2^>NUL ^| gawk -F"=" "/Key fingerprint/ {print $2}" ^| sed "s/ //g"'
) DO (
    set MYGPG_FP=%%A
)
echo !MYGPG_FP!:6: | gpg --import-ownertrust
)

@REM #######################################################
@REM ### DELETE MY GPG KEY
if "%1"=="-d" (
  gpg --delete-secret-keys --batch --yes %MYGPG_FP% 2>NUL
  gpg --delete-keys --batch --yes %MYGPG_EMAIL% 2>NUL
)

@REM #######################################################
@REM ### FINGERPRINT MY GPG KEY
if "%1"=="-f" (
  if not "!MYGPG_FP!"=="" (
    echo %MYGPG_FP%
  )
)

@REM #######################################################
@REM ### LIST ALL GPG KEYS LOADED IN KEYCHAIN
if "%1"=="-l" (
  gpg --list-keys 2>NUL
  gpg --list-secret-keys 2>NUL
)