## RuneUI Enhancement - Browse By CoverArt
*(This addon should run with Library context menu in RuneUI Enhancement.)*  

Update / Create thumbnails for browsing by coverart from local coverart files or ID3 embedded data. It will take a while depend on numbers of album for the 1st time. Subsequent updates will be on new/changed album/artist names only.

### Process
(Directory based)
- Get **directory** list.
- Get **album** and **albumartist / artist** name from 1st file/cue in **directory**.
- Find **coverart file** in directory and create thumbnail.
- If none, find **ID3 embedded covertart** and create thumbnail. (skip for `*.cue` or `*.wav`)
- If none, use default `cover.svg` as **dummy** thumbnail.

(The same album with the same artist can have only 1 thumbnail. Unique tags needed.)

### To change:
Any of:
- Long-press on each thumbnail > coverart / delete
- Edit ID3 tags then update
- Replace coverarts normally then update  

(Removed thumbnails will be recreated on next run if ID3 tags and coverarts were still the same.)
