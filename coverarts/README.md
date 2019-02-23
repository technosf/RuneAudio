## Coverarts Browsing for RuneUI Enhancement

Update / Create thumbnails for browsing by coverart from local coverart files or ID3 embedded data. It will take a while depend on numbers of album for the 1st time. Subsequent updates will be on new/changed album/artist names only.
- Directory to save coverarts
	- **RuneUI Enhancement** will create directory `coverarts` in:
		- `USB` - if found and has rw permission
		- `NAS` - if no USB and has rw permission
		- `LocalStorage` (SD) - if the above 2 not available
	- Then create symbolic at `/srv/http/assets/img/coverarts`
- Get **album name** list
	- Albums with duplicate names but different artists not include in the list
- Get **all album** list by **name** and **albumartist** tags (includes `*.cue` file)
	- Fallback to **artist** if not set
	- Compilation albums without **albumartist** create duplicate thumbnails
- Create coverart file
	- Get **file** tag from **album** and **albumartist** tags
	- Check if **thumbnail** already exists
	- If none, Find **coverart file** in directory and create thumbnail
	- If none, find **ID3 embedded covertart** and create thumbnail
	- If none, create **dummy** thumbnail with album name and artist
- Save thumbnails to `/srv/http/assets/img/coverarts`

### To update / change:
- Edit directly in saved directory
	- Delete to replace with new coverarts
	- Delete to remove duplicates
	- Replace with 200x200 px image
- Remove or replace coverart normally then update
- Edit / Correct ID3 tag then update

### `*wav` file albumartist
- Default MPD cannot read **albumartist** data
