## Coverarts Browsing for RuneUI Enhancement

Update / Create thumbnails for browsing by coverart from local coverart files or ID3 embedded data. It will take a while depend on numbers of album for the 1st time. Subsequent updates will be on new/changed album/artist names only.
- Directory `coverarts` to save thumbnails will be created in:
	- `USB` - if found and has rw permission
	- `NAS` - if no USB and has rw permission
	- `LocalStorage` (SD) - if the above 2 not available
	- With symbolic link at `/srv/http/assets/img/coverarts`
- Get **album name** list
	- Albums with duplicate names but different artists not include in the list
- Get **album** list by **name** and **albumartist** tags (includes `*.cue` file)
	- Fallback to **artist** if not set
	- Compilation albums without **albumartist** create duplicate thumbnails
- Get **album** list from `*.cue` files
	- MPD database has no albums from `*.cue` files - not listed in browse by album
	- This will parse and show them in browse by coverart
- Create coverart file
	- Get **file** tag from **album** and **albumartist** tags
	- Check if **thumbnail** already exists
	- If none, Find **coverart file** in directory and create thumbnail
	- If none, find **ID3 embedded covertart** and create thumbnail (skip if `*.cue` or `*.wav`)
	- If none, create **dummy** thumbnail with album name and artist
- Save thumbnails to `/srv/http/assets/img/coverarts`

### To change:
- Remove by long-press on each coverart.
- Edit ID3 tags then update.
- Replace coverarts normally then update.
- Removed thumbnails will be recreated on next scan if ID3 tags and coverarts were still the same.

### Albums with `*.cue` files
- To avoid duplicates, remove `*.cue` files if individual audio files already exist in that directory.

### Albums with `*.wav` files
- Default MPD cannot read **albumartist** data which will fallback to **artist** instead.
- So, only 1 thumbnail will be created for each directory to avoid duplicates.  
- While other file types can be in the same directory or have a duplicate name:
	- To create separate thumbnails, separate albums must be placed in separate directories.
	- To avoid overwrite, albums with `*.wav` files must have unique album names.
