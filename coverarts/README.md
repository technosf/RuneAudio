## Coverarts Browsing for RuneUI Enhancement

Update / Create thumbnails for browsing by coverart from local coverart files or ID3 embedded data.
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
- Save thumbnails to **/srv/http/assets/img/coverarts**

To change:
	- Remove or replace coverart normally then update
	- Correct ID3 tag then update
	- Edit dirrectly in saved directory
		- Replace with 200x200 px image
		- Delete to remove duplicates
