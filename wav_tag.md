```sh
artist=$( tail -c 100 '/path/file.wav' | head -c 14 )
albumartist=$( tail -c 73 '/path/file.wav' | head -c 20 )

```
