Set Folder="C:\updates"
for %%f in (%Folder%\*.msu) do (
  wusa.exe %%f /quiet /norestart
) 