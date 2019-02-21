## Coverarts Browsing for RuneUI Enhancement

Update / Create thumbnails for browsing by coverart from local coverart files or ID3 embedded data. It will take a while depend on numbers of album for the 1st time. Subsequent updates will be on new/changed album/artist names only.
- Directory to save caverarts
	- **RuneUI Enhancement** will create directory `coverarts` in:
		- `USB` - if found and has rw permission
		- `NAS` - if no USB and has rw permission
		- `LocalStorage` (SD) - if the above 2 not available
	- Then create symbolic at `/srv/http/assets/img/coverarts`
- Get album list by **name**
	- Albums with duplicate names but different artists not include in the list
- Get **all** album list by **name** and **albumartist**
	- Fallback to **artist** if not set
	- Set different **albumartist** for each song in the same album - duplicate thumbnails created
- Create coverart file
	- Get file path from album data
	- Check if thumbnail already exists, skip
	- Find coverart file in that path and create thumbnail
	- If not available, find ID3 embedded covertart and create thumbnail
	- If not available, create dummy thumbnail
- Save thumbnails to `/srv/http/assets/img/coverarts`

### To update / change:
- Edit directly in saved directory
	- Delete to replace with new coverarts
	- Delete to remove duplicates
	- Replace with 200x200 px image
- Remove or replace coverart normally then update
- Edit / Correct ID3 tag then update
