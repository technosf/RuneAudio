```sh
album=$( tail -c 211 '/path/file.wav' | head -c 98 )
artist=$( tail -c 100 '/path/file.wav' | head -c 14 )
albumartist=$( tail -c 73 '/path/file.wav' | head -c 20 )
```
