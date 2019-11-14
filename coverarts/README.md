## RuneAudio+R e - Browse By CoverArt
*(This addon should run with Library context menu in RuneUI Enhancement.)*  

Update / Create thumbnails for browsing by coverart from local coverart files or ID3 embedded data. It will take a while depend on numbers of album for the 1st time. Subsequent updates will be on new/changed album/artist names only.

### Scope
- Directory for thumbnails: `/srv/http/data/coverarts`
- Directory based as each album normally stored in each directory.
- Compilation albums(multiple artists) 
	- Must be tagged with the same `albumartist` (e.g. Various artist)
	- Otherwise thumbnail created from 1st found file, skip the rest
- An album with the same artist can have only 1 thumbnail. Unique album tag needed to create each thumbnail.
- Untagged files are skipped.

### Process
- Get **directory** list.
- Get **album** and **albumartist / artist** name from 1st file/cue in **directory**.
- Find **coverart file** in directory and create thumbnail.
- If none, find **ID3 embedded covertart** and create thumbnail. (skip for `*.cue` or `*.wav`)
- If none, use default `cover.svg` as **dummy** thumbnail.

### To change:
Any of:
- Long-press on each thumbnail > coverart / delete
- Edit ID3 tags then update
- Replace coverarts normally then update  

(Removed thumbnails will be recreated on next run if ID3 tags and coverarts were still the same.)

### To update:
- All: Library > long-press CoverArt
- Directory: Library > Directory context menu > Update thumbnails
