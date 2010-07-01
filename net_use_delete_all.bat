@echo off

setlocal

for /f "usebackq tokens=1-3" %%i in (`net use`) do (
  if "x%%i" == "xDisconnected" (
    if "x%%j" == "x" (
      echo deleting %%k
      net use /delete %%k
    ) else (
      if not %%j == %HOMEDRIVE% (
        echo deleting %%j
        net use /delete %%j
      )
    )
  )
)

net use

endlocal
